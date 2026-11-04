# clutchserve

Do the greats really serve better when it matters most? The goal for
**clutchserve** is to allow tennis fanatics who want to put the term
“clutch” to the test. It packages point-by-point data on men’s
professional matches with an interactive dashboard to compare how
players serve on pressure points (break points and optionally deuce)
with how they serve on every other point. You can also visualise a
player’s progression over time to see whether they’ve become more clutch
across their career.

**Website:**
<https://etc5523-2026.github.io/etc5523-assignment-4-pang0023-arch/>

## Installation

You can install the development version of clutchserve from
[GitHub](https://github.com/) with:

``` r

# install.packages("pak")
pak::pak("ETC5523-2026/etc5523-assignment-4-pang0023-arch")
```

## Launch the app

``` r

clutchserve::run_app()
```

The app shows every player as a dot on a funnel chart, compared with a
typical player. Use the sidebar to filter by surface, years and choose
what counts as a reliable pressure point and set that as the minimum
number of pressure points. Click a player to see how their serve under
pressure has changed over time.

## Example

[`pressure_gap()`](https://etc5523-2026.github.io/etc5523-assignment-4-pang0023-arch/reference/pressure_gap.md)
summarises each player’s point performance across all their matches
(including pressure points and normal points).

``` r

library(clutchserve)

pressure_gap(serve_pressure) |>
  head()
#> # A tibble: 6 × 12
#>   player         matches pressure_pts pressure_won serve_pts serve_won other_pts
#>   <chr>            <int>        <dbl>        <dbl>     <dbl>     <dbl>     <dbl>
#> 1 Roger Federer      722         3437         2266     59860     41465     56423
#> 2 Novak Djokovic     550         3119         1996     45548     30468     42429
#> 3 Rafael Nadal       424         2598         1659     34693     22879     32095
#> 4 Andy Murray        256         1810         1093     21876     13906     20066
#> 5 Hubert Hurkacz     319         1624         1082     26464     18056     24840
#> 6 Daniil Medved…     284         1579          997     22372     14786     20793
#> # ℹ 5 more variables: other_won <dbl>, pressure_pct <dbl>, other_pct <dbl>,
#> #   gap <dbl>, reliable <lgl>
```

## Data

`serve_pressure` has one row per player per recorded match: 14,570 rows
of men’s matches from 1990 onwards. It comes from [Match Charting
Project](https://github.com/JeffSackmann/tennis_MatchChartingProject) by
Jeff Sackmann, licensed [CC BY-NC-SA
4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). The packaged
data carries the same licence. The script that downloads and cleans it
is in `data-raw/serve_pressure.R`.

The matches are recorded by volunteers, so famous players and big
matches are overrepresented. Results describe the recorded matches, not
every match a player has played. This data should not be taken as a
random sample of professional tennis.

## Licence

The package code is released under the MIT licence. The data is licensed
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

## Generative AI declaration

I used Claude to debug data-cleaning script, edit the layout, styling,
interactivity with ggiraph for the Shiny app, debug reactivity layout
and debugging build_vignette error. I checked and revised all generated
code and text.
