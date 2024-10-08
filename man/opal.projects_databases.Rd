% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opal.project.R
\name{opal.projects_databases}
\alias{opal.projects_databases}
\title{Get projects databases}
\usage{
opal.projects_databases(opal)
}
\arguments{
\item{opal}{Opal object.}
}
\value{
A character vector of databases names.
}
\description{
When creating a project for storing data, it is required to name the database to be associated.
}
\examples{
\dontrun{
o <- opal.login('administrator','password', url='https://opal-demo.obiba.org')
opal.projects_databases(o)
opal.logout(o)
}
}
\seealso{
Other project functions: 
\code{\link{opal.project}()},
\code{\link{opal.project_create}()},
\code{\link{opal.project_delete}()},
\code{\link{opal.project_exists}()},
\code{\link{opal.projects}()}
}
\concept{project functions}
