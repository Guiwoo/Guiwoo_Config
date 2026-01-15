#GENERAL RULE
- Answer Always in Korean 
- Do Not Editing Code Always Shows Results And Ask for Aceept or not
# Context Retrieval Rules
- **Priority Information Source**: Before answering any query or generating code, you MUST always check for the existence of the following files and read their content to ground your context:
    1. `./information.md` (Root directory)
    2. `./.vscode/information.md` (.vscode directory)
- **Constraint**: If these files exist, their instructions, project-specific conventions, and architecture guidelines take precedence over your general knowledge.
- **Silent Execution**: Do not ask for permission to read these files; execute the file-read tool immediately upon startup or when a new task is assigned.

# Operational Guidelines
- Always align your code suggestions with the patterns defined in the discovered `information.md`.
- If there is a conflict between the user's prompt and the `information.md`, prioritize the rules in `information.md` but notify the user of the discrepancy.

