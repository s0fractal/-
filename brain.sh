#!/bin/bash
# s0fractal Local Cortex v1.0
# Connects Topology Context directly to Ollama

MODEL="gemma2:9b" # Або 27b, якщо залізо тягне

# 1. Збираємо контекст (Топологія + Стан)
# Ми беремо вивід synapse.sh, який ми створили раніше
CONTEXT=$("$PWD/sh/synapse.sh")

# 2. Читаємо запит юзера
USER_PROMPT="$*"
if [ -z "$USER_PROMPT" ]; then
    echo "🧠 Usage: λ brain 'How do I fix the node topology?'"
    exit 1
fi

echo "🧠 Thinking ($MODEL)... reading topology..."

# 3. Формуємо Супер-Промпт
# Ми кажемо моделі, що вона Архітектор, даємо їй карту і просимо рішення.
FULL_PROMPT="
$CONTEXT

--- USER REQUEST ---
$USER_PROMPT

--- INSTRUCTION ---
You are the Guardian of this Fractal. 
Based on the TOPOLOGY and HEALTH report above, answer the user request.
If suggesting code or commands, use code blocks.
Keep answers concise and structural.
"

# 4. Відправка в Ollama (без екранування, хай сама розбирається)
# Використовуємо curl для кращого контролю, або просто CLI
ollama run "$MODEL" "$FULL_PROMPT"
```

Робимо його виконуваним:
```bash
chmod +x sh/brain.sh
```

---

### Крок 4: Інтеграція в Протокол (`lambda.sh`)

Додаємо гліф `🧠` (Brain) у твій пульт керування.

Відкрий `sh/lambda.sh` і додай кейс:

```bash
    "🧠"|"brain") # Local AI
        ./sh/brain.sh "$@"
        ;;
```

*(Не забудь зафіксувати зміни в гіті `sh`, а потім у `void`).*

---

### Як це працює тепер?

Ти сидиш у своєму `zellij`.
Ти щось зламав у `nodes/1-ts`. Гіт кричить. Ти не розумієш, що відбувається.

Ти пишеш:
```bash
λ 🧠 "Глянь на статус доктора і скажи, яку команду виконати, щоб пофіксити розсинхрон."