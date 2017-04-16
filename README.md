# clifro

Working code for accessing NIWA's cliff climate data

## get_all_open_stations.R

Code for getting details on all open stations for a given datatype, so you can select the stations you want

## get_data_from_cliflo.R

Excample code for downloading data from cliflo

## rain1in10yrs.csv

Example of dates and locations of 1 in 10 years rain events among 61 selected weather stations

## for_binom.csv

Summary data for weather stations of the kind that would go into a binomial test.

The csv files were made with:

```
library(clifro)
library(dplyr)
library(tidyr)
library(lubridate)
nztz <- "Pacific/Auckland"

# 3650 is the most extreme values in 365 days * 10 years ~ 1 in 10 yr rain
rd <- rain_data %>%
  separate(Date.local.,
           into=c("yr","mn","dy","sep","hr","mi"),
           sep =c(4,6,8,9,11)) %>%
  mutate(yr = as.numeric(yr),
         mn = as.numeric(mn),
         dy = as.numeric(dy),
         reading_date = ISOdate(yr, mn, dy, tz=nztz),
         whichtime = ifelse(yr < 1979, "early", "late")) %>%
  group_by(Station) %>%
  mutate(qtile = ntile(Amount.mm., 3650)) %>% ungroup() %>%
  filter(qtile == 3650) 

# get lat and lon from candidate list in get_all_open_stations_info.R
merge(rd, candidate_table, by.x="Station", by.y="name") %>% 
  select (Station,lat, lon, reading_date,Amount.mm.) %>% 
  write.csv(file="rain1in10yrs.csv", row.names=FALSE)
# note, I am suspicious about the person collecting the Russell data in the 1930s

###

for_bino <- rain_data %>%
  separate(Date.local.,
           into=c("yr","mn","dy","sep","hr","mi"),
           sep =c(4,6,8,9,11)) %>%
  mutate(yr = as.numeric(yr),
         mn = as.numeric(mn),
         dy = as.numeric(dy),
         reading_date = ISOdate(yr, mn, dy, tz=nztz),
         whichtime = ifelse(yr < 1979, "early", "late")) %>%
  group_by(Station) %>%
  mutate(qtile = ntile(Amount.mm., 3650)) %>%
  summarise(n_late = sum(whichtime == "late"), n_total= n(),
            n_exteme_late = sum(whichtime == "late" & qtile == 3650),
            n_exteme_total = sum(qtile == 3650)) 
write.csv(for_bino, file="for_binom.csv", row.names=FALSE)
##
bino_in <- colSums(for_bino[,2:5])
binom.test(bino_in[3],bino_in[4], p=bino_in[1]/bino_in[2])
```



