#' Compare service points won under pressure versus normally
#'
#' For each player, add up their service points across the supplied
#' matches and compares the share won on pressure points with the share
#' won on all other service points.
#'
#' @param data A data frame like [serve_pressure]. Filter it first to the
#'   matches you want to compare (e.g. one surface or a range of years).
#' @param pressure What counts as a pressure point: `"break_points"` (break
#'   points only, the default) or `"break_and_deuce"` (break points plus
#'   points played at deuce).
#' @param min_pressure Minimum number of pressure points a player needs for
#'   their comparison to be marked as reliable.
#' @param by_year If `TRUE`, gives one row per player per year (for trends
#'   over time). If `FALSE` (default), one row per player.
#'
#' @return A tibble with one row per player, sorted by the number of
#'   pressure points:
#'   * `matches`: number of charted matches
#'   * `pressure_pts`, `pressure_won`: pressure points served and won
#'   * `other_pts`, `other_won`: all other service points served and won
#'   * `pressure_pct`, `other_pct`: share of points won in each situation
#'   * `gap`: `pressure_pct` minus `other_pct`. Negative means the player
#'     wins fewer points under pressure than normally.
#'   * `reliable`: `TRUE` if the player served at least `min_pressure`
#'     pressure points
#'
#' @examples
#' # All charted matches, break points only
#' pressure_gap(serve_pressure)
#'
#' # Counting deuce points as pressure too, keeping players with at least 200
#' pressure_gap(serve_pressure, pressure = "break_and_deuce", min_pressure = 200)
#' 
#' # Clay courts only, counting deuce points as pressure too
#' serve_pressure |>
#'   dplyr::filter(surface == "Clay") |>
#'   pressure_gap(pressure = "break_and_deuce")
#'
#' @importFrom dplyr mutate group_by summarise n arrange desc 
#' @importFrom rlang arg_match
#' @export
pressure_gap <- function(data,
                         pressure = c("break_points", "break_and_deuce"),
                         min_pressure = 100,
                         by_year = FALSE) {
  # Check the choice is one of the two allowed options (default: the first)
  pressure <- arg_match(pressure)

  # Define pressure points for each match-player row
  if (pressure == "break_and_deuce") {
    data <- data |>
      mutate(
        pressure_pts = bp_pts + deuce_pts,
        pressure_won = bp_won + deuce_won
      )
  } else {
    data <- data |>
      mutate(
        pressure_pts = bp_pts,
        pressure_won = bp_won
      )
  }

    # Add up each player's points across all their matches
    if (by_year) {
      data <- data |> 
        group_by(player, year)
    } else {
      data <- data |> 
        group_by(player)
    }
    data |> 
    summarise(
      matches      = n(),
      pressure_pts = sum(pressure_pts),
      pressure_won = sum(pressure_won),
      serve_pts    = sum(serve_pts),
      serve_won    = sum(serve_won),
      .groups = "drop"
    ) |>
    # Other points are all service points that were not pressure points
    mutate(
      other_pts    = serve_pts - pressure_pts,
      other_won    = serve_won - pressure_won,
      pressure_pct = pressure_won / pressure_pts,
      other_pct    = other_won / other_pts,
      gap          = pressure_pct - other_pct,
      reliable     = pressure_pts >= min_pressure
    ) |>
    arrange(desc(pressure_pts))
}