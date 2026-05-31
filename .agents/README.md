# .agents/ — AI Skills for Dotfiles

This directory contains **Agent Skills** — structured instructions that teach AI agents how to perform common tasks with the dotfiles repository.

## What are Agent Skills?

Agent Skills are a lightweight, open format for extending AI agent capabilities with specialized knowledge. Each skill is a folder containing:

- **SKILL.md**: Metadata (name, description) and step-by-step instructions
- **references/**: Reference documentation (loaded on demand by agents)
- **scripts/**: Executable helper scripts (optional)

Learn more: [agentskills.io](https://agentskills.io)

## Available Skills

### create-module

**Name:** `create-module`
**Description:** Scaffold a new dotfiles module with proper directory structure, Brewfile, hook scripts, and registration in personality files.

**When to use:** When creating a new module from scratch, or when you need step-by-step guidance on module structure and conventions.

**Quick start:**
```bash
# Option 1: Let an AI agent guide you through creating a module
# (The agent will read the full create-module skill instructions)

# Option 2: Use the scaffold helper script
.agents/skills/create-module/scripts/create-module.zsh
```

**Key topics covered:**
- Naming conventions (lowercase, hyphens)
- Directory structure and required files
- Brewfile format and best practices
- Hook scripts: when and how to use each one (`_setup.zsh`, `_update.zsh`, `_cleanup.zsh`, `_zshrc.zsh`, `_zprofile.zsh`)
- Registering a new module in personality files
- Testing with `shellcheck`

**Reference docs:**
- [module-anatomy.md](skills/create-module/references/module-anatomy.md) — Detailed file-by-file breakdown with examples
- [hook-scripts.md](skills/create-module/references/hook-scripts.md) — What each hook does, patterns, boilerplate
- [brewfile-reference.md](skills/create-module/references/brewfile-reference.md) — Brewfile syntax and conventions

---

## Using Skills with AI Agents

Skills are designed to be discovered and used by AI agents automatically. When you ask an agent to create a module, it will:

1. **Discover**: Load the skill's name and description
2. **Activate**: Read the full SKILL.md instructions when the task matches
3. **Execute**: Follow the instructions, optionally running bundled scripts

Different agents support skills differently:
- [GitHub Copilot](https://github.com/) — Reads SKILL.md and reference files on demand
- [OpenCode](https://opencode.ai/) — Auto-loads nearby skills
- [Cursor](https://cursor.com/), [Claude Code](https://claude.ai/code), and many others

See [agentskills.io/clients](https://agentskills.io/clients) for a full list of compatible tools.

## Specification

This directory follows the [Agent Skills specification](https://agentskills.io/specification):

```
create-module/
├── SKILL.md                           # Required: metadata + instructions
├── references/
│   ├── module-anatomy.md              # Detailed file reference
│   ├── hook-scripts.md                # Hook script patterns
│   └── brewfile-reference.md          # Brewfile syntax
└── scripts/
    └── create-module.zsh              # Scaffold helper script
```

**Validation:**
```bash
# Validate the SKILL.md frontmatter
skills-ref validate create-module/
```

## Adding More Skills

To add a new skill to this directory:

1. Create a folder: `.agents/skills/<skill-name>/`
2. Add `SKILL.md` with valid YAML frontmatter and Markdown body
3. Optionally add `references/` and `scripts/` directories
4. Keep SKILL.md under 5000 tokens; move detailed docs to reference files
5. Test with: `skills-ref validate .agents/skills/<skill-name>/`

See [Agent Skills best practices](https://agentskills.io/skill-creation/best-practices.md) for guidance.

---

**Questions?** Check [AGENTS.md](../AGENTS.md) for repo-wide guidance, or see [agentskills.io](https://agentskills.io) for skill specification and examples.
