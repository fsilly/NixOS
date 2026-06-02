# OpenCode Prompt Construction

This document explains how OpenCode assembles everything the LLM sees: system prompt, tool definitions, agent configuration, and instruction files. It focuses on what's dynamic and why.

All paths are relative to the repo root.

---

## How the System Prompt is Built

Four files collaborate to produce the system prompt. The orchestrator is `packages/opencode/src/session/prompt.ts`, which runs the agentic loop. Each iteration, it asks two other modules for content: `system.ts` provides an environment block (model name, working directory, platform, today's date) and selects a provider-specific prompt file, while `instruction.ts` walks the filesystem for `AGENTS.md` / `CLAUDE.md` files and fetches any URL-based instructions from config. These pieces are handed to `llm.ts`, which assembles the final `system` message array and calls `streamText()`.

The provider prompt is chosen by matching the model ID string: Claude gets `anthropic.txt`, GPT/o1/o3 get `beast.txt`, Gemini gets `gemini.txt`, GPT-5 gets `codex_header.txt`, Trinity gets `trinity.txt`, and everything else falls back to `qwen.txt`. These are static `.txt` files in `packages/opencode/src/session/prompt/`. If the active agent defines its own prompt (like `explore` or `compaction`), that replaces the provider prompt entirely. For OpenAI Codex OAuth sessions, the provider prompt is sent via a separate `options.instructions` field rather than the system message.

After assembly, a plugin hook (`experimental.chat.system.transform`) gives plugins a chance to mutate the system array — adding, removing, or replacing entries. There's a safety fallback: if a plugin empties the array, the original is restored. The system array is also restructured for Anthropic's prompt caching — if the first element survived plugin transforms unchanged, the rest is joined into a single string to maintain a cacheable 2-part structure.

### Mode fragments

Several small `.txt` files are injected into the message array (not the system prompt) based on session state. When plan mode is active, `plan.txt` is appended to the last user message. When switching from plan to build, `build-switch.txt` is appended (with the plan file path interpolated in experimental mode). When the model exceeds its step limit, `max-steps.txt` is injected as a fake assistant message to force a summary.

---

## Instruction Files

`packages/opencode/src/session/instruction.ts` handles `AGENTS.md`, `CLAUDE.md`, and `CONTEXT.md` (deprecated). It searches for these filenames in order and stops at the first one found at any directory level. Discovery happens at two points:

**At system prompt time:** it walks from the working directory up to the worktree root, checks global config directories and `~/.claude/CLAUDE.md`, and resolves any paths or URLs from the `instructions` config key. Each file is prefixed with `Instructions from: <path>`.

**During tool execution:** when the `read` tool accesses a file in a subdirectory, it walks up from that file's directory looking for instruction files not already loaded. These are injected into the tool output as `<system-reminder>` blocks. A per-message claim system prevents the same file from being injected twice in one turn.

---

## Agents

All built-in agents are defined in `packages/opencode/src/agent/agent.ts`. There are seven: `build` (the default, full tool access), `plan` (edit tools restricted to plan files), `general` (subagent for multi-step tasks, no todo tools), `explore` (read-only subagent with its own prompt), and three hidden agents for internal tasks — `compaction`, `title`, and `summary` — each with its own prompt file and all tools denied.

Agent definitions are dynamic at init time. A default permission ruleset is constructed (all tools allowed, with gates on doom loops, external directories, `.env` reads, and plan mode tools), then merged with user-specified permissions from `opencode.json`. The config's `agent` key can override model, prompt, temperature, permissions, and more for any agent, or disable agents entirely. User-defined agents can also come from `.opencode/agent/*.md` files with frontmatter.

---

## Tools

### The framework

Every tool is created with `Tool.define()` in `packages/opencode/src/tool/tool.ts`, which wraps the tool's execute function with Zod argument validation and automatic output truncation (2000 lines / 50KB). When output is truncated, the full content is written to a temp file and the model is told to use Grep/Read or delegate to an explore agent to access it.

### The registry

`packages/opencode/src/tool/registry.ts` determines which tools are available. It loads built-in tools, scans `.opencode/tool/` directories and plugin exports for custom tools, and applies two layers of filtering. Some tools are conditionally included based on flags and config (question tool only for interactive clients, LSP tool behind a flag, batch tool behind a config key, plan tools behind a flag). At call time, further filtering happens by model (GPT models get `apply_patch` instead of `edit`/`write`; `websearch`/`codesearch` require the opencode provider or an Exa flag) and by agent permissions. After initialization, a `tool.definition` plugin hook lets plugins mutate each tool's description and parameter schema.

### What's dynamic in tool descriptions

Most tools use a static `.txt` description file. Four have dynamic descriptions:

- **bash** — interpolates the working directory and truncation limits (`${directory}`, `${maxLines}`, `${maxBytes}`) into the `.txt` template.
- **task** — replaces `{agents}` in the `.txt` with a generated list of available subagents, filtered by the calling agent's permissions.
- **skill** — has no `.txt` file at all. Its entire description is built at init from the list of discovered skills, formatted as an XML block with each skill's name, description, and file location. If no skills exist, it says so.
- **websearch** — replaces `{{year}}` with the current year.

### Notable runtime behaviors

**bash** parses commands with tree-sitter to extract individual commands and resolve file paths via `realpath`. Paths outside the project trigger external directory permission checks. The shell environment is extended by a `shell.env` plugin hook.

**read** detects images/PDFs (returned as base64 attachments), binary files (rejected), and text files (line-numbered, capped at 50KB). It also triggers the instruction file discovery described above.

**edit** runs the model's `oldString` through a chain of 9 increasingly fuzzy replacer strategies — from exact match through line-trimmed, whitespace-normalized, indentation-flexible, escape-normalized, and block-anchor matching with Levenshtein distance. After writing, it collects LSP diagnostics and reports errors inline.

**write** is similar to edit but simpler — it generates a diff for permission checks, writes the file, and collects LSP diagnostics from the target file and up to 5 other affected files.

**task** creates a child session for the subagent with restricted permissions (no todo tools, no recursive task calls unless the agent explicitly allows it). The subagent gets its own full prompt cycle.

**batch** executes up to 25 tool calls in parallel, but only built-in registry tools — MCP tools can't be batched.

**plan_enter/plan_exit** prompt the user for confirmation via the question system, then create synthetic user messages to switch agents.

**invalid** is the catch-all for malformed tool calls — when the LLM invokes a tool name that doesn't exist and can't be repaired by lowercasing, it's redirected here.

---

## MCP Tools

MCP tools from connected servers are loaded separately in `prompt.ts`. Their schemas are transformed for model compatibility, and their execute functions are wrapped with permission checks, plugin hooks (`tool.execute.before`/`after`), and output truncation. They're merged into the same tool set as built-in tools.

---

## Skills

`packages/opencode/src/skill/skill.ts` discovers `SKILL.md` files from several locations: `.claude/skills/` and `.agents/skills/` (both global and project-level, for Claude Code compatibility), `.opencode/skill/` directories, config-specified paths, and config-specified URLs (downloaded at init). Each `SKILL.md` is parsed for frontmatter (`name`, `description`) and body content. Project-level skills overwrite global ones on name collision. When the model invokes the `skill` tool, the skill's content is returned with a file listing of the skill's directory.

---

## Compaction

When token usage approaches the model's context limit, `packages/opencode/src/session/compaction.ts` triggers compaction. It uses the `compaction` agent (no tools, its own prompt) to summarize the conversation. A plugin hook (`experimental.session.compacting`) can inject additional context or replace the default prompt entirely. The default asks for a structured summary: Goal, Instructions, Discoveries, Accomplished, Relevant files. Separately, a pruning pass walks backwards through tool outputs, protecting the most recent ~40K tokens and marking older ones as compacted so they're excluded from future calls.

---

## Plugins

Plugins can hook into nearly every stage of prompt construction and tool execution. The key hooks are: `experimental.chat.system.transform` (mutate the system prompt array), `tool.definition` (mutate tool descriptions and schemas), `chat.params` (mutate temperature/topP/topK/options), `chat.message` (mutate user messages), `experimental.chat.messages.transform` (mutate the full message history), `experimental.session.compacting` (customize compaction), `tool.execute.before`/`after` (intercept tool calls), and `shell.env` (extend bash environment). Plugins are loaded from npm packages, `file://` paths, or built-in modules.

---

## What's Static vs. Dynamic

Most of the prompt is assembled from static `.txt` files, but virtually everything about _which_ files are used and _what's interpolated into them_ is determined at runtime:

- **Provider prompt** — static text, but which file is selected depends on the model ID.
- **Environment block** — generated per-call with current model, directory, platform, date.
- **Instruction files** — discovered by walking the filesystem and fetching URLs; also discovered incrementally during tool execution.
- **Agent definitions** — built-in structure with runtime config overrides, permission merging, and skill directory injection.
- **Tool descriptions** — mostly static `.txt` files, but bash, task, skill, and websearch have template substitutions. All tool descriptions can be mutated by plugins.
- **Tool availability** — filtered by flags, config, model ID, and agent permissions at multiple stages.
- **Mode fragments** — static text with runtime-interpolated plan file paths.
- **Compaction prompt** — default template, replaceable by plugins.
