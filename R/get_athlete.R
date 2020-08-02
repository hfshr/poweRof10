#' Get data for a specific athlete
#'
#' `get_athlete` returns a dataframe with a specified athletes performances. May return more than one athlete
#' if a club is not specified and there are multiple athletes with the same name.
#'
#' @param fn character. Athletes forename.
#' @param sn character. Athletes surname.
#' @param club character. The registered club for the athlete
#'
#'


#' @export
get_athlete <- function(fn, sn, club = NULL){

  url <- "https://www.thepowerof10.info/athletes/athleteslookup.aspx"

  session <- html_session(url,
                          user_agent("https://github.com/hfshr"))

  x <- session %>%
    read_html() %>%
    html_node("form") %>%
    html_form()

  x[["fields"]][["ctl00$cphBody$txtSurname"]][["value"]] <- sn
  x[["fields"]][["ctl00$cphBody$txtFirstName"]][["value"]] <- fn
  x[["fields"]][["ctl00$cphBody$txtClub"]][["value"]] <- club

  submit <- suppressMessages(submit_form(session, form = x))

  res_string <- content(submit$response) %>%
    xml_child(2) %>%
    xml_child(1) %>%
    xml_attr(attr = "action")

  if (res_string == "./athleteslookup.aspx"){

    link <- submit %>%
      html_nodes("#cphBody_dgAthletes") %>%
      html_table() %>%
      .[[1]] %>%
      row_to_names(1) %>%
      select(-c(Profile, runbritain)) %>%
      bind_cols(., submit %>%
                  html_nodes("#cphBody_dgAthletes") %>%
                  html_nodes("a") %>%
                  html_attr("href") %>%
                  enframe(value = "link") %>%
                  filter(!str_detect(link, "runbritain")) %>%
                  select(-name)) %>%
      mutate(link = paste0("https://www.thepowerof10.info/athletes/", link))


    all_links <- link %>%
      pull(link)

    if (length(all_links) > 1) {
      message(paste0("More than one athlete with the name ", fn, " ", sn, ".\nConsider specifying club"))

      res <- map_dfr(all_links, ind_athletes, .id = "id")

      return(res)
    } else {

      res <- ind_athletes(all_links)

      return(res)

    }


  } else {

    res <- res_string %>%
      str_remove(., ".") %>%
      paste0("https://www.thepowerof10.info/athletes", .) %>%
      ind_athletes()

    return(res)

  }

}

#' Get and clean athlete data
ind_athletes <- function(link){
  temp <- link %>%
    read_html() %>%
    html_node("#cphBody_pnlPerformances") %>%
    xml_child(., 4) %>%
    html_table() %>%
    row_2_names(2) %>%
    clean_names() %>%
    filter(!str_detect(perf, "[:alpha:]")) %>%
    remove_empty("cols")
}


#' Borrowed from janitor package
row_2_names <- function (dat, row_number, remove_row = TRUE, remove_rows_above = TRUE){

  if (length(row_number) != 1 | !is.numeric(row_number)) {
    stop("row_number must be a numeric of length 1")
  }
  new_names <- as.character(unlist(dat[row_number, ], use.names = FALSE))
  colnames(dat) <- new_names
  rows_to_remove <- c(if (remove_row) {
    row_number
  } else {
    c()
  }, if (remove_rows_above) {
    seq_len(row_number - 1)
  } else {
    c()
  })
  if (length(rows_to_remove)) {
    dat[-(rows_to_remove), , drop = FALSE]
  }
  else {
    dat
  }
}

