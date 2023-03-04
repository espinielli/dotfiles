# For when install_github fails
# from DeanAtali comment in https://stackoverflow.com/a/31294266/963575
.fixdevtools <- function() {
  httr::set_config(httr::config(ssl_verifypeer = 0L))
}

.First <- function() {
  options(
    repos = c(CRAN = "https://cran.rstudio.com/"),
    keep.source = TRUE,
    keep.source.pkgs = TRUE,
    browserNLdisabled = TRUE,
    deparse.max.lines = 2,
    devtools.install.args = "--no-multiarch",
    devtools.name = "Enrico",
    devtools.desc.name = "Enrico",
    devtools.desc.author = "'Enrico spinielli <enrico.spinielli@gmail.com> [aut,cre]'",
    devtools.desc.license = "MIT",
    papersize="a4",
    chmhelp=TRUE,
    tinytex.verbose = TRUE,
    # prompt
    prompt = "> ",
    # `continuee` prompt, a space is good for easy copy & paste
    continue = " ",
    # xaringan's Infinitr Moon Reader: daemonized mode so that it does not block your R session
    servr.daemon = TRUE
  )
}

# if (interactive()) {
#    paint::mask_print()
#    prettycode::prettycode()
#    prompt::set_prompt(prompt::new_prompt_powerline())
# }

if (interactive()) {
  # blogdown options
  options(
    blogdown.author = "Enrico Spinielli",
    blogdown.use.rmd = TRUE
  )

   options(styler.addins_style_transformer = "grkstyle::grk_style_transformer()")

  ##--------- shortcuts ------------
  # taken from https://github.com/jimhester/dotfiles/blob/master/R/Rprofile
  # Assign shortcuts to a hidden environment, so they don't show up in ls()
  # Idea from https://csgillespie.github.io/efficientR/set-up.html#creating-hidden-environments-with-.rprofile
  .env <- new.env()
  with(.env, {
    shortcut <- function(f) structure(f, class = "shortcut")
    print.shortcut <- function(f, ...) f(...)

    p <- shortcut(covr::package_coverage)

    rs <- shortcut(function(file = "script.R", echo = TRUE, ...) source(file, echo = echo, ...))

    li <- shortcut(library)
    l <- shortcut(devtools::load_all)

    i <- shortcut(devtools::install)
    gh <- shortcut(devtools::install_github)

    id <- shortcut(function(dependencies = TRUE, ...) {
      devtools::install_deps(dependencies = dependencies, ...)
    })

    ch <- shortcut(function(document = FALSE, ...) {
      devtools::check(document = document, ...)
    })
    d <- shortcut(devtools::document)

    # gaborcsardi/tracer
    #tb <- shortcut(tracer::tb)

    t <- shortcut(
      test <- function(filter = NULL, length = 5, pkg = ".", ..., reporter = "progress") {
        if (is.null(reporter)) {
          #reporter <- testthat::SummaryReporter$new()
          #reporter$max_reports = length
          #reporter <- testthat:::ProgressReporter$new()
        }
        devtools::test(pkg, filter, reporter = reporter, ...)
      })

    # jennybc/reprex
    re <- shortcut(reprex::reprex)

    qt <- shortcut(function() {
      savehistory()
      base::q(save="no")
    })

    echo <- function(x) {
      cat(readLines(x), sep = "\n")
    }

    ## ht==headtail, i.e., show the first and last 10 items of an object
    ht <- function(d) rbind(head(d,10),tail(d,10))

    ## List objects and classes (from @_inundata, mod by ateucher)
    lsa <- shortcut(function() {
      obj_type <- function(x) class(get(x, envir = .GlobalEnv)) # define environment
      foo = data.frame(sapply(ls(envir = .GlobalEnv), obj_type))
      foo$object_name = rownames(foo)
      names(foo)[1] = "class"
      names(foo)[2] = "object"
      return(unrowname(foo))
    })

    ## List all functions in a package (also from @_inundata)
    lsp <-shortcut(function(package, all.names = FALSE, pattern) {
      package <- deparse(substitute(package))
      ls(
        pos = paste("package", package, sep = ":"),
        all.names = all.names,
        pattern = pattern
      )
    })

    sv <- shortcut(function(vignette, package) {
      v <- vignette(vignette, package = package)
      source(file.path(v["Dir"], "doc", v["R"]))
    })

    sshhh <- function(a.package){
      suppressWarnings(suppressPackageStartupMessages(
        library(a.package, character.only=TRUE)))
    }

    # # from https://jozefhajnala.gitlab.io/r/r903-tricks-bracketless/
    # gg <- structure(FALSE, class = "debuggerclass")
    # print.debuggerclass <-  function(debugger) {
    #   if (!identical(getOption("error"), as.call(list(utils::recover)))) {
    #     options(error = recover)
    #     message(" * debugging is now ON - option error set to recover")
    #   } else {
    #     options(error = NULL)
    #     message(" * debugging is now OFF - option error set to NULL")
    #   }
    # }
  })
  # We need to attach stats before .env to shadow qt
  library(stats)
  suppressMessages(attach(.env))
  ##------------------

  # Automatically (and silentrly) load packages in interactive sessions
  # auto.loads <-c("devtools", "tidyverse")
  auto.loads <-c()
  invisible(sapply(auto.loads, sshhh))
  rm(auto.loads)
}
