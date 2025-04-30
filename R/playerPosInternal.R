# Used to generate the PrimaryPositions table, useful to join positions to a player/year/team combo in a vectorized way

playerPosX <- function() {
  fielding_m <- Lahman::Fielding %>% group_by(playerID, yearID, teamID, POS) %>%
    dplyr::summarise(gamesAtPos = sum(G), .groups = "drop")

  fielding_of <- Lahman::FieldingOFsplit %>%
    dplyr::group_by(playerID, yearID, teamID, POS) %>%
    dplyr::summarise(gamesAtPos = sum(G), .groups = "drop")

  all_pos <- bind_rows(fielding_m, fielding_of) %>%
    dplyr::group_by(playerID, yearID, teamID, POS) %>%
    dplyr::summarise(gamesAtPos = sum(gamesAtPos), .groups = "drop")

  primary_pos <- all_pos %>%
    dplyr::filter(POS != "OF") %>%
    dplyr::group_by(playerID, yearID, teamID) %>%
    dplyr::slice_max(order_by = gamesAtPos, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup()

  return(primary_pos)
}
# PrimaryPositions <- playerPosX()

