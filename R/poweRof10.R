#' poweRof10
#'
#' Tools to scrape athletics ranking data
#'
#' @importFrom httr modify_url user_agent content
#' @importFrom rvest session html_elements html_element html_table html_form session_submit html_attr
#' @importFrom xml2 read_html xml_child xml_attr
#' @importFrom dplyr filter select bind_cols mutate pull
#' @importFrom stringr str_detect str_remove
#' @importFrom purrr map_dfr compact
#' @importFrom magrittr "%>%"
#' @importFrom janitor clean_names row_to_names remove_empty
#' @importFrom attempt stop_if_not stop_if
#' @importFrom polite bow scrape
#' @importFrom tibble enframe
#' @importFrom utils head
#' @importFrom rlang .data
#'
#' @docType package
#' @name poweRof10
#' @md
NULL