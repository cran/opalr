#-------------------------------------------------------------------------------
# Copyright (c) 2021 OBiBa. All rights reserved.
#  
# This program and the accompanying materials
# are made available under the terms of the GNU Public License v3.0.
#  
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------

#' Apply the dictionary to a tibble
#'
#' Apply the dictionary described in a Opal Excel format as attributes of the tibble's columns.
#'
#' @param tibble Tibble to be decorated.
#' @param variables A data frame with one row per variable (column name) and then one column per property/attribute.
#' @param categories A data frame with one row per category (columns variable and name) and then column per property/attribute.
#' @param merge Either append attributes to existing ones or replace them. Default is FALSE, for dictionary consistency.
#' @examples 
#' \dontrun{
#' data <- tibble::as_tibble(mtcars)
#' variables <- tibble::tribble(
#'   ~name, ~valueType, ~`label:en`, ~`label:fr`,  ~`Namespace::Name`, ~unit, ~repeatable, ~index,
#'   "mpg", "decimal", "Mpg label", "Mpg libellé",  "Value1", "years", 0, 1,
#'   "cyl", "decimal", "Cyl label", "Cyl libellé",  "Value2", "kg/m2", 0, 2,
#'   "disp", "decimal", "Disp label", "Disp libellé", NA, NA, 1, 3
#' )
#' categories <- tibble::tribble(
#'   ~variable, ~name, ~missing, ~`label:en`, ~`label:fr`,
#'   "cyl", "4", 0, "Four", "Quatre",
#'   "cyl", "6", 0, "Six", "Six",
#'   "cyl", "8", 1, "Height", "Huit"
#' )
#' data <- dictionary.apply(data, variables, categories)
#' }
#' @export
#' @import labelled
dictionary.apply <- function(tibble, variables, categories = NULL, merge = FALSE) {
  tbl <- tibble
  names <- names(tbl)
  applyAttribute <- function(attrs, name, value, append = FALSE) {
    rval <- attrs
    if (is.null(rval)) {
      rval <- list()
      rval[[name]] <- value
    } else if (is.null(rval[[name]])) {
      rval[[name]] <- value
    } else if (isTRUE(append)) {
      rval[[name]] <- paste0(rval[[name]], " | ", value)
    } else {
      rval[[name]] <- value
    }
    rval
  }
  localizedValue <- function(name, value) {
    nameWithLocale <- strsplit(name, ":")[[1]]
    val <- value
    if (length(nameWithLocale)>1) {
      val <- paste0("(", nameWithLocale[2], ") ", val)
    }
    val
  }
  naVector <- function(valueType) {
    naValue <- as.character(NA)
    if (!is.null(valueType)) {
      if ("integer" %in% valueType) {
        naValue <- as.integer(naValue)
      } else if ("decimal" %in% valueType) {
        naValue <- as.numeric(naValue)
      } else if ("boolean" %in% valueType) {
        naValue <- as.logical(naValue)
      }
    }
    rep(naValue, nrow(tbl))
  }
  asValueType <- function(catNames, valueType) {
    rval <- catNames
    if (!is.null(valueType)) {
      if ("integer" %in% valueType) {
        rval <- as.integer(catNames)
      } else if ("decimal" %in% valueType) {
        rval <- as.numeric(catNames)
      } else if ("boolean" %in% valueType) {
        rval <- as.logical(catNames)
      }
    }
    rval
  }
  pb <- .newProgress(total = 1 + nrow(variables))
  # go through variable descriptions
  for (i in 1:nrow(variables)) {
    var <- variables[i,]
    .tickProgress(pb, tokens = list(what = var$name))
    # do we have a variable and a column with same name
    if (!(var$name %in% names)) {
      tbl[[var$name]] <- naVector(var$valueType)
      tbl <- tibble::as_tibble(tbl)
    }
    if (base::isFALSE(merge)) {
      attributes(tbl[[var$name]]) <- list()
    }
    # look for categories and apply labels
    if (!is.null(categories)) {
      varcats <- categories[categories$variable == var$name,]
      if (nrow(varcats)>0) {
        labels <- asValueType(varcats$name, var$valueType)
        missings <- list()
        for (n in names(varcats)) {
          if (startsWith(n, "label")) { # note: multilang labels not supported
            if (is.null(names(labels))) {
              names(labels) <- localizedValue(n, varcats[[n]])
            } else {
              names(labels) <- .mergeCharVectors(names(labels), localizedValue(n, varcats[[n]])) 
            }
          } else if (n == "missing") {
            missings <- as.logical(sapply(varcats[[n]], .as.zeroOne))
          }
        }
        attrs <- attributes(tbl[[var$name]])
        if (is.null(attrs)) {
          attrs <- list()
        }
        labelled::val_labels(tbl[[var$name]]) <- labels
        attributes(tbl[[var$name]]) <- append(attributes(tbl[[var$name]]), attrs)
        if (any(missings)) {
          attributes(tbl[[var$name]])$na_values <- labels[missings]
        }
      }
    }
    # make column attributes from variable description
    for (n in names(var)) {
      attrs <- attributes(tbl[[var$name]])
      if (startsWith(n, "label")) {
        attrs <- applyAttribute(attrs, "label", localizedValue(n, var[[n]]), append = TRUE)
      } else if (startsWith(n, "description")) {
        attrs <- applyAttribute(attrs, "description", localizedValue(n, var[[n]]), append = TRUE)
      } else if (n == "valueType") {
        attrs <- applyAttribute(attrs, "opal.value_type", var[[n]])
      } else if (n == "unit") {
        attrs <- applyAttribute(attrs, "opal.unit", var[[n]])
      } else if (n == "referencedEntityType") {
        attrs <- applyAttribute(attrs, "opal.referenced_entity_type", var[[n]])
      } else if (n == "mimeType") {
        attrs <- applyAttribute(attrs, "opal.mime_type", var[[n]])
      } else if (n == "occurrenceGroup") {
        attrs <- applyAttribute(attrs, "opal.occurrence_group", as.character(ifelse(isTRUE(nchar(var[[n]]) > 0), var[[n]], NA_character_)))
      } else if (n == "repeatable") {
        attrs <- applyAttribute(attrs, "opal.repeatable", .as.zeroOne(var[[n]]))
      } else if (n == "index") {
        attrs <- applyAttribute(attrs, "opal.index", var[[n]])
      } else if (n != "name") {
        attrs <- applyAttribute(attrs, n, var[[n]])
      }
      attributes(tbl[[var$name]]) <- attrs
    }
  }
  .tickProgress(pb, tokens = list(what = paste0("Dictionary completed")))
  tbl
}

