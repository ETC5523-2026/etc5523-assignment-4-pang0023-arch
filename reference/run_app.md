# Launch the clutchserve Shiny app

Opens the interactive app for exploring how players serve under
pressure.

## Usage

``` r
run_app(...)
```

## Arguments

- ...:

  Further arguments passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html).

## Value

Called for its side effect of launching the app.

## Examples

``` r
if (interactive()) {
  run_app()
}
```
