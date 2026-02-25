# INSTALL.md — RAG Semantic Paging Setup Guide

## Prerequisites
- Python 3.9+, pip, ~2 GB free disk space

## 1 — Create Project Directory

```bash
mkdir myproject
cd myproject
mkdir docs
```

Your layout will look like this once everything is set up:
```
myproject/
  ├─ venv/         # virtual environment (created below)
  ├─ rag.py        # your code
  ├─ page.file     # cached embeddings + FAISS index + manifest
  └─ docs/         # source PDFs
       ├─ doc1.pdf
       └─ ...
```

## 2 — Create Virtual Environment & Install Dependencies

From inside `myproject/`, create and activate the venv:

```bash
python3 -m venv venv

# macOS/Linux
source venv/bin/activate

# Windows
venv\Scripts\activate
```

Your prompt should now show `(venv)`. Next, upgrade pip and core tools before installing packages:

```bash
pip install --upgrade pip setuptools wheel Pillow
```

Then install the project dependencies:

```bash
pip install faiss-cpu sentence-transformers PyPDF2 requests
```
> GPU users: swap `faiss-cpu` for `faiss-gpu`

> ⚠️ **Always activate the venv before running anything.** If you open a new terminal, re-run the activate command above.

## 3 — Install Ollama
**macOS/Linux:** `curl -fsSL https://ollama.com/install.sh | sh`  
**Windows:** https://ollama.com/download

## 4 — Start Ollama & Pull Model

**Linux:** Ollama should run as a systemd service automatically. Just run:
```bash
ollama pull llama3.2
```

**macOS/Windows:** Requires two terminals.
```bash
# Terminal 1 — keep open the entire time
ollama serve

# Terminal 2 (activate venv here too)
ollama pull llama3.2
```

## 5 — Add Documents
Copy all provided PDFs into `docs/`. The script fails without them.

## 6 — Test Your Installation

Make sure your venv is active, then run:

```python3
# test_install.py
import sys, os, requests as req

print(f"Python {sys.version}\n")
checks = []

for mod, pkg in [("faiss","faiss-cpu"), ("sentence_transformers","sentence-transformers"),
                 ("PyPDF2","PyPDF2"), ("requests","requests"), ("PIL","Pillow")]:
    try:
        __import__(mod); print(f"  [OK] {pkg}"); checks.append(True)
    except ImportError:
        print(f"  [FAIL] {pkg}  →  pip install {pkg}"); checks.append(False)

try:
    req.get("http://127.0.0.1:11434", timeout=3)
    print("  [OK] Ollama running"); checks.append(True)
    models = req.get("http://127.0.0.1:11434/api/tags", timeout=3).json().get("models", [])
    if any("llama3.2" in m["name"] for m in models):
        print("  [OK] llama3.2 available"); checks.append(True)
    else:
        print("  [FAIL] llama3.2 missing  →  ollama pull llama3.2"); checks.append(False)
except Exception:
    print("  [FAIL] Ollama not reachable  →  run: ollama serve"); checks.append(False)

pdfs = sum(1 for f in os.listdir("docs") if f.endswith(".pdf")) if os.path.isdir("docs") else 0
if pdfs:
    print(f"  [OK] {pdfs} PDF(s) in docs/"); checks.append(True)
else:
    print("  [FAIL] docs/ empty or missing  →  add your PDFs"); checks.append(False)

print(f"\n{sum(checks)}/{len(checks)} checks passed" +
      (" — ready!" if all(checks) else " — fix failures above before continuing."))
```

```bash
python test_install.py
```

All checks must pass before running the tutorial.

---

## Troubleshooting

| Error | Fix |
|---|---|
| Connection refused on port 11434 | Run `ollama serve` and keep it open |
| `ollama pull` hangs | Ensure `ollama serve` is running first; try `--insecure` |
| `No module named 'faiss'` | Activate venv first, then `pip install faiss-cpu` |
| `No content found` | Add PDFs to `docs/` |
| `RuntimeError: Ollama error` | `ollama pull llama3.2`, then verify with `ollama list` |
| Slow embedding | Use `faiss-gpu`, or lower `CHUNK_WORDS` in `rag.py` |
| segfault on macOS | `export TOKENIZERS_PARALLELISM=false` before running |
| Stale answers after adding PDFs | `python rag.py --rebuild --query "..."` |

---
*Questions? Post in the course Discord or come to office hours.*