# Valorant Match Ingest & Transform

This project is a small end-to-end data engineering demo showcasing a Swift-based ingestion CLI that validates and cleans mock Valorant match JSON files, and a Python transformation step that produces CSV and Parquet analytics.

Quick start (Windows PowerShell):

```powershell
# Build Swift CLI (requires Swift toolchain)
cd swift-ingest
swift build -c release

# Run locally
.\swift-ingest\.build\release\swift-ingest.exe --input ..\data\mock --output ..\data\cleaned --strict

# Python transform
cd ..\python-transform
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python transform.py --input ..\data\cleaned --output ..\data\analytics
```

Outputs:
- `data/cleaned/` — cleaned JSON per match
- `data/analytics/` — `player_stats.csv` and `player_stats.parquet`
