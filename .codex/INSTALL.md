# Installing Product Toolkit for Codex

Enable product-toolkit in Codex via native skill discovery.

## Prerequisites

- Git

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/justin-mc-lai/product-toolkit ~/.codex/product-toolkit
   ```

2. **Create the skills symlink:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/product-toolkit ~/.agents/skills/product-toolkit
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\product-toolkit" "$env:USERPROFILE\.codex\product-toolkit"
   ```

3. **Restart Codex** (quit and relaunch the CLI).

## Verify

```bash
ls -la ~/.agents/skills/product-toolkit
```

You should see a symlink (or junction on Windows) to your local clone.

## Updating

```bash
cd ~/.codex/product-toolkit && git pull
```

## Uninstalling

```bash
rm ~/.agents/skills/product-toolkit
```

Optionally delete the clone:

```bash
rm -rf ~/.codex/product-toolkit
```
