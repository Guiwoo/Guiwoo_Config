import { defineProvider } from "opencode"

export default defineProvider({
  id: "openai",
  models: {
    "gpt-5.3-codex": {
      id: "gpt-5.3-codex",
      kind: "chat",
      description: "GPT-5.3 Codex"
    }
  }
})
