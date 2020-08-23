pacman::p_load(tidyverse, rmarkdown, lubridate, epitools, gridExtra, knitr, kableExtra, ggsn, here, rgeos, ggthemes, grid, cowplot, ggpubr, wesanderson)

library(here)
library(dplyr)

# Cumulative death data by county in the U.S.
deaths <- read.csv(here("Box Sync/covid-19/Shielding/Data/covid_deaths_usafacts.csv"), check.names=FALSE)

deaths %>% gather(key = 'date', value = 'Value.name', "1/22/20":"7/6/20")  %>%
           rename("County.Name" = "County Name") %>%
           rename("deaths" = "Value.name") -> deaths


# Missouri

deaths %>%
  filter(State == "MO") -> missouri

# Utah

deaths %>%
  filter(State == "UT") -> utah


# Connecticut

deaths %>%
  filter(State == "CT") -> connect


# Metro NYC
# Counties: Manhattan, Bronx, Queens, Kings, Nassau

deaths %>%
  filter(State == "NY") %>%
  filter(County.Name == "Manhattan County" | 
         County.Name == "Bronx County" | 
         County.Name == "Queens County" | 
         County.Name == "Kings County" | 
         County.Name == "Nassua County") -> nyc


# Puget Sound WA
# Counties: King, Snohomish, Pierce, Kitsap and Grays Harbor

deaths %>%
  filter(State == "WA") %>%
  filter(County.Name == "King County" | 
           County.Name == "Snohomish County" | 
           County.Name == "Pierce County" | 
           County.Name == "Kitsap County" | 
           County.Name == "Grays Harbor County") -> washing


# South Florida
# Counties: Miami-Dade, Broward, Palm Beach, Martin


deaths %>%
  filter(State == "FL") %>%
  filter(County.Name == "Miami-Dade County" | 
           County.Name == "Broward County" | 
           County.Name == "Palm Beach County" | 
           County.Name == "Martin County") -> sflor


# select only weekly dates
wkdates <- as.character(seq(ymd('2020-01-22'),ymd('2020-07-06'), by = as.difftime(weeks(1))))
  
missouri %>% mutate(rdate = as.character(as.Date(date, "%m/%d/%y"),"%Y-%m-%d"))  %>% 
        filter(rdate %in% wkdates) %>%
        group_by(rdate) %>% 
        summarise(wkdeaths = sum(deaths)) -> missouri

utah %>% mutate(rdate = as.character(as.Date(date, "%m/%d/%y"),"%Y-%m-%d"))  %>% 
  filter(rdate %in% wkdates) %>%
  group_by(rdate) %>% 
  summarise(wkdeaths = sum(deaths)) -> utah

connect %>% mutate(rdate = as.character(as.Date(date, "%m/%d/%y"),"%Y-%m-%d"))  %>% 
  filter(rdate %in% wkdates) %>%
  group_by(rdate) %>% 
  summarise(wkdeaths = sum(deaths)) -> connect

sflor %>% mutate(rdate = as.character(as.Date(date, "%m/%d/%y"),"%Y-%m-%d"))  %>% 
  filter(rdate %in% wkdates) %>%
  group_by(rdate) %>% 
  summarise(wkdeaths = sum(deaths)) -> sflor

nyc %>% mutate(rdate = as.character(as.Date(date, "%m/%d/%y"),"%Y-%m-%d"))  %>% 
  filter(rdate %in% wkdates) %>%
  group_by(rdate) %>% 
  summarise(wkdeaths = sum(deaths)) -> nyc

washing %>% mutate(rdate = as.character(as.Date(date, "%m/%d/%y"),"%Y-%m-%d"))  %>% 
  filter(rdate %in% wkdates) %>%
  group_by(rdate) %>% 
  summarise(wkdeaths = sum(deaths)) -> washing






