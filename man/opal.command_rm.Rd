% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opal.command.R
\name{opal.command_rm}
\alias{opal.command_rm}
\title{Remove an asynchronous command}
\usage{
opal.command_rm(opal, id)
}
\arguments{
\item{opal}{Opal object.}

\item{id}{R command ID.}
}
\description{
Remove an asynchronous R commands in the remote R session.
}
\examples{
\dontrun{
o <- opal.login('administrator','password', url='https://opal-demo.obiba.org')
opal.command_rm(o, '1234')
opal.logout(o)
}
}
\seealso{
Other command functions: 
\code{\link{opal.command}()},
\code{\link{opal.command_result}()},
\code{\link{opal.commands}()},
\code{\link{opal.commands_rm}()}
}
\concept{command functions}
