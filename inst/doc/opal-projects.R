## ----eval=FALSE---------------------------------------------------------------
#  library(opalr)
#  o <- opal.login("administrator", "password", url = "https://opal-demo.obiba.org")

## ----eval=FALSE---------------------------------------------------------------
#  opal.projects(o)

## ----eval=FALSE---------------------------------------------------------------
#  opal.datasources(o)

## ----eval=FALSE---------------------------------------------------------------
#  opal.tables(o, "CNSIM", counts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  opal.table(o, "CNSIM", "CNSIM1", counts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  opal.table_exists(o, "CNSIM", "CNSIM1")

## ----eval=FALSE---------------------------------------------------------------
#  opal.table_exists(o, "CNSIM", "CNSIM1", view = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  # drop table if it exists
#  opal.table_delete(o, "CNSIM", "CNSIM123")
#  # then create a view, no variables
#  opal.table_create(o, "CNSIM", "CNSIM123", tables = c("CNSIM.CNSIM1", "CNSIM.CNSIM2", "CNSIM.CNSIM3"))
#  opal.table(o, "CNSIM", "CNSIM123", counts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  opal.variables(o, "CNSIM", "CNSIM1")

## ----eval=FALSE---------------------------------------------------------------
#  dico <- opal.table_dictionary_get(o, "CNSIM", "CNSIM1")
#  dico$variables
#  dico$categories

## ----eval=FALSE---------------------------------------------------------------
#  dico$variables$script <- paste0("$('", dico$variables$name, "')")
#  dico$variables

## ----eval=FALSE---------------------------------------------------------------
#  opal.table_dictionary_update(o, "CNSIM", "CNSIM123", variables = dico$variables, categories = dico$categories)
#  opal.table(o, "CNSIM", "CNSIM123", counts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  opal.valueset(o, "CNSIM", "CNSIM123", identifier = "1454")

## ----eval=FALSE---------------------------------------------------------------
#  cnsim1 <- opal.table_get(o, "CNSIM", "CNSIM1")
#  cnsim2 <- opal.table_get(o, "CNSIM", "CNSIM2")
#  cnsim3 <- opal.table_get(o, "CNSIM", "CNSIM3")

## ----eval=FALSE---------------------------------------------------------------
#  cnsim123 <- rbind(cnsim1, cnsim2, cnsim3)
#  cnsim123$DIS_AMI <- NULL
#  cnsim123$DIS_CVA <- NULL
#  cnsim123$DIS_DIAB <- NULL
#  cnsim123
#  opal.table_save(o, cnsim123, "CNSIM", "CNSIM", overwrite = TRUE, force = TRUE)
#  opal.table(o, "CNSIM", "CNSIM", counts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  opal.valueset(o, "CNSIM", "CNSIM", identifier = "1454")

## ----eval=FALSE---------------------------------------------------------------
#  opal.table_truncate(o, "CNSIM", "CNSIM")
#  opal.table(o, "CNSIM", "CNSIM", counts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  opal.taxonomies(o)

## ----eval=FALSE---------------------------------------------------------------
#  opal.vocabularies(o, taxonomy = "Mlstr_area")

## ----eval=FALSE---------------------------------------------------------------
#  opal.terms(o, taxonomy = "Mlstr_area", vocabulary = "Lifestyle_behaviours")

## ----eval=FALSE---------------------------------------------------------------
#  opal.logout(o)

