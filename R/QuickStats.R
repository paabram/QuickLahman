QuickStats <- function(data, players = unique(data$playerID), years = c(1871, 2023),
                       teams = unique(data$teamID), lg = unique(data$lgID),
                       pos = c("P", "LF", "CF", "RF", "2B", "3B", "1B", "SS", "C"),
                       post = 0, idvars = colnames(data)){
  # filter based on given parameters
  filtered <- data %>% dplyr::filter(playerID %in% players,
                                     yearID >= years[1] & yearID <= years[2],
                                     teamID %in% teams,
                                     lgID %in% lg)
  # add each player's primary position to the dataframe
  filtered <- filtered %>% left_join(playerPosInternal(filtered), by = "playerID")
  # filter for position
  filtered <- filtered %>% dplyr::filter(POS %in% pos)
  return(filtered)
}

# players <- c("mooredy01", "sosasa01")
# poses <- "RF"
# Batting %>% filter(playerPos(playerID) %in% poses)
# batting2 <- Batting %>% mutate(POS = playerPos(playerID))
#
smallBatting <- Batting[sample(nrow(Batting), 10000), ]
QuickStats(smallBatting, years=eraToYears("steroid"), lg = "NL", pos = c("LF", "RF", "CF"))
getPlayerName("pierrju01")
