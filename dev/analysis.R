devtools::install_deps()
devtools::load_all()

me <- get_athlete("harry", "fisher", "Cardiff")

me |>
    dplyr::filter(event == "parkrun") |>
    View()


# Get some HM guys from Aber club

fn <- c(
    "Gethin",
    "Mark",
    "Aled",
    "Ian",
    "Paul",
    "Richard"
)

sn <- c(
    "Holland",
    "Whitehead",
    "Hughes",
    "Evans",
    "Williams",
    "Anthony"
)

club <- "Aberystwyth"

# Make into list

dat <- data.frame(
    fn = fn,
    sn = sn,
    club = club
) |>
    purrr::transpose()

# Loop over list
res <- purrr::map_dfr(dat, \(athlete) {
    tmp <- get_athlete(athlete[["fn"]], athlete[["sn"]], athlete[["club"]])

    tmp |>
        tibble::as_tibble() |>
        dplyr::mutate(
            fn = athlete[["fn"]],
            sn = athlete[["sn"]],
            club = athlete[["club"]]
        )
}, .progress = TRUE)


# Average parkrun perf
res |>
    dplyr::select(-dplyr::starts_with("x")) |>
    dplyr::filter(event == "parkrun") |>
    mutate(
        date = as.Date(date, format = "%d %b %y"),
        perf = hms::parse_hms(paste("00:", perf))
    ) |>
    dplyr::summarise(
        mean = lubridate::seconds_to_period(mean(perf)),
        .by = c(fn)
    ) |>
    gt::gt()