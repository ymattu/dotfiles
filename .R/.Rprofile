options(
  repos = c(CRAN = "https://cloud.r-project.org/"),
  menu.graphics = FALSE,

  warn = 1,
  warnPartialMatchArgs = FALSE,
  warnPartialMatchAttr = TRUE,
  warnPartialMatchDollar = TRUE,
  showWarnCalls = TRUE,
  showErrorCalls = TRUE,

  datatable.print.class = TRUE,
  datatable.print.colnames = "top",
  pillar.subtle = FALSE,
  pillar.neg = FALSE,
  readr.num_columns = 0L,

  devtools.name = "Yuya Matsumura",
  devtools.desc = list(
    License = "MIT + file LICENSE",
    `Authors@R` = "person('Yuya', 'Matsumura', email='mattu.yuya@gmail.com', role=c('aut', 'cre'))"
  )
)

.First = function() {
  stopifnot(dir.exists(Sys.getenv("R_LIBS_USER")))
  if (interactive()) {
    cran = c("tidyverse", "githubinstall", "devtools", "formatR")
    options(defaultPackages = c(getOption("defaultPackages"), cran))
    if (!(.Platform$GUI %in% c("AQUA", "Rgui")) && Sys.getenv("INSIDE_EMACS") == "") {
      utils::loadhistory(file = Sys.getenv("R_HISTFILE"))
    }
    print(utils::sessionInfo(), locale = FALSE)
    cat("Loading:", cran, "\n")

    setHook(packageEvent("grDevices", "onLoad"), function(...) {
      grDevices::quartz.options(width = 6.5, height = 6.5)
    })
    setHook(packageEvent("tibble", "attach"), function(...) {
      try({
        registerS3method("print", "tbl_df", data.table:::print.data.table)
        registerS3method("print", "tbl", data.table:::print.data.table)
      })
    })
  }
}

.Last = function() {
  try({
    if (interactive()) {
      if (!(.Platform$GUI %in% c("AQUA", "Rgui")) && Sys.getenv("INSIDE_EMACS") == "") {
        utils::savehistory(file = Sys.getenv("R_HISTFILE"))
      }
      print(ls(envir = .GlobalEnv, all.names = TRUE))
      print(utils::sessionInfo(), locale = FALSE)
    }
  })
}
