#' Get the database ID for a team
#'
#' @param teamName The team to get the ID for, "City TeamName"
#'
#' @returns A string, that team's three letter abbreviation
#' @export
#'
#' @examples
#' getTeamID("chicago cubs")

getTeamID <- function(teamName) {
  # find the team with matching name, the ID of which is column 3
  tID <- Lahman::Teams[stringr::str_to_lower(Lahman::Teams$name) == stringr::str_to_lower(teamName), 3]
  # there is an entry for every year per franchise, unique() removes these duplicates
  # teamID is a factor, so it is cast to string
  return(as.character(unique(tID)))
}
