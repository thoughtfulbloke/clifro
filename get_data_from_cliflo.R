# Three constraints:
# Annual free subscription is 2000000 records
# Individual download limited to 40000 records
# you need your own username and password


library(clifro)
library(dplyr)

your_username_goes_here ="yourUsername"
your_password_goes_here = "yourPassword"
login_details <-  cf_user(your_username_goes_here, your_password_goes_here)


# assuming you have a vector of station IDs you want,
# in this case called station_IDs,
# maybe from analysing the all station data downloaded
# with get_all_open_stations.R
# we set up a list of stations to download to keep each
# individual download under 40000

wanted_stations <- lapply(unique(station_IDs), cf_station)

# customise start_date and end_date
retreived_data_list_of_lists <- lapply(wanted_stations,  function(x){cf_query(user = login_details,
                                                                datatype = daily_rain_data,
                                                                station = x,
                                                                start_date = "1935-12-30 00",
                                                                end_date = "2017-01-02 00")})

# columns in select statement would be different if you didn't just want daily rain
tablise <- function(x){
  station <- as.data.frame(x)
  station <- station %>% mutate_if(is.factor, as.character) %>%
    select(Station,Date.local.,Amount.mm.)
}

retreived_data_list_of_tables <- lapply(retreived_data_list_of_lists,tablise)
rain_data <- bind_rows(retreived_data_list_of_tables)

