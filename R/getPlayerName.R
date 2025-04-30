#' Get a player's name from his playerID
#'
#' @param playerID The player's ID in the Lahman::People table
#'
#' @returns A string, the player's name ("First Last")
#' @export
#'
#' @examples
#' getPlayerName("johnsra05")

getPlayerName <- function(playerID) {
  # access the first name (column 14) and last (column 15) for the records matching this id
  name <- Lahman::People[Lahman::People$playerID == playerID, c(14, 15)]
  return(sprintf("%s %s", name$nameFirst, name$nameLast))
}
