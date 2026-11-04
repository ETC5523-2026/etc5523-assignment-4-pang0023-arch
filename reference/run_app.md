# Launch the clutchserve Shiny app

Opens the interactive app for exploring how players serve under
pressure.

## Usage

``` r
run_app()
```

## Value

Called for its side effect of launching the app.

## Details

The app has a funnel chart comparing every player's pressure-point drop
with a typical player, and a year-by-year chart for one player. Use the
sidebar to filter by surface and years, choose what counts as a pressure
point, and set a minimum number of pressure points.

## Examples

``` r
if (interactive()) {
  run_app()
}
```
