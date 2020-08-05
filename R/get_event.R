#' Get performances for a given year/event/gender
#'
#' @param event character string. The event you want to return.
#' @param agegroup character string. Specify age group e.g., "U20", defaults to "ALL".
#' @param year character. The year to return in YYYY format, e.g., "2020".
#' @param gender character. Either "M" for males or "F" for females.
#' @param top_n integer. Return top n rows.
#'
#' @examples
#' \dontrun{
#'
#' get_event(event = "100", agegroup = "ALL", gender = "M", year = "2016", top_n = 10)
#'
#' }
#'
#' @export
get_event <- function(event, agegroup = "ALL", gender = "M", year = "2020", top_n = NULL){

  valid_events <- c("60", "100", "200", "400", "800", "1500", "3000", "5000", "10000",
                    "3000SC", "10K", "HM", "Mar", "60H", "110H", "400H", "HJ", "PV",
                    "LJ", "TJ", "SP7.26K", "DT2K", "HT7.26K", "JT800", "HepI", "Dec",
                    "20KW", "50KW", "4x100", "4x400")

  valid_ages <- c("ALL", "U20", "U17", "U15", "DIS")

  attempt::stop_if_not(event %in% valid_events,
                       msg = paste0("Event must be one of ", paste0(valid_events, collapse = ", "))
  )

  attempt::stop_if_not(agegroup %in% valid_ages,
                       msg = paste0("Age must be one of ", paste0(valid_ages, collapse = ", "))
  )

  attempt::stop_if_not(gender %in% c("M", "F"),
                       msg = paste0("Gender must be either 'M' or 'F'")
  )

  base_url <- "https://www.thepowerof10.info/rankings/rankinglist.aspx?"

  args <- list(event = event,
               agegroup = agegroup,
               sex = gender,
               year = year)


  url <- modify_url(base_url, query = compact(args))


  session <- bow(
    url = url,  # base URL
    user_agent = "https://github.com/hfshr",  # identify ourselves
    force = TRUE
  )

  res <- scrape(session) %>%
    html_nodes("#cphBody_lblCachedRankingList") %>%
    html_node("table") %>%
    html_table() %>%
    .[[1]] %>%
    `colnames<-`(c("rank", "perf", "wind_indoors",
                   "wind_speed", "pb", "pb_in_year",
                   "name", "age_group", "year_",
                   "coach", "club", "venue", "date", "blank")) %>%
    select(-.data$blank) %>%
    filter(!str_detect(.data$perf, "[:alpha:]")) %>%
    mutate(year = as.character(year),
           event = as.character(event),
           gender = gender)

  if (!is.null(top_n)) {
    res %>%
      head(top_n)

  } else {
    return(res)
  }
}
