## 🌌 Meta-Definition for Scripts

Як описувати демонів у `sigma` файлах вищого рівня:

Якщо ти хочеш створити скрипт, який "слухає" зміни (наприклад, Watcher), ти описуєш його як композицію $Y$ і кроку $Step$.

**Приклад Інтенту (Watcher):**
> `Daemon = Y(CheckState -> (Changed? -> Action -> Wait) -> CheckState)`

```yaml
# Example Intent Structure
TYPE: Process
BASIS: Y
STEP:
  - check: "git status --porcelain"
  - condition: "not empty"
  - action: "λ ⋈"
  - delay: "5s"
```

Генератор має перетворити цей YAML на:
* **TS:** `setInterval(() => { ... }, 5000)`
* **SH:** `while true; do ... sleep 5; done`

**Y — це абстракція над часом.**