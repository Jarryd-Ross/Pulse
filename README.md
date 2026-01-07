# Valorant Match Ingest & Transform Pipeline

A small data engineering demo project that simulates a realistic analytics pipeline for Valorant match data.
The purpose of this project was to find an entertaining way to practice the fundamentals of data engineering and expose myself to Swift. 

The project consists of:
- A **Swift-based ingestion CLI** that validates, normalizes, and cleans raw match JSON files
- A **Python transformation stage** that converts cleaned data into analytics-ready datasets in CSV and Parquet formats

This repository is intended to demonstrate cross-language data pipelines, schema validation, and analytics-oriented data modeling.

---

## Project Overview

**Ingestion (Swift)**
- Reads mock Valorant match JSON files
- Performs basic validation and cleaning
- Outputs normalized per-match JSON

**Transformation (Python)**
- Aggregates cleaned match data
- Produces player-level analytics datasets
- Writes outputs in CSV and Parquet formats

---

## How to Use (Windows PowerShell)

```powershell
# Build Swift CLI (requires Swift toolchain)
cd swift-ingest
swift build -c release

# Run locally
.\swift-ingest\.build\release\swift-ingest.exe --input ..\data\mock --output ..\data\cleaned 

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
