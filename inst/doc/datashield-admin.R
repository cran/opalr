## ----eval=FALSE---------------------------------------------------------------
# library(opalr)
# o <- opal.login("administrator", "password", "https://opal-demo.obiba.org")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.package_descriptions(o, profile = "default")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.install_package(o, pkg = "dsBase", profile = "default")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.install_github_package(o, pkg = "dsSurvival", username = "neelsoumya", ref = "v1.0.0", profile = "default")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.install_local_package(o, devtools::build(), profile = "default")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.remove_package(o, pkg = "dsSurvival", profile = "default")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.profiles(o)

## ----eval=FALSE---------------------------------------------------------------
# # ensure the profile does not exist
# if (dsadmin.profile_exists(o, "demo"))
#   dsadmin.profile_delete(o, "demo")
# # create a profile, disabled
# dsadmin.profile_create(o, "demo", cluster = "default")
# # make only dsBase and resourcer packages visible
# dsadmin.profile_init(o, "demo", packages = c("dsBase", "resourcer"))
# # ready to be used
# dsadmin.profile_enable(o, "demo")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.profile_perm_add(o, "demo", subject = "testers", type = "group")
# # verify permissions
# dsadmin.profile_perm(o, "demo")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.get_methods(o, type = "aggregate", profile = "demo")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.set_method(o, "hello", func = function(x) { paste0("Hello ", x, "!") }, type = "aggregate", profile = "demo")
# # verfiy custom method
# dsadmin.get_method(o, "hello", type = "aggregate", profile = "demo")

## ----eval=FALSE---------------------------------------------------------------
# library(DSOpal)
# builder <- DSI::newDSLoginBuilder()
# builder$append(server = "study1",  url = "https://opal-demo.obiba.org",
#                user = "administrator", password = "password",
#                profile = "demo")
# logindata <- builder$build()
# conns <- DSI::datashield.login(logins = logindata)
# # call the hello() function on the R server
# datashield.aggregate(conns, expr = quote(hello('friends')))
# datashield.logout(conns)

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.set_option(o, "datashield.privacyLevel", "10", profile = "demo")
# # verify options
# dsadmin.get_options(o, profile = "demo")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.profile_rparser(o, "demo", rParser = "v1")

## ----eval=FALSE---------------------------------------------------------------
# if (oadmin.user_exists(o, "userx"))
#   oadmin.user_delete(o, "userx")
# # generated password
# password <- oadmin.user_add(o, "userx", groups = c("demo", "datashield"))
# # verify user
# subset(oadmin.users(o), name == "userx")

## ----eval=FALSE---------------------------------------------------------------
# lapply(opal.tables(o, "CNSIM")$name, function(table) {
#   opal.table_perm_add(o, "CNSIM", table, subject = "demo", type = "group", permission = "view")
# })
# # verify table permissions
# opal.table_perm(o, "CNSIM", "CNSIM1")

## ----eval=FALSE---------------------------------------------------------------
# opal.resources_perm_add(o, "RSRC", subject = "demo", type = "group", permission = "view")
# # verify permissions
# opal.resources_perm(o, "RSRC")

## ----eval=FALSE---------------------------------------------------------------
# dsadmin.perm_add(o, subject = "datashield", type = "group", permission = "use")
# # verify permissions
# dsadmin.perm(o)

## ----eval=FALSE---------------------------------------------------------------
# opal.logout(o)

