## code to prepare `serve_pressure` dataset goes here

library(tidyverse)

# Load JeffSackman tennis dataset from GitHub
key_points <- readr::read_csv(
  "https://raw.githubusercontent.com/JeffSackmann/tennis_MatchChartingProject/master/charting-m-stats-KeyPointsServe.csv",
  show_col_types = FALSE
) |> 
  distinct() # Remove duplicated records

matches <- readr::read_csv(
  "https://raw.githubusercontent.com/JeffSackmann/tennis_MatchChartingProject/master/charting-m-matches.csv",
  show_col_types = FALSE
) |> 
  janitor::clean_names()

overview <- readr::read_csv(
  "https://raw.githubusercontent.com/JeffSackmann/tennis_MatchChartingProject/master/charting-m-stats-Overview.csv",
  show_col_types = FALSE
) |> 
  distinct() # Remove duplicated records

# Check for duplicates 
key_points |>  count(match_id, player, row) |> 
  filter(n > 1) |> 
  distinct(match_id)

# Remove duplicates missed in earlier steps
duplicates <- key_points |> 
  count(match_id, player, row) |> 
  filter(n > 1) |> 
  distinct(match_id)

key_points <- key_points |> 
  anti_join(duplicates, by = "match_id")

# Sanity check: should return 0 
key_points |>  
  count(match_id, player, row) |> 
  filter(n > 1) 

# Check distinct surfaces: there 2 surface type recorded wrongly
count(matches, surface)

# Check the rows with the wrong surface recorded
matches |> 
  filter(!surface %in% c("Hard", "Clay", "Grass"))

# Clean matches dataset
match_info <- matches |> 
  # Drop rows that are recorded wrongly 
  filter(surface %in% c("Hard", "Clay", "Grass")) |> 
  mutate(date = lubridate::ymd(date)) |> 
  # Drop variables that have high missingness and unnecesssary for analysis
  select(-time, -charted_by, -court, -umpire)

# Sanity check: Each match should be unique (should return 0 rows)
match_info |> 
  count(match_id) |> 
  filter(n > 1)

# Total service points per player per match
serve_totals <- overview |> 
  # Keep whole-match totals, not individual sets
  filter(set == "Total") |> 
  mutate(serve_won = first_won + second_won) |> 
  select(match_id, player, serve_pts, serve_won)

# Check for duplicates 
overview_duplicates <- serve_totals |> 
  count(match_id, player) |> 
  filter(n > 1) |> 
  distinct(match_id)

overview_duplicates

# Remove duplicates missed in earlier steps
serve_totals <- serve_totals |> 
  anti_join(overview_duplicates, by = "match_id")

# Pivot wider to get one row per player per match
serve_points <- key_points |> 
  filter(row %in% c("BP", "Deuce")) |> 
  select(match_id, player, row, pts, pts_won) |> 
  # values_fill = 0: a player with no BP or Deuce row in a match faced none,
  tidyr::pivot_wider(names_from = row, values_from = c(pts, pts_won),
                     values_fill = 0) |> 
  rename(
    bp_pts    = pts_BP,
    bp_won    = pts_won_BP,
    deuce_pts = pts_Deuce,
    deuce_won = pts_won_Deuce
  )

# Join service totals and match details
serve_points |> 
  anti_join(serve_totals, by = c("match_id", "player"))

serve_points |> 
  anti_join(match_info, by = "match_id") |> 
  distinct(match_id)

serve_pressure <- serve_points |> 
  inner_join(serve_totals, by = c("match_id", "player")) |> 
  inner_join(match_info, by = "match_id") |> 
  mutate(
    opponent = if_else(player == player_1, player_2, player_1),
    year     = lubridate::year(date)
  ) |> 
  filter(serve_pts > 0) |> 
  filter(year >= 1990) |> 
  select(match_id, date, year, tournament, round, surface, player, opponent,
         bp_pts, bp_won, deuce_pts, deuce_won, serve_pts, serve_won) |> 
  arrange(desc(date))


usethis::use_data(serve_pressure, overwrite = TRUE)
