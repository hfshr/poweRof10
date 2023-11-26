run_app <- \(){
    appDir <- system.file("app", package = "poweRof10")
    if (appDir == "") {
        stop("Could not find example directory. Try re-installing `poweRof10`.", call. = FALSE)
    }

    shiny::runApp(appDir, display.mode = "normal")
}