#' Get the team(s) a player played for
#'
#' @param pID The player's playerID
#' @param list A boolean; if TRUE, function will return a tibble for the player indicating all teams played on and the number of seasons with each. If FALSE, just returns the team played at longest, Default: FALSE
#' @param years A single year or a vector of (start year, end year) indicating what years to include for the given player
#'
#' @returns A string (the player's primary position) or a tibble with team, seasons, first year, and last year columns
#' @export
#'
#' @examples
#' playerTeam("ruthba01", list = T)
#'
#' playerTeam(getPlayerID("hank aaron"), years = c(1965, 1970))

playerTeam <- function(pID, list = FALSE, years = c(1871, 2023)) {
  # if only one year is passed in, we still want a range of two years, so concat to itself
  if (length(years) == 1)
    years <- c(years, years)

  # get the table for the given player in the given years
  filtered <- Lahman::Fielding %>%
    dplyr::distinct(playerID, teamID, yearID) %>%
    dplyr::filter(playerID == pID, yearID >= years[1] & yearID <= years[2])
  # aggregate and count games
  teams <- filtered %>% dplyr::group_by(teamID) %>%
    dplyr::summarise(seasons = n(), firstYear = min(yearID), lastYear = max(yearID))
  teams <- teams %>%
    dplyr::arrange(-seasons)

  # handle errors
  if (nrow(teams) == 0)
    message("No results; ensure you have the right playerID (use getPlayerID()) and what years he played.")

  # if not list, return the position with the highest total games
  if (!list)
    return(teams$teamID[1])
  # otherwise return the whole table
  return(teams)
}
