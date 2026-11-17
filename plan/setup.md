---
тип: инструкция
раздел: инструменты
статус: в работе
цель: "Рабочее окружение на Windows: VS Code, Python, Git, WSL2, инструменты, облака"
теги: [инструменты]
---

# Настройка окружения

Твоя платформа: **Windows, средний ПК**. Всё ниже — бесплатно.

Цель окружения: терминал Linux (для Missing Semester, серверов, сетей), Python, Git, VS Code, инструменты для анализа трафика и безопасности.

---

## 1. Обязательный минимум (сделай в первую неделю)

| Что | Зачем | Ссылка |
|---|---|---|
| **VS Code** | Редактор | `code.visualstudio.com` |
| **Python 3.12+** | Основной язык | `python.org` (при установке отметь "Add to PATH") |
| **Git** | Версии кода | `git-scm.com` |
| **GitHub аккаунт** | Проекты, CS50 `check50` | `github.com` |
| **Windows Terminal** | Нормальный терминал | уже в Windows 10/11, обнови из Microsoft Store |
| **PowerShell 7** | Современный shell | `aka.ms/powershell` |

Проверка (в PowerShell):
```powershell
python --version
git --version
code --version
```

---

## 2. GitHub Student Pack — забери сразу

`education.github.com/pack` → подай заявку (нужен email колледжа + подтверждение). Одобряют обычно за несколько дней.

Что забрать (список меняется — смотри актуальную страницу):

| Плюс | Что даёт тебе |
|---|---|
| **GitHub Pro** | Приватные репозитории, Codespaces |
| **GitHub Copilot Student** | AI-помощник в VS Code (бесплатно для верифицированных студентов) |
| **Codespaces** | 180 ч/мес облачной среды Linux с VS Code в браузере — не нужен мощный ПК |
| **JetBrains (PyCharm/IntelliJ)** | Профессиональные IDE |
| **Microsoft Azure** | $100 кредитов + 25+ сервисов |
| **MongoDB Atlas** | $50 кредитов |
| **CamberCloud** | 40 CPU ч + 5 GPU ч в месяц — для твоих AI-проектов |
| **Frontend Masters / Educative / DataCamp** | 6/6/3 месяца доступа к курсам |
| **Heroku** | $13/мес на 24 месяца — деплой |
| **Домены (.me, .tech, +25 TLD)** | Свой домен для портфолио |
| **Notion, 1Password, MongoDB** | Мелочи, но полезно |

> DigitalOcean из пака убрали в июле 2026. Если встретишь обновлённые гайды с его кредитами — они устарели.

**Сделай в первую неделю:** подай заявку, и как только одобрят — активируй Codespaces и Copilot. Codespaces реально выручит на фазе 1, если ноутбук тянущий.

---

## 3. Linux — WSL2 (главное)

Зачем: 90% учебных материалов по сетям, серверам и безопасности рассчитаны на Linux. Missing Semester, TryHackMe, OverTheWire, CTF — всё Linux.

**Установка WSL2:**
```powershell
wsl --install -d Ubuntu
```
Перезагрузись. После перезагрузки откроется окно Ubuntu — задай пользователя и пароль.

**Проверка:**
```bash
lsb_release -a
uname -a
```

