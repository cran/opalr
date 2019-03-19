#-------------------------------------------------------------------------------
# Copyright (c) 2019 OBiBa. All rights reserved.
#  
# This program and the accompanying materials
# are made available under the terms of the GNU Public License v3.0.
#  
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------

#' Log in Opal(s).
#' 
#' @title Opal login
#' 
#' @family connection functions
#' @return A opal object or a list of opal objects.
#' @param username User name in opal(s). Can be provided by "opal.username" option.
#' @param password User password in opal(s). Can be provided by "opal.password" option.
#' @param url Opal url or list of opal urls. Can be provided by "opal.url" option.
#' @param opts Curl options as described by httr (call httr::httr_options() for details). Can be provided by "opal.opts" option.
#' @param restore Workspace ID to be restored (see also opal.logout)
#' @export
#' @examples 
#' \donttest{
#' #### The below examples illustrate the different ways to login in opal ####
#'
#' # explicite username/password login
#' o <- opal.login(username='administrator',password='password',url='https://opal-demo.obiba.org')
#' opal.logout(o)
#'
#' # login using options
#' options(opal.username='administrator',
#'  opal.password='password',
#'  opal.url='https://opal-demo.obiba.org')
#' o <- opal.login()
#' opal.logout(o)
#'
#' # login using ssl key pair
#' options(opal.opts=list(
#'    sslcert='my-publickey.pem',
#'    sslkey='my-privatekey.pem'))
#' o <- opal.login(url='https://opal-demo.obiba.org')
#' opal.logout(o)
#'}
opal.login <- function(username=getOption("opal.username"), password=getOption("opal.password"), url=getOption("opal.url"), opts=getOption("opal.opts", list()), restore=NULL) {
  if (is.null(url)) stop("opal url is required", call.=FALSE)
  if(is.list(url)){
    lapply(url, function(u){opal.login(username, password, u, opts=opts, restore=restore)})
  } else {
    .opal.login(username, password, url, opts=opts, restore=restore)
  }
}

#' Clear the R sessions and logout from Opal(s).
#' 
#' @title Logout from Opal(s)
#' 
#' @family connection functions
#' @param opal Opal object or a list of opals.
#' @param save Save the workspace with given identifier (default value is FALSE, current session ID if TRUE).
#' @examples 
#' \donttest{
#' o <- opal.login('administrator','password','https://opal-demo.obiba.org')
#' opal.logout(o)
#' }
#' @export
opal.logout <- function(opal, save=FALSE) {
  res <- NULL
  if (is.list(opal)) {
    res <- lapply(opal, function(o){opal.logout(o, save)})  
  } else {
    if ((is.logical(save) && save) || is.character(save)) {
      if (!is.na(opal$version) && opal.version_compare(opal,"2.6")<0) {
        warning("Workspaces are not available for opal ", opal$version, " (2.6.0 or higher is required)")
      }
    }
    res <- try(.rmRSession(opal, save), silent=TRUE)
    opal$rid <- NULL
    
    res <- try(.rmOpalSession(opal), silent = TRUE)
    opal$sid <- NULL
  }
  if (.is.verbose() && !is.null(res) && length(res) > 0) {
    return(res)
  }
}

#' @export
print.opal <- function(x, ...) {
  cat("url:", x$url, "\n")
  cat("name:", x$name, "\n")
  cat("version:", x$version, "\n")
  cat("username:", x$username, "\n")
  if (!is.null(x$rid)) {
    cat("rid:", x$rid, "\n")  
  }
  if (!is.null(x$restore)) {
    cat("restore:", x$restore, "\n")  
  }
}

#' Compare Opal version with the provided one. Note that a request must have been done 
#' in order to have a non-null Opal version.
#' 
#' @title Compare 
#' 
#' @return >0 if Opal version is more recent, 0 if equals, <0 otherwise.
#' @param opal Opal object.
#' @param version The semantic version string to be compared.
#' @examples 
#' \donttest{
#' o <- opal.login('administrator','password','https://opal-demo.obiba.org')
#' opal.version_compare(o, "2.6.0")
#' opal.logout(o)
#' }
#' @export
opal.version_compare <- function(opal, version) {
  if (is.null(opal$version) || is.na(opal$version)) {
    stop("opal version is not set", call.=FALSE)
  }
  ov <- strsplit(opal$version, "-")[[1]][1]
  if (ov == version) return(0)
  # semver: major.minor.patch
  osv <- as.numeric(strsplit(ov, "\\.")[[1]])
  sv <- as.numeric(strsplit(version, "\\.")[[1]])
  if (length(sv) == 2) sv[3] <- 0
  # compare major
  if (osv[1] > sv[1]) return(1)
  if (osv[1] < sv[1]) return(-1)
  # compare minor
  if (osv[2] > sv[2]) return(1)
  if (osv[2] < sv[2]) return(-1)
  # compare patch
  if (osv[3] > sv[3]) return(1)
  if (osv[3] < sv[3]) return(-1)
  # same versions
  return(0)
}


