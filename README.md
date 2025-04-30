# QuickLahman

This package adds functions to the [Sean Lahman Baseball Database Package,](https://cran.r-project.org/web/packages/Lahman/Lahman.pdf) primarily focused on preparing the most frequently used tables into an analysis-ready state with a single line, but also adding helpful functions for lookups and stat calculation; it is by no means comprehensive, but should help speed up common scenarios. The available functions are:

1.  **QuickStats(data,\
              [players = unique(data\$playerID)\
              years = c(1871, 2023)\
              teams = unique(data\$teamID),\
              lg = unique(data\$lgID),\
              pos = c("P", "LF", "CF", "RF", "2B", "3B", "1B", "SS", "C"),\
              post = 0,\
              idvars = colnames(data)])**\
        Returns the table given in *data* (likely one of `Batting`, `Fielding`, or `Pitching`; must include appropriate column names) as filtered by the passed-in arguments, all of which are optional. Designed to quickly prepare tables for analysis, providing filtration, selection, and certain joins with just a single line. It offers much greater convenience than the somewhat cumbersome data prep necessary with the base package, allowing analyses to be carried out in an R script just a few lines long.\
        *players*, *teams*, *lg,* and *pos* may be either a single string or a vector of names/teams/leagues/positions; data will be filtered to only include matching. These values should correspond to entries in the database or an error will be thrown.\
        *years* may be either a single value (in which case records are limited to only that year) or a vector of two years, returning records that fall within that range (inclusive).\
        *post* indicates whether to join the records in *data*'s corresponding postseason table (filtered in the same way); if it is `TRUE` or 1, stats will be summed between both the regular and postseason, and a column `post` will be added indicating whether that player played in the offseason that year. If it is `FALSE` or 0, postseason stats will be excluded. If it is -1, the table will exclude the regular season, providing a filtered subset of only postseason stats.\
        *idvars* is the list of columns to include in the end result (see the same parameter in battingStats in the original package).

2.  **FullStats([exclude = "Pitching",\
            list = TRUE,\
            agg = sum(),\
            awards: FALSE,\
            allstar: FALSE,\
            players: unique(data\$playerID),\
            years: c(1871, 2023),\
            teams: unique(data\$teamID),\
            lg: unique(data\$lgID),\
            pos: c("P", "LF", "CF", "RF", "2B", "3B", "1B", "SS", "C"),\
            post = 0,\
            idvars = colnames(data)])**\
        Returns a table of the full stats for each player by year, joining at least two of `Batting`, `Fielding`, and `Pitching` (see the exclude argument). Implicitly calls `QuickStats` for each table (using the same arguments), but handles joining in a way conducive to quickly getting the full details of any player's season.\
        *exclude* is the table to exclude from joining, if any. Defaults to `"Pitching"`, but may also be `"Batting"` or `"Fielding"`. Stats from the table named here will not appear in the result.\
        *list* is a boolean determining how to handle factor columns if there are multiple entries for a player in a certain year (e.g., if they played for multiple teams in the same season or at multiple positions): if it is `TRUE`, each level of the factor that appears for that player in that year will appear in a string formatted `"level1, level2, ..."`. If `FALSE`, that column will be set to its most frequent value.\
        *agg* is the function that will be applied to numeric columns for players with multiple entries in the same year; by default it is `sum`. Other arguments could be `mean`, `sd`, or any other function which takes in a vector of numbers and returns a single value.\
        *awards* determines whether or not to include entries from the `AwardsPlayers` tables, attaching a column `awards` with a list of any awards earned by that player in that season in the format `"award1, award2, ..."` if `TRUE` (defaults to `FALSE`).\
        *allstar* adds a column `allstar` indicating whether that player was named to their league's All-Star team that year if `TRUE`; this column will contain a 1 if they were an All-Star, and a 0 otherwise.\
        *players, teams, lg, pos, post,* and *idvars* function the same as in `QuickStats` (above).

3.  **CareerStats(data,\
              [list = TRUE,\
              agg = sum()])**\
        Groups the table passed in through `data` (result of FullStats, for an example) by `playerID`, giving their stats for all of their MLB career. Useful as a wrapper to the table functions above for quickly gathering a whole career's worth of stats into one entry. Rather than `yearID`, the resulting table will have columns `debut`, `retirement`, and `yearsActive`, containing that player's first year of play, his last year, and the length of his career.\
        *list* and *agg* function the same as in `FullStats` above, defining how to handle factor and numeric columns (respectively) after grouping by player.

4.  **pitchingStats(data = Lahman::Pitching,\
                [idvars = colnames(data))**\
        Creates columns of derived statistics for pitchers, similar to what `Lahman::battingStats` provides for batters. This function will calculate walks and hits per inning pitched (WHIP), hit/walks/strikeouts per nine innings (H/9, BB/9 and K/9, respectively), home run/walk/strikeout rates (HR%, BB%, K%), and their opponent's batting average on balls in play (OppBABIP). Calculating these can be problematic due to missing values, and this function attempts to handle that.\
        *data* is the table the data these statistics should be calculated for, usually `Pitching` or a subset.\
        *idvars* indicates the columns from `data` to include in the result.

5.  **getPlayerID(name)** Given a player's full `name`, return their playerID code from the `People` table. Useful for accessing stats when you have a player already in mind, allowing access to his stats by name without having to join the `People` table.

6.  **getPlayerName(playerID)** The inverse of above: given a `playerID`, return that player's full name. Allows easy readibility when results give playerIDs, eliminating the need to join or manually lookup on the `People` table.

7.  **getTeamName(teamID)** As above but for teams. Provides quick conversion of team codes to names, especially convenient for older data about teams that no longer play (and hence have unfamiliar abbreviations), avoiding lookups or joins on `Teams`.

8.  **getTeamID(name)** The inverse of `getTeamName`, providing the abbreviation code for a given team name. Note that the format is `"City Teamname"`.

9.  **playerPos(playerID,\
             [list = FALSE,\
             years = c(1871, 2023))**\
        Given a player's `playerID`, return the positions he played. Eliminates the need to join `Fielding` when considering data by position.\
        *list* determines whether to include all positions the player played in the given years as a tibble, including the number of games at each position. If `FALSE`, the function will return the most frequently played position.\
        *years* is what years to include for the given player, either a single value (limiting to only positions played that year) or a vector of two (start, end), including records that fall within that range (inclusive).

10. **eraToYears(startEra,\
             [endEra = startEra])**\
        Provides conversions for a given era of play in major league baseball (as a string) into a vector of years (start, end) as is usable by any of the above functions. Each of these eras has sometimes significant differences in play style and game rules, and this function avoids the need to research what years some analysis should span. The supported era terms are:\
        `"preMLB"`: 1871-1903\
        `"deadBall"`: 1901-1919\
        `"liveBall"`: 1920-1941\
        `"integration"`: 1942-1960\
        `"expansion"`: 1961-1976\
        `"freeAgency"`: 1977-1993\
        `"steroid"`: 1994-2005\
        `"modern"`: 2006-2023\
        If an argument is provided for `endEra`, this will return the first year in `startEra` and the last year of `endEra`. By default, this will return the years of only one era.
