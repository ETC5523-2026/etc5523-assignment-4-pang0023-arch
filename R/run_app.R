#' Launch the clutchserve Shiny app
#'
#' Opens the interactive app for exploring how players serve under pressure.
#'
#' @param ... Further arguments passed to [shiny::runApp()].
#'
#' @return Called for its side effect of launching the app.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function(...) {
  app_dir <- system.file("app", package = "clutchserve")
  if (app_dir == "") rlang::abort("Could not find the app. Try re-installing clutchserve.")
  shiny::runApp(app_dir, ...)
}