#' Get the fielding position(s) for a given player
#'
#' @param pID The playerID of the player to search
#' @param list A boolean; if TRUE, function will return a tibble for the player indicating all positions played and the number of games at each position. If FALSE, just returns the most frequently played position, Default: FALSE
#' @param years A single year or a vector of (start year, end year) indicating what years to include for the given player
#'
#' @returns A string (the player's primary position) or a tibble with POS and totalG columns
#' @export
#'
#' @examples
#' playerPos(getPlayerID("sammy sosa"))
#' playerPos(getPlayerID("dylan moore"), list=T, years=2019)


playerPos <- function(pID, list = FALSE, years = c(1871, 2023)) {
  # if only one year is passed in, we still want a range of two years, so concat to itself
  if (length(years) == 1)
    years <- c(years, years)

  # get the table for the given player in the given years
  filtered <- Lahman::Fielding %>% dplyr::filter(playerID == pID, yearID >= years[1] & yearID <= years[2])
  # aggregate and count games
  positions <- filtered %>% dplyr::group_by(POS) %>% dplyr::summarise(totalG = sum(G))
  # get the table for outfield positions with similar aggregation
  filteredOF <- Lahman::FieldingOFsplit %>% dplyr::filter(playerID == pID, yearID >= years[1] & yearID <= years[2])
  positionsOF <- filteredOF %>% dplyr::group_by(POS) %>% dplyr::summarise(totalG = sum(G))

  # combine these two tables, removing the generic OF indicator
  posTable <- dplyr::union(positions, positionsOF) %>% dplyr::filter(POS != "OF") %>% dplyr::arrange(-totalG)

  # handle errors
  if (nrow(posTable) == 0)
    message("No results; ensure you have the right playerID (use getPlayerID()) and what years he played.")

  # if not list, return the position with the highest total games
  if (!list)
    return(posTable$POS[1])
  # otherwise return the whole table
  return(posTable)
}
