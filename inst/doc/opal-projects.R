## ----eval=FALSE---------------------------------------------------------------
#  library(opalr)
#  o <- opal.login("administrator", "password", url = "https://opal-demo.obiba.org")

## ----eval=FALSE---------------------------------------------------------------
#  opal.projects(o)

## ----eval=FALSE---------------------------------------------------------------
#  if (opal.project_exists(o, "dummy"))
#    opal.project_delete(o, "dummy")
#  opal.project_create(o, "dummy", database = TRUE)
#  opal.project(o, "dummy")

## ----eval=FALSE---------------------------------------------------------------
#  opal.project_backup(o, 'CNSIM', '/home/administrator/backup/CNSIM')
#  opal.file_download(o, '/home/administrator/backup/CNSIM', '/tmp/CNSIM.zip', key = "12345abcdef")

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_upload(o, '/tmp/CNSIM.zip', '/home/administrator')
#  opal.project_restore(o, 'dummy', '/home/administrator/CNSIM.zip', key = "12345abcdef")
#  # verify tables
#  opal.tables(o, "CNSIM")

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
#  opal.assign(o, "D", "CNSIM.CNSIM123")
#  opal.execute(o, "summary(D)")

## ----eval=FALSE---------------------------------------------------------------
#  opal.valueset(o, "CNSIM", "CNSIM123", identifier = "1454")

## ----eval=FALSE---------------------------------------------------------------
#  cnsim1 <- opal.table_get(o, "CNSIM", "CNSIM1")
#  cnsim2 <- opal.table_get(o, "CNSIM", "CNSIM2")
#  cnsim3 <- opal.table_get(o, "CNSIM", "CNSIM3")

## ----eval=FALSE---------------------------------------------------------------
#  # make sure IDs are unique
#  cnsim1$id <- paste0(cnsim1$id, "-1")
#  cnsim2$id <- paste0(cnsim2$id, "-2")
#  cnsim3$id <- paste0(cnsim3$id, "-3")
#  # bind tables
#  cnsim123 <- rbind(cnsim1, cnsim2, cnsim3)
#  # remove some columns
#  cnsim123$DIS_AMI <- NULL
#  cnsim123$DIS_CVA <- NULL
#  cnsim123$DIS_DIAB <- NULL
#  # save as a raw table
#  opal.table_save(o, cnsim123, "CNSIM", "CNSIM", overwrite = TRUE, force = TRUE)
#  opal.table(o, "CNSIM", "CNSIM", counts = TRUE)

## ----eval=FALSE---------------------------------------------------------------
#  opal.valueset(o, "CNSIM", "CNSIM", identifier = "1454-1")

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
#  annotations <- tibble::tribble(
#    ~variable, ~taxonomy, ~vocabulary, ~term,
#    "LAB_TSC", "Mlstr_area", "Physical_measures", "Physical_characteristics",
#    "LAB_TRIG", "Mlstr_area", "Physical_measures", "Physical_characteristics",
#    "LAB_HDL", "Mlstr_area", "Physical_measures", "Physical_characteristics",
#    "LAB_GLUC_ADJUSTED", "Mlstr_area", "Physical_measures", "Physical_characteristics"
#  )
#  opal.annotate(o, "CNSIM", "CNSIM123", annotations = annotations)

## ----eval=FALSE---------------------------------------------------------------
#  opal.annotations(o, "CNSIM", "CNSIM123")

## ----eval=FALSE---------------------------------------------------------------
#  opal.resources(o, "RSRC")

## ----eval=FALSE---------------------------------------------------------------
#  if (opal.resource_exists(o, "RSRC", "CNSIM4"))
#    opal.resource_delete(o, "RSRC", "CNSIM4")
#  opal.resource_create(o, "RSRC", "CNSIM4",
#     url = "opal+https://opal-demo.obiba.org/ws/files/projects/RSRC/CNSIM3.zip",
#     format = "csv", secret = "EeTtQGIob6haio5bx6FUfVvIGkeZJfGq")
#  # verify the resource reference object
#  opal.resource(o, "RSRC", "CNSIM4")

## ----eval=FALSE---------------------------------------------------------------
#  opal.resource_get(o, "RSRC", "CNSIM4")

## ----eval=FALSE---------------------------------------------------------------
#  library(resourcer)
#  as.data.frame(opal.resource_get(o, "RSRC", "CNSIM4"))

## ----eval=FALSE---------------------------------------------------------------
#  # assign the resource object
#  opal.assign.resource(o, "rsrc", "RSRC.CNSIM4")
#  # coerce it to a data.frame
#  opal.assign.script(o, "D", quote(as.data.frame(rsrc)))
#  # get some summary statistics
#  opal.execute(o, "summary(as.factor(D$GENDER))")

## ----eval=FALSE---------------------------------------------------------------
#  opal.logout(o)

