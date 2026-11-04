# Serving under pressure in recorded men's tennis matches

Service points played and won by each player in professional men's
matches charted by the Match Charting Project, split into break points,
deuce points and all service points. Use it to compare how often a
player wins their service points under pressure versus normally.

## Usage

``` r
serve_pressure
```

## Format

A tibble with 14570 rows and 14 columns. Each row is one player in one
match, counting only points where that player was serving.

- match_id:

  Match identifier from the Match Charting Project.

- date:

  Date of the match.

- year:

  Year of the match.

- tournament:

  Tournament name, e.g. "Australian Open".

- round:

  Round of the tournament, e.g. "QF" (quarter-final), "F" (final).

- surface:

  Court surface: "Hard", "Clay" or "Grass".

- player:

  The serving player.

- opponent:

  The player returning serve.

- bp_pts:

  Break points faced: points where losing would lose the service game
  (e.g. 30-40).

- bp_won:

  Break points won (saved) by the server.

- deuce_pts:

  Points served at deuce (40-40).

- deuce_won:

  Deuce points won by the server.

- serve_pts:

  All points served in the match.

- serve_won:

  All service points won (first- plus second-serve points won).

## Source

Match Charting Project by Jeff Sackmann
(<https://github.com/JeffSackmann/tennis_MatchChartingProject>).
Licensed under CC BY-NC-SA 4.0
(<https://creativecommons.org/licenses/by-nc-sa/4.0/>).

## Details

Break points and deuce points come from the `KeyPointsServe` file; total
service points come from the `Overview` file.

Cleaning steps (see `data-raw/serve_pressure.R`):

- Exact duplicate rows were removed.

- Matches charted twice with conflicting counts were dropped, because
  the correct version cannot be identified.

- Two Davis Cup rows (2024-09-15) with values shifted into the wrong
  columns were dropped from the match details, removing one match.

- Matches before 1990 were removed because too few were recorded per
  year to compare players reliably.

Matches are charted by volunteers, so not all data is recorded.
Well-known players and big matches are recorded more often than
lesser-known/ lower ranked players. It should be taken as a random
sample sample of professional tennis.
