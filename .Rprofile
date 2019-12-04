setHook("rstudio.sessionInit", function(newSession) {
  if (newSession)
    message("Welcome to RStudio ", rstudioapi::getVersion())
    setwd("~/binder")
    rstudioapi::executeCommand("goToWorkingDir")
}, action = "append")
