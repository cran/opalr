% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opal.resource.R
\name{opal.resources}
\alias{opal.resources}
\title{Get the resource references of a project}
\usage{
opal.resources(opal, project, df = TRUE)
}
\arguments{
\item{opal}{Opal object.}

\item{project}{Name of the project.}

\item{df}{Return a data.frame (default is TRUE)}
}
\description{
Get the resource references of a project
}
\examples{
\dontrun{
o <- opal.login('administrator','password', url='https://opal-demo.obiba.org')
opal.resources(o, 'RSRC')
opal.logout(o)
}
}
\seealso{
Other resource functions: 
\code{\link{opal.resource}()},
\code{\link{opal.resource_create}()},
\code{\link{opal.resource_delete}()},
\code{\link{opal.resource_exists}()},
\code{\link{opal.resource_extension_create}()},
\code{\link{opal.resource_get}()},
\code{\link{opal.resource_perm}()},
\code{\link{opal.resource_perm_add}()},
\code{\link{opal.resource_perm_delete}()},
\code{\link{opal.resources_perm}()},
\code{\link{opal.resources_perm_add}()},
\code{\link{opal.resources_perm_delete}()}
}
\concept{resource functions}
