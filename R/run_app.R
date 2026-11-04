#' Launch the clutchserve Shiny app
#'
#' Opens the interactive app for exploring how players serve under pressure.
#'
#' @details
#' The app has a funnel chart comparing every player's pressure-point drop
#' with a typical player, and a year-by-year chart for one player. Use the
#' sidebar to filter by surface and years, choose what counts as a pressure
#' point, and set a minimum number of pressure points.
#'
#' @return Called for its side effect of launching the app.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {
  app_dir <- system.file("app", package = "clutchserve")
  if (app_dir == "") rlang::abort("Could not find the app. Try re-installing clutchserve.")
  shiny::runApp(app_dir)
}