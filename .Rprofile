setHook("rstudio.sessionInit", function(newSession) {
  if (newSession)
    message("Welcome to RStudio ", rstudioapi::getVersion())
    setwd("~/for-scripters/R")
    rstudioapi::executeCommand("goToWorkingDir")
}, action = "append")
