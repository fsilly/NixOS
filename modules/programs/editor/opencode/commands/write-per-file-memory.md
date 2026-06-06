# Write per file memories
Usage: /write-per-file-memories


## Session.md

Read through the conversation and format a document session.md inside of ./agent/sessions containing every use input and a brief 1 line summary of the agent's implemented understanding of the input.


## Per file memory

For every file you've edited :
0. Create memory file.md with that name format : [file-name].[file-extension].memory.md
1. Update the relevant memory for that file following that format : [^1]
2. if changes are minor then the generated text should be small too in that format : [^1]

---
[^1] :
Respect existing text written by previous instances.
Append at the end :

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