#' Generic REST resource getter.
#' 
#' @family REST functions
#' @param opal Opal object.
#' @param ... Resource path segments.
#' @param query Named list of query parameters.
#' @param callback A callback function to handle the response object.
#' @import httr
#' @examples 
#' \donttest{
#' o <- opal.login('administrator','password','https://opal-demo.obiba.org')
#' opal.get(o, 'project', 'datashield')
#' opal.logout(o)
#' }
#' @export
opal.get <- function(opal, ..., query=list(), callback=NULL) {
  r <- GET(.url(opal, ...), query=query, config=opal$config, handle = opal$handle, .verbose())
  .handleResponseOrCallback(opal, r, callback)
}

#' Generic REST resource creation.
#' 
#' @family REST functions
#' @param opal Opal object.
#' @param ... Resource path segments.
#' @param query Named list of query parameters.
#' @param body The body of the request.
#' @param contentType The type of the body content.
#' @param callback A callback function to handle the response object.
#' @import httr
#' @examples 
#' \donttest{
#' o <- opal.login('administrator','password','https://opal-demo.obiba.org')
#' opal.post(o, 'some', 'resources', body='{"some":"value"}')
#' opal.logout(o)
#' }
#' @export
opal.post <- function(opal, ..., query=list(), body='', contentType='application/x-rscript', callback=NULL) {
  r <- POST(.url(opal, ...), query=query, body=body, content_type(contentType), config=opal$config, handle = opal$handle, .verbose())
  .handleResponseOrCallback(opal, r, callback)
}

#' Generic REST resource update.
#' 
#' @family REST functions
#' @param opal Opal object.
#' @param ... Resource path segments.
#' @param query Named list of query parameters.
#' @param body The body of the request.
#' @param contentType The type of the body content.
#' @param callback A callback function to handle the response object.
#' @import httr
#' @examples 
#' \dontrun{
#' o <- opal.login('administrator','password','https://opal-demo.obiba.org')
#' opal.put(o, 'some', 'resource', 'toupdate', body='{"some":"value"}')
#' opal.logout(o)
#' }
#' @export
opal.put <- function(opal, ..., query=list(), body='', contentType='application/x-rscript', callback=NULL) {
  r <- PUT(.url(opal, ...), query=query, body=body, content_type(contentType), config=opal$config, handle = opal$handle, .verbose())
  .handleResponseOrCallback(opal, r, callback)
}

#' Generic REST resource deletion.
#' 
#' @family REST functions
#' @param opal Opal object.
#' @param ... Resource path segments.
#' @param query Named list of query parameters.
#' @param callback A callback function to handle the response object.
#' @import httr
#' @examples 
#' \dontrun{
#' o <- opal.login('administrator','password','https://opal-demo.obiba.org')
#' opal.delete(o, 'some', 'resource')
#' opal.logout(o)
#' }
#' @export
opal.delete <- function(opal, ..., query=list(), callback=NULL) {
  r <- DELETE(.url(opal, ...), query=query, config=opal$config, handle = opal$handle, .verbose())
  .handleResponseOrCallback(opal, r, callback)
}

#' Utility method to build urls. Concatenates all arguments and adds a '/' separator between each element
#' @import utils
#' @keywords internal
.url <- function(opal, ...) {
  utils::URLencode(paste(opal$url, "ws", paste(c(...), collapse="/"), sep="/"))
}

#' Constructs the value for the Authorization header
#' @import jsonlite
#' @keywords internal
.authToken <- function(username, password) {
  paste("X-Opal-Auth", jsonlite::base64_enc(paste(username, password, sep=":")))
}

#' Process response with default handler or the provided one
#' @keywords internal
.handleResponseOrCallback <- function(opal, response, callback=NULL) {
  if (is.null(callback)) {
    .handleResponse(opal, response)  
  } else {
    handler <- match.fun(callback)
    handler(opal, response)
  }
}

