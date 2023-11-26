#' Find athletes in a club
#'
#' `get_club_athletes` returns all athletes in a specified club.
#'
#' @param club string. Club to search
#'
#' @examples
#' \dontrun{
#' get_club_athletes(club = "Cardiff")
#' }
#'
#' @export
get_club_athletes <- \(club) {
    url <- "https://www.thepowerof10.info/athletes/athleteslookup.aspx"

    session <- session(
        url,
        user_agent("https://github.com/hfshr")
    )

    x <- session %>%
        read_html() %>%
        html_element("form") %>%
        html_form()

    x[["fields"]][["ctl00$cphBody$txtClub"]][["value"]] <- club

    submit <- suppressMessages(session_submit(session, form = x))

    result <- content(submit$response) |>
        html_element("#cphBody_pnlResults") |>
        html_table() |>
        row_2_names(1) |>
        dplyr::filter(First != "For road runners please also check our sister site runbritain rankings.")

    result
}