**Полезные команды сразу:**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget net-tools iproute2 dnsutils netcat-openbsd python3-pip build-essential
```

**Обязательно настрой WSL:**
1. В `%UserProfile%\.wslconfig`:
```ini
[wsl2]
memory=6GB
processors=4
localhostForwarding=true
```
2. В `~/.bashrc` — алиасы и пути:
```bash
alias ll='ls -la'
alias ..='cd ..'
export PATH=$PATH:/mnt/c/Users/$USER/bin
```
3. Из VS Code: установи расширение **WSL** и открывай папки через `code .` из WSL.

**Если WSL2 не ставится** (редко, но бывает на старых CPU): ставь VirtualBox + Ubuntu 22.04 LTS (2 ГБ RAM, 40 ГБ диск). Работает медленнее, но все материалы совместимы.

---

## 4. Виртуализация и «свои серверы»

| Инструмент | Зачем | Когда ставить |
|---|---|---|
| **VirtualBox** | Бесплатная виртуализация | Фаза 1 (если нет WSL2) |
| **Docker Desktop** | Контейнеры — база для DevOps и проектов | Фаза 3 |
| **VMware Workstation Player** | Быстрее VirtualBox | Альтернатива |
| **Kali Linux** (в VirtualBox) | Пентест-стенд | Фаза 3, когда дойдёшь до кибербеза |
| **Metasploitable 2** | Специально уязвимая VM для практики | Фаза 3, кибербез |

> Не ставь Kali сейчас. Это 4+ ГБ и ноль пользы без базы. Ставь, когда будешь готов к PortSwigger/THM-практике.

---

## 5. Инструменты по темам

### Сети и трафик
| Инструмент | Зачем | Установка |
|---|---|---|
| **Wireshark** | Анализ пакетов — главный инструмент сетевика | `wireshark.org` |
| **tcpdump** | Захват трафика в терминале (в WSL: `sudo apt install tcpdump`) | apt |
| **iperf3** | Скорость сети между двумя машинами | apt |
| **nslookup / dig / traceroute / ping** | Диагностика | уже есть |
| **Postman / curl** | Тестирование API | `curl` в терминале |

### Кибербез
| Инструмент | Зачем | Где |
|---|---|---|
| **Burp Suite Community** | Перехват и анализ HTTP-запросов — must have для AppSec | `portswigger.net/burp` (бесплатно, Community) |
| **Nmap** | Сканирование портов | `sudo apt install nmap` |
| **John the Ripper / Hashcat** | Подбор паролей/ hashes | apt / hashcat.net |
| **CyberChef** | Работа с шифрами, base64, hex — прямо в браузере | `gchq.github.io/CyberChef` |
| **Ghidra** | Реверс-инжиниринг (позже) | `ghidra-sre.org` |

### Разработка
| Инструмент | Зачем |
|---|---|
| **Jupyter Notebook / VS Code Jupyter** | Для AI/ML-курсов (fast.ai, Kaggle) |
| **Docker** | Фаза 3 |
| **Postman** | REST API |
| **Kaggle Notebooks** | Бесплатный GPU для обучения моделей |

---

## 6. Бесплатные облачные ресурсы (для «настоящих» серверов)

| Провайдер | Что дают бесплатно | Нюанс |
|---|---|---|
| **Oracle Cloud Always Free** | 2 OCPU / 12 GB RAM ARM навсегда + 200 GB диска | В 2026 лимит урезали с 4/24 до 2/12. Иногда можно выбить больше, но не рассчитывай. Регистрация требует карту (списывают ~1$, возвращают) |
| **Azure for Students** | $100 кредитов (из Student Pack) + бесплатные сервисы | Лучший вариант для Windows-проектов и учебных аккаунтов Microsoft |
| **Google Cloud Free Tier** | $300 на 90 дней для новых аккаунтов | Разово, но полезно для AI-инференса |
| **GitHub Codespaces** | 180 ч/мес | Удобно, но не «настоящий» публичный сервер |
| **CamberCloud** | 40 CPU + 5 GPU ч/мес | Для ML-проектов (в Student Pack) |
| **Oracle / Azure / Hetzner-подобные** | — | Всё в одной зоне: не привязывайся к одному |

**Практика «свой сервер»:** после фазы 1 подними на Oracle Cloud:
- Nginx + статический сайт
- Python + Flask API (то, что ты делал в CS50x)
- PostgreSQL
- Docker Compose с 2–3 сервисами
- Простейший CI/CD через GitHub Actions

Именно это потом ляжет в портфолио и даст тебе уверенность на собеседованиях.

---

## 7. Инструменты для английского

| Что | Где |
|---|---|
| **Anki** | `apps.ankiweb.net` (десктоп бесплатно; на телефон — AnkiDroid) |
| **Language Reactor** | Chrome Web Store (расширение) |
| **Grammarly** | Расширение для браузера (бесплатная версия) |
| **DeepL / ChatGPT** | Перевод и разбор ошибок (ChatGPT — как репетитор) |
| **BBC Learning English** | `bbc.co.uk/learningenglish` |
| **3Blue1Brown** | YouTube |
| **Computerphile** | YouTube |

---

## 8. Чек-лист готовности

- [ ] VS Code, Python, Git установлены и работают
- [ ] Заявка на GitHub Student Pack подана
- [ ] WSL2 + Ubuntu установлены, `uname -a` работает
- [ ] VS Code открывает папки в WSL (`code .`)
- [ ] Wireshark установлен (на Windows-хосте)
- [ ] Anki установлен, создана колода `tech-english`
- [ ] Language Reactor установлен в Chrome
- [ ] Заведён репозиторий `learning-log` и сделан первый коммит
- [ ] `curl` и `ping` работают из WSL
