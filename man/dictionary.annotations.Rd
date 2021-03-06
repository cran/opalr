% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dictionary.annotations.R
\name{dictionary.annotations}
\alias{dictionary.annotations}
\title{List the annotations}
\usage{
dictionary.annotations(
  tibble,
  variables = NULL,
  taxonomy = NULL,
  vocabulary = NULL
)
}
\arguments{
\item{tibble}{Tibble to be annotated}

\item{variables}{A character vector of variable names to be inspected. If NULL or empty, all
the columns of the tibble will be inspected.}

\item{taxonomy}{Filter by taxonomy name(s) (if provided).}

\item{vocabulary}{Filter by vocabulary name(s) (if provided).}
}
\value{
A data frame in long format (one row per annotation).
}
\description{
List the annotations of each of the variables.
}
\examples{
\dontrun{
o <- opal.login('administrator','password', url='https://opal-demo.obiba.org')
cqx <- opal.table_get(o, "CPTP", "Cag_coreqx")
annot <- dictionary.annotations(cqx, taxonomy = "Mlstr_harmo", vocabulary = "status")
opal.logout(o)
}
}
