## ----eval=FALSE---------------------------------------------------------------
# library(opalr)
# o <- opal.login("administrator", "password", "https://opal-demo.obiba.org", profile = "default")

## ----eval=FALSE---------------------------------------------------------------
# opal.assign.table(o, symbol = "df", value = "CNSIM.CNSIM1")

## ----eval=FALSE---------------------------------------------------------------
# opal.assign.table.tibble(o, symbol = "tbl", value = "CNSIM.CNSIM1")

## ----eval=FALSE---------------------------------------------------------------
# opal.assign.resource(o, symbol = "rsrc", value = "RSRC.CNSIM3")

## ----eval=FALSE---------------------------------------------------------------
# opal.assign.script(o, symbol = "hello", value = quote(function(x) { paste0("Hello ", x, "!") }))

## ----eval=FALSE---------------------------------------------------------------
# opal.symbols(o)

## ----eval=FALSE---------------------------------------------------------------
# # column names
# opal.execute(o, script = "names(tbl)")
# # get variable description from column attributes
# opal.execute(o, script = "attributes(tbl$GENDER)")
# # coerce resource to a data.frame and plot histogram of one column
# plot(opal.execute(o, script = "hist(as.data.frame(rsrc)$LAB_HDL)"))
# # execute the custom function
# opal.execute(o, script = "hello('friends')")

## ----eval=FALSE---------------------------------------------------------------
# GENDER <- opal.execute(o, script = "tbl$GENDER")

## ----eval=FALSE---------------------------------------------------------------
# opal.execute.source(o, path = "/path/to/some_code.R")

## ----eval=FALSE---------------------------------------------------------------
# opal.file_write(o, source = "/projects/CNSIM/CNSIM3.zip", "test.zip")

## ----eval=FALSE---------------------------------------------------------------
# opal.file_read(o, source = "test.zip", destination = "/tmp")

## ----eval=FALSE---------------------------------------------------------------
# opal.workspace_save(o, save="demo")
# opal.workspaces(o)

## ----eval=FALSE---------------------------------------------------------------
# opal.logout(o)

