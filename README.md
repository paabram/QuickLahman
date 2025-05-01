# QuickLahman

This package adds functions to the [Sean Lahman Baseball Database Package,](https://cran.r-project.org/web/packages/Lahman/Lahman.pdf) primarily focused on preparing the most frequently used tables into an analysis-ready state with a single line, but also adding helpful functions for lookups and stat calculation; it is by no means comprehensive, but should help speed up common scenarios. The available functions are:

1.  **QuickStats(data,\
              [players = unique(data\$playerID)\
              years = c(1871, 2023)\
              teams = unique(data\$teamID),\
              lg = unique(data\$lgID),\
              pos = c("P", "LF", "CF", "RF", "2B", "3B", "1B", "SS", "C"),\
              idvars = colnames(data)])**\
        Returns the table given in *data* (likely one of `Batting`, `Fielding`, or `Pitching`; must include appropriate column names) as filtered by the passed-in arguments, all of which are optional. Designed to quickly prepare tables for analysis, providing filtration, selection, and certain joins with just a single line. It offers much greater convenience than the somewhat cumbersome data prep necessary with the base package, allowing analyses to be carried out in an R script just a few lines long.\
        *players*, *teams*, *lg,* and *pos* may be either a single string or a vector of names/teams/leagues/positions; data will be filtered to only include matching. These values should correspond to entries in the database or an error will be thrown.\
        *years* may be either a single value (in which case records are limited to only that year) or a vector of two years, returning records that fall within that range (inclusive).\
        *idvars* is the list of columns to include in the end result (see the same parameter in battingStats in the original package).

2.  **CareerStats(data,\
              [list = TRUE,\
              agg = sum()])**\
        Groups the table passed in through `data` (result of QuickStats, for an example) by `playerID`, giving their stats for all of their career within the year range of `data`. Useful as a wrapper to the table functions above for quickly gathering a whole career's worth of stats into one entry. Rather than `yearID`, the resulting table will have columns `debut`, `retirement`, and `yearsActive`, containing that player's first year of play, his last year, and the length of his career.\
        *agg* indicates what aggregate function to apply to numeric columns; by default it is `sum()`.

3.  **getPlayerID(name)** Given a player's full `name`, return their playerID code from the `People` table. Useful for accessing stats when you have a player already in mind, allowing access to his stats by name without having to join the `People` table.

4.  **getPlayerName(playerID)** The inverse of above: given a `playerID`, return that player's full name. Allows easy readibility when results give playerIDs, eliminating the need to join or manually lookup on the `People` table.

5.  **getTeamName(teamID)** As above but for teams. Provides quick conversion of team codes to names, especially convenient for older data about teams that no longer play (and hence have unfamiliar abbreviations), avoiding lookups or joins on `Teams`.

6.  **getTeamID(name)** The inverse of `getTeamName`, providing the abbreviation code for a given team name. Note that the format is `"City Teamname"`.

7.  **playerPos(playerID,\
             [list = FALSE,\
             years = c(1871, 2023))**\
        Given a player's `playerID`, return the positions he played. Eliminates the need to join `Fielding` when considering data by position.\
        *list* determines whether to include all positions the player played in the given years as a tibble, including the number of games at each position. If `FALSE`, the function will return the most frequently played position.\
        *years* is what years to include for the given player, either a single value (limiting to only positions played that year) or a vector of two (start, end), including records that fall within that range (inclusive).

8.  **playerTeam(playerID)**

        Given a player's `playerID`, return the teams he played for. Removes the need to scan over or aggregate data to determine a player's team's in a dataset.

        *list* determines whether to include all teams the player played in the given years as a tibble, including the `firstYear`, `lastYear`, and number of `seasons` with that team. If `FALSE`, the function will return the team he spent the most time at.

        *years* is what years to include for the given player, either a single value (limiting to only positions played that year) or a vector of two (start, end), including records that fall within that range (inclusive).

9.  **eraToYears(startEra,\
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
