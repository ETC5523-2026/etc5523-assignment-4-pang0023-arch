# Compare service points won under pressure versus normally

For each player, add up their service points across the supplied matches
and compares the share won on pressure points with the share won on all
other service points.

## Usage

``` r
pressure_gap(
  data,
  pressure = c("break_points", "break_and_deuce"),
  min_pressure = 100,
  by_year = FALSE
)
```

## Arguments

- data:

  A data frame like
  [serve_pressure](https://etc5523-2026.github.io/etc5523-assignment-4-pang0023-arch/reference/serve_pressure.md).
  Filter it first to the matches you want to compare (e.g. one surface
  or a range of years).

- pressure:

  What counts as a pressure point: `"break_points"` (break points only,
  the default) or `"break_and_deuce"` (break points plus points played
  at deuce).

- min_pressure:

  Minimum number of pressure points a player needs for their comparison
  to be marked as reliable.

- by_year:

  If `TRUE`, gives one row per player per year (for trends over time).
  If `FALSE` (default), one row per player.

## Value

A tibble with one row per player, sorted by the number of pressure
points:

- `matches`: number of charted matches

- `pressure_pts`, `pressure_won`: pressure points served and won

- `other_pts`, `other_won`: all other service points served and won

- `pressure_pct`, `other_pct`: share of points won in each situation

- `gap`: `pressure_pct` minus `other_pct`. Negative means the player
  wins fewer points under pressure than normally.

- `reliable`: `TRUE` if the player served at least `min_pressure`
  pressure points

## Examples

``` r
# All charted matches, break points only
pressure_gap(serve_pressure)
#> # A tibble: 941 × 12
#>    player        matches pressure_pts pressure_won serve_pts serve_won other_pts
#>    <chr>           <int>        <dbl>        <dbl>     <dbl>     <dbl>     <dbl>
#>  1 Roger Federer     722         3437         2266     59860     41465     56423
#>  2 Novak Djokov…     550         3119         1996     45548     30468     42429
#>  3 Rafael Nadal      424         2598         1659     34693     22879     32095
#>  4 Andy Murray       256         1810         1093     21876     13906     20066
#>  5 Hubert Hurka…     319         1624         1082     26464     18056     24840
#>  6 Daniil Medve…     284         1579          997     22372     14786     20793
#>  7 Jannik Sinner     297         1526         1022     23057     15697     21531
#>  8 Andre Agassi      204         1475          939     18674     12075     17199
#>  9 Carlos Alcar…     221         1205          756     17656     11748     16451
#> 10 Dominic Thiem     183         1186          744     14967      9661     13781
#> # ℹ 931 more rows
#> # ℹ 5 more variables: other_won <dbl>, pressure_pct <dbl>, other_pct <dbl>,
#> #   gap <dbl>, reliable <lgl>

# Counting deuce points as pressure too, keeping players with at least 200
pressure_gap(serve_pressure, pressure = "break_and_deuce", min_pressure = 200)
#> # A tibble: 941 × 12
#>    player        matches pressure_pts pressure_won serve_pts serve_won other_pts
#>    <chr>           <int>        <dbl>        <dbl>     <dbl>     <dbl>     <dbl>
#>  1 Roger Federer     722         9340         6332     59860     41465     50520
#>  2 Novak Djokov…     550         8075         5307     45548     30468     37473
#>  3 Rafael Nadal      424         6375         4048     34693     22879     28318
#>  4 Andy Murray       256         4326         2716     21876     13906     17550
#>  5 Hubert Hurka…     319         4229         2886     26464     18056     22235
#>  6 Daniil Medve…     284         4113         2694     22372     14786     18259
#>  7 Jannik Sinner     297         3893         2615     23057     15697     19164
#>  8 Andre Agassi      204         3646         2329     18674     12075     15028
#>  9 Pete Sampras      235         3304         2293     21258     14731     17954
#> 10 Carlos Alcar…     221         3041         1992     17656     11748     14615
#> # ℹ 931 more rows
#> # ℹ 5 more variables: other_won <dbl>, pressure_pct <dbl>, other_pct <dbl>,
#> #   gap <dbl>, reliable <lgl>

# Clay courts only, counting deuce points as pressure too
serve_pressure |>
  dplyr::filter(surface == "Clay") |>
  pressure_gap(pressure = "break_and_deuce")
#> # A tibble: 556 × 12
#>    player        matches pressure_pts pressure_won serve_pts serve_won other_pts
#>    <chr>           <int>        <dbl>        <dbl>     <dbl>     <dbl>     <dbl>
#>  1 Rafael Nadal      165         2469         1565     12417      8080      9948
#>  2 Novak Djokov…     128         2178         1348     10821      6935      8643
#>  3 Roger Federer     130         2106         1345     11236      7379      9130
#>  4 Dominic Thiem      79         1188          753      6147      3939      4959
#>  5 Carlos Alcar…      71         1063          681      5732      3690      4669
#>  6 Casper Ruud        72         1061          696      5517      3602      4456
#>  7 Jannik Sinner      69         1004          637      5435      3558      4431
#>  8 Hubert Hurka…      65          943          617      5541      3683      4598
#>  9 Stefanos Tsi…      62          898          572      4912      3202      4014
#> 10 Lorenzo Muse…      54          869          536      4277      2651      3408
#> # ℹ 546 more rows
#> # ℹ 5 more variables: other_won <dbl>, pressure_pct <dbl>, other_pct <dbl>,
#> #   gap <dbl>, reliable <lgl>
```