#' Default request response handler.
#' @keywords internal
.handleResponse <- function(opal, response) {
  #print(response)
  headers <- httr::headers(response)
  
  # Extract some headers
  if (is.null(opal$version) || is.na(opal$version)) {
    opal$version <- as.character(headers[tolower('X-Opal-Version')])
  }
  if (is.null(opal$sid)) {
    opal$sid <- .extractOpalSessionId(httr::cookies(response)) 
  }
  
  if (response$status>=300) {
    .handleError(opal, response)
  }
  
  disposition <- headers['Content-Disposition']
  if(!is.na(disposition) && length(grep("attachment", disposition))) {
    .handleAttachment(opal, response, as.character(disposition))
  } else {
    .handleContent(opal, response)
  }
}

#' Handle error response
#' @keywords internal
.handleError <- function(opal, response) {
  headers <- httr::headers(response)
  content <- .getContent(opal, response)
  msg <- http_status(response)$message
  if (is.null(content)) {
    stop(msg, call.=FALSE)
  }
  
  if ("status" %in% names(content)) {
    msg <- paste0(msg, "; ", content$status)
    if ("arguments" %in% names(content)) {
      msg <- paste0(msg, ": ", paste(content$arguments, collapse = ", "))
    }
    stop(msg, call.=FALSE)
  }
  
  if ("error" %in% names(content)) {
    if ("message" %in% names(content)) {
      stop(content$message, call.=FALSE)
    } else {
      stop(content$error, call.=FALSE)  
    }
  }
  
  stop(msg, call.=FALSE)
}

#' Default request response Location handler.
#' @keywords internal
.handleResponseLocation <- function(opal, response) {
  if (is.null(opal$version) || is.na(opal$version)) {
    opal$version <- as.character(response$headers['X-Opal-Version'])
  }
  if (is.null(opal$sid)) {
    opal$sid <- .extractOpalSessionId(httr::cookies(response))  
  }

  if (response$status>=300) {
    .handleError(opal, response)
  }
  
  headers <- httr::headers(response)
  location <- headers['Location']
  if(!is.na(location)) {
    location <- location$Location
    substring(location, regexpr(pattern = "/ws/", location) + 3)
  } else {
    NULL
  }
}

#' @import mime
#' @keywords internal
.handleAttachment <- function(opal, response, disposition) {
  headers <- httr::headers(response)
  content <- .getContent(opal, response)
  
  filename <- strsplit(disposition,"\"")[[1]][2]
  filetype <- mime::guess_type(filename)
  if(is.raw(content)) {
    if (grepl("text/", headers$`content-type`) || (grepl("application/", headers$`content-type`) && grepl("text/", filetype))){
      as.character(readChar(content, length(content)))
    } else {
      readBin(content,what = raw(),length(content))
    }
  } else if (length(grep("text/", headers$`content-type`))) {
    as.character(content)
  } else {
    content
  }
}

#' @import httr
#' @keywords internal
.handleContent <- function(opal, response) {
  headers <- httr::headers(response)
  content <- .getContent(opal, response)
  
  if(length(grep("octet-stream", headers$`content-type`))) {
    unserialize(content)
  } else if (length(grep("text", headers$`content-type`))) {
    as.character(content)
  } else {
    content
  }
}

#' Wrapper of httr::content()
#' @import httr
#' @keywords internal
.getContent <- function(opal, response) {
  headers <- httr::headers(response)
  if (is.null(headers$`content-type`)) {
    NULL
  } else if (headers$`content-type` == "application/x-protobuf+json") {
    jsonlite::fromJSON(httr::content(response, as="text", encoding = opal$encoding))
  } else {
    httr::content(response, encoding = opal$encoding)
  }
}

#' Extract opalsid from cookie data frame.
#' @keywords internal
.extractOpalSessionId <- function(cookies) {
  if (nrow(cookies[cookies$name=="opalsid",])>0) {
    sid <- cookies[cookies$name=="opalsid",]$value
    if (!is.na(sid)) {
      return(sid)
    }
  }
  return(NULL)
}

#' Check if response content is empty.
#' @keywords internal
.isContentEmpty <- function(content) {
  return(is.null(content) 
  || (is.raw(content) && nchar(rawToChar(content))==0)
  || (is.character(content) && nchar(content)==0))
}

