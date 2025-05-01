#' Get a team's name from its three letter abbreviation
#'
#' @param teamID The team's ID as used in Lahman::Teams
#' @param most_recent A boolean indicating whether to only give the most recent name used by that team code, Default: TRUE
#'
#' @returns A string (the team's name) or a vector of strings (all unique team names corresponding to that code over the years)
#' @export
#'
#' @examples
#' getTeamName("alt")
#' getTeamName("hou", FALSE)

getTeamName <- function(teamID, most_recent = TRUE) {
  # find the team with matching three letter ID (in all caps), the name of which is column 41
  name <- Lahman::Teams[Lahman::Teams$teamID == stringr::str_to_upper(teamID), 41]

  if (length(name) == 0){
    # if the length of this is 0, no matches were found
    message(sprintf("Error finding team %s in Lahman::Teams, try using getTeamId() to find the correct code.", teamID))
  } else {
    # there is an entry for every year per franchise, unique() ensures a simple list of team aliases
    if (most_recent)
      # -1 index doesn't work for vector of size 1
      if (length(unique(name)[-1]) == 0)
        return(unique(name))
      else
        return(unique(name)[-1]) # return the last name in the list (most recent team name)
    else
      return(unique(name))
  }
}
