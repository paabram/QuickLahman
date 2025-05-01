#' Gather stats over the entire year range of a table
#'
#' @param data The table to aggregate stats across years for
#' @param agg The aggregate function to apply to numeric columns, Default: sum()
#'
#' @returns A dataframe, the original table grouped by player with the aggregate function applied to numeric columns
#' @export
#'
#' @details
#' Also adds to the return table a column for debut year, retirement year, and years active (all within the limits of data).
#' data must include playerID and yearID to function.
#'
#' @examples
#' # The Yankees players with the best career OPS since integration
#' CareerStats(
#'   battingStats(
#'     QuickStats(Batting, teams = "NYA", years = eraToYears("integration", "modern")) %>%
#'     filter(G>100)
#'   ),
#'   agg = mean
#' ) %>%
#' select(playerID, G, BA:yearsActive) %>%
#' arrange(-OPS)

CareerStats <- function(data, agg = sum) {
  # extract the numeric columns besides year and stint
  num_cols <- setdiff(
    names(data)[vapply(data, is.numeric, logical(1))],
    c("yearID", "stint")
  )
  # group by player, applying the aggregate function to all numeric columns and
  #   breaking year into debuts/retirement/length of career
  grouped <- data %>% group_by(playerID) %>%
    summarise(across(all_of(num_cols), ~ agg(.x, na.rm = T)),
              debut = min(yearID),
              retirement = max(yearID),
              yearsActive = retirement - debut + 1,
              .groups = "drop")

  return(grouped)
}
