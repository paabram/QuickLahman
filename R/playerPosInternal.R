# For use internally to apply a "position" column to dataframes

# playerPosInternal <- function(data, players = NULL, years = c(1871, 2023), teams = NULL, lg = NULL) {
#   if (is.null(players)) players <- unique(data$playerID)
#   if (is.null(teams)) teams <- unique(data$teamID)
#   if (is.null(lg)) lg <- unique(data$lgID)
#
#   # Combine fielding positions
#   fielding_main <- Lahman::Fielding %>%
#     dplyr::filter(playerID %in% players,
#                   yearID >= years[1] & yearID <= years[2],
#                   teamID %in% teams, lgID %in% lg) %>%
#     dplyr::group_by(playerID, POS) %>%
#     dplyr::summarise(totalG = sum(G), .groups = "drop")
#
#   fielding_of <- Lahman::FieldingOFsplit %>%
#     dplyr::filter(playerID %in% players,
#                   yearID >= years[1] & yearID <= years[2],
#                   teamID %in% teams, lgID %in% lg) %>%
#     dplyr::group_by(playerID, POS) %>%
#     dplyr::summarise(totalG = sum(G), .groups = "drop")
#
#   # Combine both, excluding generic OF
#   all_pos <- dplyr::bind_rows(fielding_main, fielding_of) %>%
#     dplyr::filter(POS != "OF") %>%
#     dplyr::group_by(playerID, POS) %>%
#     dplyr::summarise(totalG = sum(totalG), .groups = "drop") %>%
#     dplyr::arrange(playerID, -totalG) %>%
#     dplyr::group_by(playerID) %>%
#     dplyr::slice(1) %>%  # get top position
#     dplyr::ungroup()
#
#   return(all_pos)  # A dataframe: playerID, POS
# }

playerPosInternal <- function(data) {
  # Get the unique combinations of playerID, yearID, and teamID from the input data
  keys <- data %>%
    dplyr::select(playerID, yearID, teamID) %>%
    dplyr::distinct()

  # Filter and aggregate games by position from the main Fielding table
  fielding_main <- Lahman::Fielding %>%
    dplyr::inner_join(keys, by = c("playerID", "yearID", "teamID")) %>%
    dplyr::group_by(playerID, yearID, teamID, POS) %>%
    dplyr::summarise(totalG = sum(G), .groups = "drop")

  # Same for FieldingOFsplit
  fielding_of <- Lahman::FieldingOFsplit %>%
    dplyr::inner_join(keys, by = c("playerID", "yearID", "teamID")) %>%
    dplyr::group_by(playerID, yearID, teamID, POS) %>%
    dplyr::summarise(totalG = sum(G), .groups = "drop")

  # Combine, remove generic OF, and select top position per player
  all_pos <- dplyr::bind_rows(fielding_main, fielding_of) %>%
    dplyr::filter(POS != "OF") %>%
    dplyr::group_by(playerID, yearID, teamID, POS) %>%
    dplyr::summarise(totalG = sum(totalG), .groups = "drop") %>%
    dplyr::arrange(playerID, -totalG) %>%
    dplyr::group_by(playerID) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup()

  return(all_pos)  # Returns a data frame: playerID, POS
}
