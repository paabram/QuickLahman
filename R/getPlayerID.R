#' Quickly convert between a player's name and his code in the Lahman database
#'
#' @param name The player's full name, "First Last"
#'
#' @description
#' If there are more than one matching players, this will return all of them.
#' Typically, the numeric suffix for these players is in ascending order by debut date.
#'
#' @returns A string, the playerID for the player with the given name. If there are multiple matching players, this will be a vector of strings
#' @export
#'
#' @examples
#' getPlayerID("Dansby Swanson")

#' getPlayerID("Ken Griffey")

getPlayerID <- function(name) {
  # split the given name on space
  first_last<- unlist(strsplit(name, split=" "))
  first <- stringr::str_to_title(first_last[1])
  last <- stringr::str_to_title(first_last[2])
  # access the playerID (column 1) for the records matching this name
  pID <- Lahman::People[Lahman::People$nameFirst == first & Lahman::People$nameLast == last, 1]
  if (length(pID) == 0){
    # if the length of this is 0, no matches were found
    message(sprintf("Error finding player %s in Lahman::People, check your spelling.", name))
  } else {
    return(pID)
  }
}