#' Inspect the dictionary of a tibble
#'
#' Inspect the data dictionary, checking for inconsistencies. Error is raised when the identifiers
#' column cannot be found.
#'
#' @param tibble Tibble to be inspected.
#' @param id.name The name of the column representing the entity identifiers. Default is 'id'.
#' @param warn Print warning messages. Default is TRUE.
#' @return TRUE if inspection is successful, FALSE otherwise.
#' @examples 
#' \dontrun{
#' # prepare datasets of visits, several visits for one patient
#' visits <- tibble::tribble(
#' ~id, ~patient_id, ~sex, ~visit_date,
#' 1, 1, "M", as.Date("2020-01-01"),
#' 2, 2, "F", as.Date("2020-01-02"),
#' 3, 3, "M", as.Date("2020-01-03"),
#' 4, 3, "M", as.Date("2020-01-04"))
#' 
#' o <- opal.login("administrator", "password", url = "https://opal-demo.obiba.org")
#' 
#' # save visits dataset
#' opal.table_save(o, visits, "RSRC", "visits", type = "Visit", force = TRUE)
#' 
#' # get visit and make it a dataset of patients 
#' patients <- opal.table_get(o, "RSRC", "visits", id.name = "id")
#' # set dataset IDs
#' patients$visit_id <- patients$id
#' patients$id <- patients$patient_id
#' patients$patient_id <- NULL
#' patients
#' 
#' # save patients dataset, there should be a warning that some variables are not repeatable
#' # while there are patients with multiple data lines
#' opal.table_save(o, patients, "RSRC", "patients", type = "Participant", force = TRUE)
#' 
#' opal.logout(o)
#' }
#' @export
dictionary.inspect <- function(tibble, id.name = 'id', warn = TRUE) {
  # check for ID column, mandatory
  if (!(id.name %in% colnames(tibble))) {
    stop("No identifiers column with name '", id.name, "'", call. = FALSE)
  }
  # check for non missing ID values, mandatory
  if (!all(sapply(tibble[[id.name]], function(id) !(is.null(id) || is.na(id) || nchar(as.character(id)) == 0)))) {
    stop("Some identifiers are missing in column '", id.name, "'", call. = FALSE)
  }
  rval <- TRUE
  # check whether it is a multilines dataset
  if (length(unique(tibble[[id.name]])) < nrow(tibble)) {
    for (n in colnames(tibble)) {
      if (n != id.name) {
        attrs <- attributes(tibble[[n]])
        if (!is.null(attrs$opal.repeatable) && attrs$opal.repeatable == 0) {
          rval <- FALSE
          warning("Column is not repeatable in a multilines dataset (identifiers column is '", id.name,"'): ", n, call. = FALSE, immediate. = TRUE)
        }
      }
    }
  }
  rval
}
