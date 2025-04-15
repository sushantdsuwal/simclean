# simclean 🧼

`simclean` is a lightweight CLI tool that helps you quickly **clean app data (cache, DBs) from iOS Simulators**.

It's especially useful for iOS developers who want to reset specific non-Apple apps on a simulator without restarting or manually navigating directories.

---

## 🔧 Features

- Lists all **running simulators**
- Displays **installed non-Apple apps** for each simulator
- Allows you to **clear app data** with a simple selection
- Built with **pure Bash** – no dependencies

---

## 🚀 Installation

### Option 1: Using Homebrew (recommended)

```sh
brew tap sushantdsuwal/simclean
brew install simclean
```

### Option 2: Manual install

```sh
curl -o simclean https://raw.githubusercontent.com/sushantdsuwal/simclean/main/simclean.sh
chmod +x simclean
sudo mv simclean /usr/local/bin
```

## 🚀 How to Use

Simply run the command in your terminal:

```sh
simclean
```

Follow the interactive prompts to:
1. Select a simulator
2. Choose an app to clean
3. Confirm the data deletion

## ⚠️ Caution
- Only works on running iOS simulators
- Deletes app data containers (e.g., SQLite, preferences, etc.)
- Does not remove the app itself
