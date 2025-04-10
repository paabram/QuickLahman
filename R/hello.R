library(Lahman)
library(dplyr)



getPID <- function(name) {
  first_last<- unlist(strsplit(name, split=" "))
  first <- first_last[1]
  last <- first_last[2]
  return(People[People$nameFirst == first & People$nameLast == last, 1])
}

getPID("Wilyer Abreu")

Batting %>% group_by(playerID) %>%
  summarize(
    teams = strsplit(paste(sort(unique(teamID)), collapse=" "), split=" ")
  )

Batting <- function(pid) {
  return(subset(Lahman::Batting, playerID == pid))
}
Batting(getPID("Dansby Swanson"))
Batting

Teams$name
min(Batting$yearID)
