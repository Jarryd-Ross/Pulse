import argparse
from pathlib import Path
import json
import pandas as pd


def load_matches(input_dir: Path):
    rows = []
    for p in input_dir.glob('*.json'):
        with p.open('r', encoding='utf-8') as f:
            m = json.load(f)
        match_id = m.get('matchId')
        map_name = m.get('map')
        duration = m.get('durationSeconds')
        for team in m.get('teams', []):
            team_id = team.get('teamId')
            team_name = team.get('name')
            score = team.get('score')
            for player in team.get('players', []):
                rows.append({
                    'matchId': match_id,
                    'map': map_name,
                    'durationSeconds': duration,
                    'teamId': team_id,
                    'teamName': team_name,
                    'teamScore': score,
                    'playerId': player.get('playerId'),
                    'playerName': player.get('name'),
                    'agent': player.get('agent'),
                    'kills': player.get('kills'),
                    'deaths': player.get('deaths'),
                    'assists': player.get('assists'),
                })
    return pd.DataFrame(rows)


def aggregate_players(df: pd.DataFrame):
    if df.empty:
        return df
    agg = df.groupby(['playerId','playerName','agent']).agg(
        matches=pd.NamedAgg(column='matchId', aggfunc='nunique'),
        kills=pd.NamedAgg(column='kills', aggfunc='sum'),
        deaths=pd.NamedAgg(column='deaths', aggfunc='sum'),
        assists=pd.NamedAgg(column='assists', aggfunc='sum'),
    ).reset_index()
    agg['kda'] = (agg['kills'] + agg['assists']) / agg['deaths'].replace(0, 1)
    return agg


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()

    input_dir = Path(args.input)
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    df = load_matches(input_dir)
    player_stats = aggregate_players(df)

    csv_path = output_dir / 'player_stats.csv'
    parquet_path = output_dir / 'player_stats.parquet'

    player_stats.to_csv(csv_path, index=False)
    player_stats.to_parquet(parquet_path, index=False)

    print(f'Wrote {csv_path} and {parquet_path}')


if __name__ == '__main__':
    main()
