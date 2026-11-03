#' Serving under pressure in charted men's tennis matches
#'
#' Service points played and won by each player in professional men's
#' matches charted by the Match Charting Project, split into break points,
#' deuce points and all service points. Use it to compare how often a
#' player wins their service points under pressure versus normally.
#'
#' @format A tibble with 15,072 rows and 14 columns. Each row is one player
#'   in one match, counting only points where that player was serving.
#' \describe{
#'   \item{match_id}{Match identifier from the Match Charting Project.}
#'   \item{date}{Date of the match.}
#'   \item{year}{Year of the match.}
#'   \item{tournament}{Tournament name, e.g. "Australian Open".}
#'   \item{round}{Round of the tournament, e.g. "QF" (quarter-final), "F" (final).}
#'   \item{surface}{Court surface: "Hard", "Clay" or "Grass".}
#'   \item{player}{The serving player.}
#'   \item{opponent}{The player returning serve.}
#'   \item{bp_pts}{Break points faced: points where losing would lose the
#'     service game (e.g. 30-40).}
#'   \item{bp_won}{Break points won (saved) by the server.}
#'   \item{deuce_pts}{Points served at deuce (40-40).}
#'   \item{deuce_won}{Deuce points won by the server.}
#'   \item{serve_pts}{All points served in the match.}
#'   \item{serve_won}{All service points won (first- plus second-serve
#'     points won).}
#' }
#'
#' @details
#' Break points and deuce points come from the `KeyPointsServe` file;
#' total service points come from the `Overview` file, because the
#' `STotal` row in `KeyPointsServe` only counts break, game and deuce points.
#'
#' Cleaning steps (see `data-raw/serve_pressure.R`):
#' * Exact duplicate rows were removed.
#' * Matches charted twice with conflicting counts were dropped, because the
#'   correct version cannot be identified.
#' * Two Davis Cup rows (2024-09-15) with values shifted into the wrong
#'   columns were dropped from the match details, removing one match.
#' * Matches before 1990 were removed because too few were recorded per year
#'   to compare players reliably.
#'
#' Matches are charted by volunteers, so the data over-represents
#' well-known players and big matches. It is not a random sample of
#' professional tennis.
#'
#' @source Match Charting Project by Jeff Sackmann / Tennis Abstract,
#'   <https://github.com/JeffSackmann/tennis_MatchChartingProject>.
#'   Licensed under CC BY-NC-SA 4.0
#'   (<https://creativecommons.org/licenses/by-nc-sa/4.0/>).
"serve_pressure"