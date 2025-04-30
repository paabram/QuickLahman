#' Quickly filter a table from the Lahman database
#'
#' @param data One of the tables from Lahman to filter for analysis
#' @param players A vector of or a single playerID, the players to include. Default: All in data
#' @param years A single year or a vector of (start year, end year) indicating what years to include, Default: c(1871, 2023)
#' @param teams A vector of or a single teamID, the teams to include. Default: All in data
#' @param lg A vector of or a single lgID, the leagues to include. Default: All in data
#' @param pos A vector of or a single position abbreviation, the positions to include. Default: All positions
#' @param idvars The columns to return, Default: all columns in data + POS
#'
#' @returns A dataframe, the filtered table
#' @export
#'
#' @examples
#' # postseason batting stats for National League centerfielders during the steroid era
#' QuickStats(BattingPost, years=eraToYears("steroid"), lg="NL", pos = "CF")
#'
#' # Cubs pitching stats in 2016
#' QuickStats(Pitching, teams=getTeamID("chicago cubs"), years = 2016)

QuickStats <- function(data, players = unique(data$playerID), years = c(1871, 2023),
                       teams = unique(data$teamID), lg = unique(data$lgID),
                       pos = c("P", "LF", "CF", "RF", "2B", "3B", "1B", "SS", "C"),
                       idvars = colnames(data)) {
  # if generic OF passed in, split it into all fields
  if ("OF" %in% pos)
    pos <- c(pos, "LF", "CF", "RF")
  # if only one year is passed in, we still want a range of two years, so concat to itself
  if (length(years) == 1)
    years <- c(years, years)

  # filter based on given parameters
  filtered <- data %>% dplyr::filter(playerID %in% players,
                                     yearID >= years[1] & yearID <= years[2],
                                     teamID %in% teams,
                                     lgID %in% lg)

  # join each player's primary position
  # if no position in df, join it and filter
  if (!("POS" %in% colnames(data))) {
    filtered <- filtered %>%
      left_join(PrimaryPositions, by = c("playerID", "yearID", "teamID")) %>%
      filter(POS %in% pos)
    idvars <- c(idvars, "POS")
  } else {
    # if there is, attach primary position and filter by that
    filtered <- filtered %>%
      left_join(PrimaryPositions, by = c("playerID", "yearID", "teamID")) %>%
      rename(POS = POS.x, primaryPOS = POS.y) %>%
      filter(primaryPOS %in% pos)
    idvars <- c(idvars, "primaryPOS")
  }

  return(filtered %>% select(all_of(idvars)))
}



