% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opal.admin.R
\name{oadmin.activity}
\alias{oadmin.activity}
\title{Get R activity}
\usage{
oadmin.activity(
  opal,
  user = NULL,
  profile = NULL,
  from = NULL,
  to = NULL,
  df = TRUE
)
}
\arguments{
\item{opal}{Opal connection object.}

\item{user}{Optional user name.}

\item{profile}{Optional profile name.}

\item{from}{Optional start date.}

\item{to}{Optional end date.}

\item{df}{Return a data.frame (default is TRUE)}
}
\description{
Get the recorded R session metrics.
}
\examples{
\dontrun{
o <- opal.login('administrator','password', url='https://opal-demo.obiba.org')
# all sessions metrics
oadmin.activity(o)
# user and profile specific session metrics
oadmin.activity(o, user = 'dsuser', profile = 'default')
# user sessions in a time range
oadmin.activity(o, user = "dsuser", from = "2022-07-01", to = "2023-01-01")
opal.logout(o)
}
}
