# Used to generate the PrimaryTeams dataset

playerTeamX <- function() {
  # use the fielding table as it will include all players
  teams <- Lahman::Fielding %>%
    dplyr::distinct(playerID, teamID, yearID) %>% # ensure only one entry per player per year
    dplyr::group_by(playerID, teamID) %>%
    dplyr::summarise(seasons = n(),
                     firstYear = min(yearID),
                     lastYear = max(yearID),
                     .groups = 'drop')

  # take the team with the highest season count as primary
  primary_team <- teams %>%
    group_by(playerID) %>%
    dplyr::slice_max(order_by = seasons, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup()

  return(primary_team)
}

# PrimaryTeams <- playerTeamX()
