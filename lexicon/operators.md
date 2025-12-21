# Glyph Protocol: Operators

Цей файл визначає базові оператори дії в системі s0fractal.
AI-агент повинен використовувати ці гліфи для класифікації дій та генерації комітів.

## Basic Action Operators (Дія)

| Glyph | Name       | Meaning                                      | Context Example |
|-------|------------|----------------------------------------------|-----------------|
| `⊕`   | Genesis    | Creation, Addition, Expanding the system     | `⊕ glyphs: lexicon` |
| `Δ`   | Delta      | Mutation, Change, Refactoring, Editing       | `Δ setup: fix path` |
| `∅`   | Void       | Deletion, Removal, Cleanup, Deprecation      | `∅ cache: clear junk` |
| `⋈`   | Nexus      | Sync, Merge, Join, Integration, Linking      | `⋈ main: update subs` |
| `⚡`   | Spark      | Execution, Trigger, Build, Deployment        | `⚡ deploy: prod` |
| `📦`   | Cargo      | Dependency, Package, Installation (Brew/NPM) | `📦 zellij: install` |
| `🛡️`   | Aegis      | Security, Permissions, Keys, Auth            | `🛡️ ssh: add key` |
| `🐛`   | Glitch     | Bug, Error, Incident, Fix needed             | `🐛 api: 500 error` |
| `λ`   | Lambda     | Function, Script, Logic, Protocol            | `λ script: run` |

## State Indicators (Стан)

| Glyph | Meaning |
|-------|---------|
| `?`   | Query / Waiting for input |
| `!`   | Alert / Important / Breaking Change |
| `✓`   | Success / Verified |
| `✕`   | Failure / Rejected |

