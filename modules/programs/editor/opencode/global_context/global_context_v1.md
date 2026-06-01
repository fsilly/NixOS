# General instructions

1. Intentions leading to the changes : description
2. Type of change : creation, feature, fix, security, other (precise if fix + feature also that shouldn't happen) (if feature was hard to implement but haven't written memory then : feature (bellow you will explain what you did))
3. Goal of the changes being made : description (if file creation then "purpose of the file)
4. major diffs : myer diff (most important if long)
5. Difficulty of implementations encontoured : description
6. How you over come those difficulties, what did you use : documented paragraph
7. Why do believe you believe your decisions were the right : documented paragraph
8. Very short exploration of other possibilities : 1 line
9. conclusion : paragraph
10. TLDR : short desc

## External File Loading

CRITICAL: When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

Instructions:
- Do NOT preemptively load all references - use lazy loading based on actual need
- When loaded, treat content as mandatory instructions that override defaults
- Follow references recursively when needed

## Development Guidelines

For TypeScript code style and best practices: @docs/typescript-guidelines.md
For React component architecture and hooks patterns: @docs/react-patterns.md
For REST API design and error handling: @docs/api-standards.md
For testing strategies and coverage requirements: @test/testing-guidelines.md

## General Guidelines

In general read the agent/ folder and/or the @docs folder
Read the following file immediately as it's relevant to all workflows: @rules/general-guidelines.md.
It's always necessary when you're targeting a file to read its adjacent .memory.md file before editing one and after reading one (for reading ponder if you need to first).