#' Create the opal object
#' @import httr
#' @keywords internal
.opal.login <- function(username, password, url, opts=list(), restore=NULL) {
  if (is.null(url)) stop("opal url is required", call.=FALSE)
  opal <- new.env(parent=globalenv())
  # Username
  opal$username <- username
  # Strip trailing slash
  opal$url <- sub("/$", "", url)
  # Domain name
  opal$name <- gsub("[:/].*", "", gsub("http[s]*://", "", opal$url))
  # Version default value
  opal$version <- NA
  # Server response encoding
  opal$encoding <- "UTF-8"
  if (!is.null(opts$encoding)) {
    opal$encoding <- opts$encoding
    opts$encoding <- NULL # not a httr/curl option
  }
  
  # authentication token
  if(is.null(username) == FALSE) {
    # Authorization
    opal$authorization <- .authToken(username, password)
  }
  # httr/curl options
  protocol <- strsplit(url, split="://")[[1]][1]
  options <- opts
  if (protocol=="https") {
    if (!is.null(options$cainfo)) {
      options$cainfo <- .getPEMFilePath(options$cainfo)
    }
    if (!is.null(options$sslcert)) {
      options$sslcert <- .getPEMFilePath(options$sslcert)
    }
    if (!is.null(options$sslkey)) {
      options$sslkey <- .getPEMFilePath(options$sslkey)
    }
    # legacy RCurl options to httr
    if (!is.null(options$ssl.verifyhost)) {
      options$ssl_verifyhost = options$ssl.verifyhost
      options$ssl.verifyhost <- NULL
    }
    if (!is.null(options$ssl.verifypeer)) {
      options$ssl_verifypeer = options$ssl.verifypeer
      options$ssl.verifypeer <- NULL
    }
  }
  opal$config <- config()
  opal$config$options <- options
  opal$handle <- handle(paste0(opal$url, "/", sample(1000:9999, 1))) # append a random number to ensure urls are different
  opal$rid <- NULL
  opal$restore <- restore
  class(opal) <- "opal"
  
  # get user profile to test sign-in
  r <- GET(.url(opal, "system", "subject-profile", "_current"), config = opal$config, httr::add_headers(Authorization = opal$authorization), handle = opal$handle, .verbose())
  opal$profile <- .handleResponse(opal, r)
  if(is.null(username)) {
    opal$username <- opal$profile$principal
  }
  
  opal
}

#' Extract R session Id from opal object, create a new R session if not found.
#' @keywords internal
.getRSessionId <- function(opal) {
  if(is.null(opal$rid)) {
    opal$rid <- .newSession(opal, restore=opal$restore)
  }
  if(is.null(opal$rid)) {
    stop("Remote R session not available")
  }
  return(opal$rid)
}

#' Create a new R session in Opal.
#' @keywords internal
.newSession <- function(opal, restore=NULL) {
  query <- list()
  if (!is.null(restore)) {
    query <- list(restore=restore)  
  }
  res <- .extractJsonField(opal.post(opal, "r", "sessions", query=query), c("id"), isArray=FALSE)
  return(res$id)
}

#' Remove a Opal session (logout)
#' @keywords internal
.rmOpalSession <- function(opal) {
  if (!is.null(opal$sid)) {
    opal.delete(opal, "auth", "session", opal$sid)
  }
}

#' Remove a R session from Opal.
#' @keywords internal
.rmRSession <- function(opal, save=FALSE) {
  if (!is.null(opal$rid)) {
    if ((is.logical(save) && save) || is.character(save)) {
      saveId <- save
      if(is.logical(save) && save) {
        saveId <- opal$rid
      }
      opal.delete(opal, "r", "session", opal$rid, query=list(save=saveId))
      if(saveId != save) {
        return(saveId)
      }
    } else {
      opal.delete(opal, "r", "session", opal$rid)
    }
  }
}

#' Get all R session in Opal.
#' @keywords internal
.getSessions <- function(opal) {
  .extractJsonField(opal.get(opal, "r", "sessions"))
}

#' Verbose flag
#' @import httr
#' @keywords internal
.verbose <- function() {
  verbose <- NULL
  if (.is.verbose()) {
    verbose <- httr::verbose()
  }
  verbose
}

#' Verbose option
#' @keywords internal
.is.verbose <- function() {
  getOption("verbose", FALSE)
}