#plot
sflor.plot <- ggplot(data = sflor, aes(x = rdate, y = wkdeaths)) + 
      geom_bar(stat = "identity") +
      ylab("cases") +
      ggtitle("South Florida") +
      theme(legend.text =  element_text(size=8),
            axis.text.x=element_blank(),
            axis.text.y = element_text(size=8))
      

wash.plot <- ggplot(data = washing, aes(x = rdate, y = wkdeaths)) + 
  geom_bar(stat = "identity") +
  ylab("cases") +
  ggtitle("Washington (Puget Sound)") +
  theme(legend.text =  element_text(size=8),
        axis.text.x=element_blank(),
        axis.text.y = element_text(size=8))


nyc.plot <- ggplot(data = nyc, aes(x = rdate, y = wkdeaths)) + 
  geom_bar(stat = "identity") +
  ylab("cases") +
  ggtitle("NYC metro") +
  theme(legend.text =  element_text(size=8),
        axis.text.x=element_blank(),
        axis.text.y = element_text(size=8))

connect.plot <- ggplot(data = connect, aes(x = rdate, y = wkdeaths)) + 
  geom_bar(stat = "identity") +
  ylab("cases") +
  ggtitle("Connecticut") +
  theme(legend.text =  element_text(size=8),
        axis.text.x=element_blank(),
        axis.text.y = element_text(size=8))

utah.plot <- ggplot(data =  utah, aes(x = rdate, y = wkdeaths)) + 
  geom_bar(stat = "identity") +
  ylab("cases") +
  ggtitle("Utah") +
  theme(legend.text =  element_text(size=8),
        axis.text.x=element_blank(),
        axis.text.y = element_text(size=8))

miss.plot <- ggplot(data = missouri, aes(x = rdate, y = wkdeaths)) + 
  geom_bar(stat = "identity") +
  ylab("cases") +
  ggtitle("Missouri") +
  theme(legend.text =  element_text(size=8),
        axis.text.x = element_text(angle = 60, hjust = 1, size=8),
        axis.text.y = element_text(size=8))


all <- ggarrange(sflor.plot, wash.plot, nyc.plot, utah.plot, connect.plot, miss.plot, nrow = 6, ncol=1)
all

ggsave(all, file='allplots.pdf', width = 3, height = 10, units = "in",  dpi = 300)

write.csv(sflor, "sflor.csv")
write.csv(nyc, "nyc.csv")
write.csv(washing, "wash.csv")
write.csv(utah, "utah.csv")
write.csv(connect, "connect.csv")
write.csv(missouri, "missouri.csv")




###################################### 
# code not needed
######################################

# aggreagte by week
missouri %>% mutate(rdate = as.Date(as.numeric(date), origin = "1970-01-01")) %>% 
  group_by(week = cut(rdate, "week")) %>% 
  summarise(wkcases = sum(cases)) -> missouri

utah %>% mutate(rdate = as.Date(as.numeric(date), origin = "1970-01-01")) %>% 
  group_by(week = cut(rdate, "week")) %>% 
  summarise(wkcases = sum(cases)) -> utah

connect %>% mutate(rdate = as.Date(as.numeric(date), origin = "1970-01-01")) %>% 
  group_by(week = cut(rdate, "week")) %>% 
  summarise(wkcases = sum(cases)) -> connect

nyc %>% mutate(rdate = as.Date(as.numeric(date), origin = "1970-01-01")) %>% 
  group_by(week = cut(rdate, "week")) %>% 
  summarise(wkcases = sum(cases)) -> nyc

washing %>% mutate(rdate = as.Date(as.numeric(date), origin = "1970-01-01")) %>% 
  group_by(week = cut(rdate, "week")) %>% 
  summarise(wkcases = sum(cases)) -> washing

sflor %>% mutate(rdate = as.Date(as.numeric(date), origin = "1970-01-01")) %>% 
  group_by(week = cut(rdate, "week")) %>% 
  summarise(wkcases = sum(cases)) -> sflor

