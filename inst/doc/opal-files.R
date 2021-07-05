## ----eval=FALSE---------------------------------------------------------------
#  library(opalr)
#  o <- opal.login("administrator", "password", "https://opal-demo.obiba.org")

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_download(o, "/home/administrator/CNSIM.zip")

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_download(o, "/home/administrator/CNSIM.zip", "CNSIM-encrypted.zip", key="ABCDEFGHIJKL")

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_upload(o, "CNSIM.zip", "/projects/CNSIM")

## ----eval=FALSE---------------------------------------------------------------
#  fooDir <- paste0("/projects/CNSIM/foo-", sample(10000:99999, 1))
#  opal.file_mkdir(o, fooDir)
#  opal.file_ls(o, "/projects/CNSIM")

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_mv(o, "/projects/CNSIM/CNSIM.zip", fooDir)
#  opal.file_ls(o, fooDir)

## ----eval=FALSE---------------------------------------------------------------
#  barDir <- paste0("/projects/CNSIM/bar-", sample(10000:99999, 1))
#  opal.file_mv(o, fooDir, barDir)
#  opal.file_ls(o, "/projects/CNSIM")

## ----eval=FALSE---------------------------------------------------------------
#  out <- opal.file_unzip(o, paste0(barDir, "/CNSIM.zip"), barDir)
#  opal.file_ls(o, out)

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_write(o, paste0(barDir, "/CNSIM.zip"))
#  opal.execute(o, "list.files()")

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_read(o, "CNSIM.zip", paste0(barDir, "/ds.zip"))
#  opal.file_ls(o, barDir)

## ----eval=FALSE---------------------------------------------------------------
#  opal.file_rm(o, barDir)
#  opal.file_ls(o, "/projects/CNSIM")

## ----eval=FALSE---------------------------------------------------------------
#  # clean server side
#  opal.logout(o)
#  # clean client side
#  unlink("CNSIM-encrypted.zip")
#  unlink("CNSIM.zip")

