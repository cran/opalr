% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opal.table.R
\name{opal.table_get}
\alias{opal.table_get}
\title{Get a Opal table as a tibble}
\usage{
opal.table_get(
  opal,
  project,
  table,
  id.name = "id",
  variables = NULL,
  missings = TRUE
)
}
\arguments{
\item{opal}{Opal connection object.}

\item{project}{Project name where the table is located.}

\item{table}{Table name from which the tibble should be extracted.}

\item{id.name}{The name of the column representing the entity identifiers. Default is 'id'. Requires Opal 4.0+.}

\item{variables}{(Deprecated) List of variable names or Javascript expression that selects the variables of a table (ignored if value does not refer to a table). See javascript documentation: http://wiki.obiba.org/display/OPALDOC/Variable+Methods}

\item{missings}{(Deprecated) Include the missing values (default is TRUE).}
}
\description{
Shortcut function to assign a Opal table to a tibble in the R server-side session
and then retrieve it into the R client-side session. Requires to have the permission to
see the individual values of the table and to perform R assignments.
}
\examples{
\dontrun{
o <- opal.login('administrator','password', url='https://opal-demo.obiba.org')
cqx <- opal.table_get(o, "CPTP", "Cag_coreqx")
opal.logout(o)
}
}
\seealso{
Other table functions: 
\code{\link{opal.perms}()},
\code{\link{opal.resource_view_create}()},
\code{\link{opal.resource_view_reconnect}()},
\code{\link{opal.table_create}()},
\code{\link{opal.table_delete}()},
\code{\link{opal.table_dictionary_get}()},
\code{\link{opal.table_dictionary_update}()},
\code{\link{opal.table_exists}()},
\code{\link{opal.table_export}()},
\code{\link{opal.table_import}()},
\code{\link{opal.table_perm}()},
\code{\link{opal.table_perm_add}()},
\code{\link{opal.table_perm_delete}()},
\code{\link{opal.table_save}()},
\code{\link{opal.table_truncate}()},
\code{\link{opal.table_view_create}()},
\code{\link{opal.table_view_update}()}
}
\concept{table functions}
