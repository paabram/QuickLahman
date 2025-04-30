#' Convert historic era terms to a range of years
#'
#' @description Accepts a named era in baseball history and returns the
#' range of years covering that era (as used on baseball-reference.com).
#' The acceptable eras and the years they cover are:\enumerate{
#' \item "preMLB": 1871-1903
#' \item "deadBall": 1901-1919
#' \item "liveBall": 1920-1941
#' \item "integration": 1942-1960
#' \item "expansion": 1961-1976
#' \item "freeAgency": 1977-1993
#' \item "steroid": 1994-2005
#' \item "modern": 2006-2023}
#' If an argument is provided for endEra, this will return the first year in startEra
#' and the last year of endEra. Return the year range of only the given startEra by default.
#'
#'
#' @param startEra The era to begin the year range on
#' @param endEra The era to go through and end the year range on, Default: startEra
#'
#' @returns A vector of two years, the start and end of a range within 1871-2023
#' @export
#'
#' @examples
#' eraToYears("liveBall", endEra = "freeAgency")

eraToYears <- function(startEra, endEra = startEra) {
  startYear <- switch(startEra,
                      "preMLB" = 1871,
                      "deadBall" = 1901,
                      "liveBall" = 1920,
                      "integration" = 1942,
                      "expansion" = 1961,
                      "freeAgency" = 1977,
                      "steroid" = 1994,
                      "modern" = 2006
                      )
  endYear <- switch(endEra,
                    "preMLB" = 1903,
                    "deadBall" = 1919,
                    "li
                    veBall" = 1941,
                    "integration" = 1960,
                    "expansion" = 1976,
                    "freeAgency" = 1993,
                    "steroid" = 2005,
                    "modern" = 2023
                    )
  return(c(startYear, endYear))
}
