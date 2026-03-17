# GitHub Private Bootstrap

A small **universal script** to download and run any asset from a **private GitHub repository**.
Ideal as an entrypoint to automatically install your `autoinstall.sh` or other setup scripts.

---

## ⚡ Features

- Works with **any private GitHub repository**
- Automatic resume for downloads (`curl -C -`)
- Idempotent: can be run multiple times without issues
- **No PAT included in the script** → safe
- Works whether the downloaded asset needs to:
  - execute local Linux commands
  - download additional private assets

---

## 🛠 Requirements

- `bash`
- `curl`
- Internet access
- A **GitHub PAT** (Personal Access Token) with read permissions for the private repository

---

## 🚀 Usage

Run the script **without saving it locally**, providing all required parameters:

```bash
PAT=YOUR_PAT \
USER=USERNAME \
REPO=REPO_NAME \
TAG=TAG_NAME \
FILE=FILE_TO_DOWNLOAD_AND_EXECUTE.sh \
WORKDIR=directory/to/save/files \
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AleDetto/gh-private-bootstrap/main/bootstrap.sh)"
```

## Notes:

- The **bootstrap.sh** script downloads and executes the specified file **directly in memory**.
- **WORKDIR** is optional; if omitted, a default temporary folder will be used.
- The downloaded asset (**FILE**) can either **run local commands** or **download additional assets** as needed because it will inherit all the **ENV** vars declared for **bootstrap.sh**.