# GitHub Private Bootstrap

Un piccolo **script universale** per scaricare e avviare qualsiasi asset da un **repo privato GitHub**.
Ideale come entrypoint per installare automaticamente il tuo `autoinstall.sh` o altri script di setup.

---

## ⚡ Caratteristiche

- Funziona con **qualsiasi repo privato GitHub**
- Resume automatico dei download (`curl -C -`)
- Idempotente: puoi rilanciare più volte senza problemi
- Nessun PAT incluso nello script → sicuro
- Funziona sia se l’asset scaricato deve:
  - eseguire comandi Linux locali
  - scaricare altri asset privati

---

## 🛠 Requisiti

- `bash`
- `curl`
- Accesso a internet
- Un **PAT GitHub** con permessi di lettura per il repo privato

---

## 🚀 Uso

Esegui lo script **senza salvarlo in locale**, con tutti i parametri necessari:

```bash
PAT=IL_TUO_PAT \
USER=NOME_UTENTE \
REPO=NOME_REPO \
TAG=NOME_TAG \ #(es. v1.0.0)
FILE=NOME_FILE.sh \ #(il file da scaricare ed eseguire dal repo github privato)
WORKDIR=directory/salvataggio/file \ #(opzionale, se omessa verrà usata una directory di default)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/AleDetto/gh-private-bootstrap/main/bootstrap.sh)"
```

