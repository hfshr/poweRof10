library(ggplot2)
library(shiny)
library(bslib)
library(waiter)
library(future)
plan(multisession, workers = 4)
data(penguins, package = "palmerpenguins")

# data <- readRDS(system.file("data.rds", package = "poweRof10"))
# data <- data |>
#     dplyr::select(-dplyr::starts_with("x"))

data <- readRDS(system.file("data.rds", package = "poweRof10"))


data <- dplyr::mutate(data, perf = as.character(perf))

ui <- page_sidebar(
    title = "Power of 10 dashboard",
    sidebar = sidebar(
        title = "Search controls",
        textInput("club", "Club"),
    ),
    card(
        card_header("Athletes"),
        reactable::reactableOutput("tab")
    )
)


server <- function(input, output) {
    output$tab <- reactable::renderReactable({
        reactable::reactable(
            data,
            filterable = TRUE,
            searchable = TRUE,
            minRows = 10,
            highlight = TRUE,
        )
    })
}

shinyApp(ui, server)