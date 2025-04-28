#' @title Conversion of colloquial era names to year ranges
#'
#' @description
#' \code{eraToYears} accepts a named era in baseball history and returns the
#' range of years covering that era (as used on baseball-reference.com).
#' The acceptable eras and the years they cover are:
#'
#' "preMLB": 1871-1903
#' "deadBall": 1901-1919
#' "liveBall": 1920-1941
#' "integration": 1942-1960
#' "expansion": 1961-1976\
#' "freeAgency": 1977-1993
#' "steroid": 1994-2005
#' "modern": 2006-2023
#'
#' If an argument is provided for \code{endEra}, this will return the first year in `startEra`
#' and the last year of `endEra`. By default, return the year range of only one era.
#'
#' @param startEra a constant, a number or numeric vector
#' @param M biomass, a number or numeric vector
#' @param K, upper horizontal asymptote, a number or numeric vector
#' @return dM/dt, the change in mass over time or absolute growth rate (AGR) for the 3 parameter logistic model

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
  return(startYear)
}
