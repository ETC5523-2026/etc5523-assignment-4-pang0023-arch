library(shiny)
library(bslib)
library(dplyr)
library(ggplot2)


serve_pressure <- clutchserve::serve_pressure

# Colours with meaning: teal = more clutch, coral = less, grey = no clear difference
verdict_colours <- c(
  "More clutch than typical" = "#0F4C5C",
  "Within normal variation"  = "grey60",
  "Less clutch than typical" = "#E07A5F"
)

# Shared tooltip and toolbar settings for both interactive charts
tooltip_css <- "background:white; color:#222; padding:8px;
                border:1px solid #ccc; border-radius:6px; font-size:13px;"
hidden_toolbar <- ggiraph::opts_toolbar(saveaspng = FALSE,
                                        hidden = c("selection", "zoom", "misc"))

ui <- page_navbar(
  title = span(strong("Serving under pressure"), style = "color: #3A5A40;"),
  theme = bs_theme(primary = "#3A5A40"),

  nav_panel(
    "Explore",
    layout_sidebar(
      # Cards take only the height they need, instead of stretching to fill the page
      fillable = FALSE,

      sidebar = sidebar(
        width = 320,
             
        # Make the slider handles look like tennis balls
        tags$style(HTML("
          .irs--shiny .irs-handle {
            width: 22px;
            height: 22px;
            border: none;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
            background: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Ccircle cx='12' cy='12' r='12' fill='%23d4e64a'/%3E%3Cpath d='M3 3.5 C8 8 8 16 3 20.5 M21 3.5 C16 8 16 16 21 20.5' fill='none' stroke='white' stroke-width='1.6'/%3E%3C/svg%3E\") center / cover no-repeat;
          }
        ")),
        h3(strong("Serving when it matters most"), style = "color: #3A5A40;"),
        checkboxGroupInput("surface", strong("Surface"),
                           choices = c("Hard", "Clay", "Grass"),
                           selected = c("Hard", "Clay", "Grass")),

        sliderInput("years", strong("Years"), min = 1990, max = 2026,
                    value = c(1990, 2026), sep = ""),

        radioButtons("pressure", strong("What counts as a pressure point?"),
                     choices = c("Break points only" = "break_points",
                                 "Break points and deuce" = "break_and_deuce")),

        sliderInput("min_pressure", strong("Minimum pressure points per player"),
                    min = 100, max = 300, value = 100, step = 10),
        helpText("Increasing the minimum pressure points keeps only players with more reliable results.")
      ),

      layout_columns(
        col_widths = c(9, 3),

        card(
          full_screen = TRUE,
          card_header(strong("Pressure performance compared with a typical player")),
          ggiraph::girafeOutput("funnel", height = "500px")
        ),

        card(
          card_header(strong("At a glance")),
          textOutput("summary"),
          hr(),
          p(strong("How to read it?"), class = "small mb-1"),
            tags$ul(class = "small text-muted ps-3",
            tags$li("Each dot represents a player."),
            tags$li("Above 0: more clutch than typical. Below 0: less clutch."),
            tags$li("Inside the grey band: no clear difference from a typical player."),
            tags$li("Hover for stats; click a player to see how their serve has changed over time below."),
          )
        )
      ),

      layout_columns(
        col_widths = c(9, 3),

        card(
          full_screen = TRUE,
          card_header(strong("How does a player's serve change over time?")),
          selectizeInput("player", "Player",
                        choices = sort(unique(serve_pressure$player)),
                        selected = "Roger Federer"),
          ggiraph::girafeOutput("trend", height = "350px"),
          p(class = "text-muted small",
          "Click a player on the chart above, or choose one from the dropdown, to see their stats over time.",
          "Dark green line: share of pressure points won each year. Light green line: share",
          "of other service points won. Bigger dots mean more pressure points data",
          "that year, so the result is more reliable. Small dots are based on fewer",
          "data points and show more variation by chance.")
        ),

        card(
          card_header(strong("What to look for?")),
          p(class = "small",
            "The closer the dark line is to the grey line, the less pressure",
            "affects the player. Above it, they serve even better under pressure."),
          p(class = "small",
            "Focus on the overall pattern across years rather than single",
            "years: a swing on a small dot is often just luck."),
          p(class = "small",
            "Try comparing the greats, like Djokovic, Federer, Nadal, Sinner and",
            "Alcaraz. They win more of their service points to begin with, and",
            "their level barely moves under pressure. However, holding serve is only half",
            "the story, how players return matters too.")
        )
      )
    )
  ),

  nav_panel(
    "About",
    card(
      h4(strong("Who is this for?")),
      p("Tennis fanatics who are curious about what it means to 'clutch serve':",
        "explore which players do it best, and whether the great players all",
        "share this skill."),
      h4("Data"),
      p("Men's matches from 1990 onwards, charted point by point by volunteers",
        "for the",
        a("Match Charting Project",
          href = "https://github.com/JeffSackmann/tennis_MatchChartingProject",
          target = "_blank"),
        "(Jeff Sackmann), licensed",
        a("CC BY-NC-SA 4.0",
          href = "https://creativecommons.org/licenses/by-nc-sa/4.0/",
          target = "_blank"),
        "."),
      h4(strong("How the comparison works")),
      tags$ul(
        tags$li("For each player, we find the gap between the share of pressure points won",
                "and the share of other service points won."),
        tags$li("We then compare each player's gap with the typical (median) gap",
                "among the filtered group of players shown. This is the y-axis:",
                "above 0 means the player drops less than typical under pressure,",
                "below 0 means they drop more."),
        tags$li("The grey band is the range this comparison would usually fall in",
                "by chance if the player were exactly typical:",
                "0 ± 1.96 × √(p(1 − p) / n), where p is the typical share of",
                "pressure points won and n is the player's number of pressure",
                "points. A dot inside the band is within normal variation. The",
                "band narrows as the number of pressure points played increases,",
                "because with more points, the gap reflects skill more than luck.")
      ),

      h4(strong("Limitations")),
        tags$ul(
        tags$li("The data is crowd-sourced: volunteers chart the matches they choose",
                "to, so not every match is recorded. Famous players and big matches",
                "are recorded far more often than less popular players. This is not",
                "a random sample, so the results describe the charted matches, not",
                "every match a player has played, and less popular players have",
                "fewer points and less reliable results."),
        tags$li("Opponent strength is not taken into account. A break point against",
                "a great returner is harder to win than one against a weak returner,",
                "and top players often face other top players in the big matches",
                "that get recorded."),
        tags$li("Serving is only part of the equation. This app looks only at points",
                "on a player's own serve, not how they return or handle pressure",
                "on their opponent's serve.")
      )
    )
  )
)

server <- function(input, output, session) {

  # Shared reactivity by funnel chart and summary
  selected_players <- reactive({
    validate(need(length(input$surface) > 0, "Tick at least one surface."))

    players <- serve_pressure |>
      filter(surface %in% input$surface,
             year >= input$years[1],
             year <= input$years[2]) |>
      clutchserve::pressure_gap(pressure = input$pressure,
                                min_pressure = input$min_pressure) |>
      filter(reliable)

    validate(need(
      nrow(players) >= 5,
      paste0("Only ", nrow(players), " players faced at least ",
             input$min_pressure, " pressure points with these settings. ",
             "Lower the minimum, or widen the years or surfaces.")
    ))

    typical_gap <- median(players$gap)
    typical_pct <- median(players$pressure_pct)

    players |>
      mutate(
        vs_typical  = gap - typical_gap,
        luck_limit  = 1.96 * sqrt(typical_pct * (1 - typical_pct) / pressure_pts),
        verdict     = case_when(
          vs_typical >  luck_limit ~ "More clutch than typical",
          vs_typical < -luck_limit ~ "Less clutch than typical",
          TRUE                     ~ "Within normal variation"
        ),
        typical_gap = typical_gap,
        typical_pct = typical_pct
      )
  }, label = "selected_players")

  output$summary <- renderText({
    players <- selected_players()
    typical <- players$typical_gap[1]
    paste0(
      nrow(players), " players shown. A typical player wins ",
      round(abs(typical) * 100, 1), " percentage points ",
      if (typical < 0) "fewer" else "more",
      " of their pressure points than of their other service points. ",
      sum(players$verdict == "More clutch than typical"), " players are likely more clutch and ",
      sum(players$verdict == "Less clutch than typical"), " likely less clutch than a typical player."
    )
  })

  output$funnel <- ggiraph::renderGirafe({
    players <- selected_players()
    typical_pct <- players$typical_pct[1]

    # Outline of the luck band across the range of pressure points
    band <- tibble(pressure_pts = seq(min(players$pressure_pts),
                                      max(players$pressure_pts),
                                      length.out = 200)) |>
      mutate(upper = 1.96 * sqrt(typical_pct * (1 - typical_pct) / pressure_pts),
             lower = -upper)

    # Name the 5 best-measured players and anyone outside the band
    to_label <- players |>
      filter(verdict != "Within normal variation" |
               min_rank(desc(pressure_pts)) <= 5)

    # Stats shown in the tooltip when hovering over a player
    players <- players |>
      mutate(tooltip = paste0(
        "<b>", player, "</b>",
        "<br>Won under pressure: ", scales::percent(pressure_pct, accuracy = 0.1),
        "<br>Won normally: ", scales::percent(other_pct, accuracy = 0.1),
        "<br>Vs typical: ", scales::number(vs_typical, accuracy = 0.1, scale = 100,
                                           suffix = " pts", style_positive = "plus"),
        "<br>", pressure_pts, " pressure points in ", matches, " matches",
        "<br>", verdict
      ))

    plot <- ggplot(players, aes(x = pressure_pts, y = vs_typical)) +
      geom_ribbon(data = band, aes(x = pressure_pts, ymin = lower, ymax = upper),
                  inherit.aes = FALSE, fill = "#F4f1de") +
      geom_hline(yintercept = 0, colour = "grey40") +
      ggiraph::geom_point_interactive(
        aes(colour = verdict, tooltip = tooltip, data_id = player),
        size = 3, alpha = 0.8
      ) +
      ggrepel::geom_text_repel(data = to_label, aes(label = player),
                               size = 3.5, max.overlaps = 20) +
      scale_colour_manual(values = verdict_colours) +
      scale_x_log10() +
      scale_y_continuous(labels = \(x) paste0(round(x * 100), " pts")) +
      labs(x = "Pressure points faced (log scale)",
           y = "Pressure-point drop vs a typical player",
           colour = NULL) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "top")

    ggiraph::girafe(
      ggobj = plot,
      width_svg = 10, height_svg = 6,
      options = list(
        ggiraph::opts_tooltip(css = tooltip_css,
                              delay_mouseover = 0, delay_mouseout = 100),
        ggiraph::opts_hover(css = "stroke:black; stroke-width:1.5px;"),
        # Click one dot to choose that player; click it again to unselect
        ggiraph::opts_selection(type = "single",
                                css = "stroke:black; stroke-width:3px;"),
        hidden_toolbar
      )
    )
  })

 
  # main chart. Keep the current player if they're still shown; otherwise
  # switch to the player with the most pressure points.
  observeEvent(selected_players(), {
    shown   <- selected_players()$player
    current <- input$player
    updateSelectizeInput(session, "player",
                         choices  = sort(shown),
                         selected = if (current %in% shown) current else shown[1])
  })

  # Clicking a dot on the main chart picks that player in the dropdown
  observeEvent(input$funnel_selected, {
    updateSelectizeInput(session, "player", selected = input$funnel_selected)
  })

  # Picking a player in the dropdown highlights their dot on the main chart
  observeEvent(input$player, {
    session$sendCustomMessage(type = "funnel_set", message = input$player)
  })

  # One player's pressure performance, year by year
  player_trend <- reactive({
    req(input$player)

    trend <- serve_pressure |>
      filter(player == input$player,
             surface %in% input$surface,
             year >= input$years[1],
             year <= input$years[2]) |>
      clutchserve::pressure_gap(pressure = input$pressure,
                                min_pressure = 0,
                                by_year = TRUE) |>
      filter(pressure_pts > 0)

    validate(need(
      nrow(trend) >= 2,
      paste0(input$player, " has fewer than two years of matches recorded with ",
             "these settings. Widen the years or surfaces, or pick another player.")
    ))

    trend
  }, label = "player_trend")

  output$trend <- ggiraph::renderGirafe({
    trend <- player_trend() |>
      mutate(
        tooltip_pressure = paste0("<b>", year, "</b><br>Won ",
                                  scales::percent(pressure_pct, accuracy = 0.1),
                                  " of ", pressure_pts, " pressure points"),
        tooltip_other    = paste0("<b>", year, "</b><br>Won ",
                                  scales::percent(other_pct, accuracy = 0.1),
                                  " of ", other_pts, " other service points")
      )

    plot <- ggplot(trend, aes(x = year)) +
      geom_line(aes(y = other_pct, colour = "Other service points"), linewidth = 1) +
      geom_line(aes(y = pressure_pct, colour = "Pressure points"), linewidth = 1) +
      ggiraph::geom_point_interactive(
        aes(y = other_pct, colour = "Other service points",
            tooltip = tooltip_other, data_id = paste0("other", year)),
        size = 2.5
      ) +
      ggiraph::geom_point_interactive(
        aes(y = pressure_pct, colour = "Pressure points", size = pressure_pts,
            tooltip = tooltip_pressure, data_id = paste0("pressure", year)),
        alpha = 0.8
      ) +
      scale_colour_manual(values = c("Other service points" = "#A3B18A",
                                     "Pressure points" = "#344E41")) +
      
      scale_size_area(max_size = 7, name = "Pressure points that year") +
      scale_x_continuous(breaks = scales::breaks_pretty()) +
      scale_y_continuous(labels = scales::percent) +
      labs(title = trend$player[1], x = NULL,
           y = "Share of points won", colour = NULL) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none")

    ggiraph::girafe(
      ggobj = plot,
      width_svg = 10, height_svg = 4,
      options = list(
        ggiraph::opts_tooltip(css = tooltip_css,
                              delay_mouseover = 0, delay_mouseout = 100),
        ggiraph::opts_hover(css = "stroke:black; stroke-width:1.5px;"),
        ggiraph::opts_selection(type = "none"),
        hidden_toolbar
      )
    )
  })
}

shinyApp(ui, server)