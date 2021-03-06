% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/opal.sql.R
\name{opal.sql}
\alias{opal.sql}
\title{Execute a SQL query on tables}
\usage{
opal.sql(opal, query, project = NULL, id.name = "_id")
}
\arguments{
\item{opal}{Opal connection object.}

\item{query}{The SQL query statement.}

\item{project}{Project name where the table(s) are located. If not provided, the SQL query must refer to the 
full table name(s) (use backquotes to escape, see examples).}

\item{id.name}{The name of the column representing the entity identifiers. Default is '_id'.}
}
\value{
The lists of columns and rows, as a data.frame.
}
\description{
The SQL query can apply to raw tables and/or views and require the permission to 
view the values of these tables. When all tables belong to a project, it is possible to simplify 
the SQL query by providing the project name parameter. Otherwise the fully qualified table names 
(`<project>.<table>`) must be specified in the FROM statements.
}
\examples{
\dontrun{
o <- opal.login('administrator','password', url='https://opal-demo.obiba.org')
# with project context
opal.sql(o,  
  'select avg(LAB_HDL) as HDL_AVG, GENDER 
     from CNSIM1 
     where LAB_HDL is not null 
     group by GENDER',
  'CNSIM')
# without project context
opal.sql(o,
  'select avg(LAB_HDL) as HDL_AVG, GENDER 
     from `CNSIM.CNSIM1` 
     where LAB_HDL is not null 
     group by GENDER')
opal.logout(o)
}
}
