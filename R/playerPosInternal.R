# Used to generate the PrimaryPositions table, useful to join positions to a player/year/team combo in a vectorized way

playerPosX <- function() {
   # get fielding positions
   fielding_m <- Lahman::Fielding %>% group_by(playerID, yearID, teamID, POS) %>%
     dplyr::summarise(gamesAtPos = sum(G), .groups = "drop")

   # get specific outfielding positions
   fielding_of <- Lahman::FieldingOFsplit %>%
     dplyr::group_by(playerID, yearID, teamID, POS) %>%
     dplyr::summarise(gamesAtPos = sum(G), .groups = "drop")

   # join the two
   all_pos <- bind_rows(fielding_m, fielding_of) %>%
     dplyr::group_by(playerID, yearID, teamID, POS) %>%
     dplyr::summarise(gamesAtPos = sum(gamesAtPos), .groups = "drop")

   # determine if a more specific outfield position exists
   has_specific_of <- all_pos %>%
     dplyr::filter(POS %in% c("LF", "CF", "RF")) %>%
     dplyr::distinct(playerID, yearID, teamID) %>%
     dplyr::mutate(has_specific = TRUE)

   # join with all_pos to mark if specific OF positions exist
   all_pos_flagged <- all_pos %>%
     dplyr::left_join(has_specific_of, by = c("playerID", "yearID", "teamID")) %>%
     dplyr::mutate(has_specific = ifelse(is.na(has_specific), FALSE, has_specific))

   # filter out "OF" only when more specific positions exist
   all_pos_filtered <- all_pos_flagged %>%
     dplyr::filter(!(POS == "OF" & has_specific)) %>%
     dplyr::select(-has_specific)

   # take the position with the most games for each player/year/team
   primary_pos <- all_pos_filtered %>%
     dplyr::group_by(playerID, yearID, teamID) %>%
     dplyr::slice_max(order_by = gamesAtPos, n = 1, with_ties = FALSE) %>%
     dplyr::ungroup()

   return(primary_pos)
}
# PrimaryPositions <- playerPosX()
# use_data(PrimaryPositions, overwrite = T)
