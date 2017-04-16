#you should read the clifro vignettes

library(clifro)
library(dplyr)

daily_rain_data <- cf_datatype(3,1,1)

region_names= c("Kaitaia", "Whangarei", "Auckland", "Tauranga", "Rotorua",
                "Taupo", "Hamilton", "New Plymouth", "Masterton", "Gisborne",
                "Napier", "Palmerston North", "Wellington", "Wanganui", "Westport",
                "Hokitika", "Milford Sound", "Nelson", "Blenheim", "Kaikoura", "Mt Cook",
                "Christchurch", "Lake Tekapo", "Timaru", "Dunedin", "Manapouri", "Queenstown",
                "Alexandra", "Invercargill")

get_stations <- function(x, dtkind){
  possible <- cf_find_station(x, search = "region", datatype = dtkind)
  pos_table <- as.data.frame(possible, stringsAsFactors=FALSE)
  pos_table$region <- x
  return(pos_table)
}

candidate_list <- lapply(region_names, get_stations, dtkind=daily_rain_data)
candidate_table <- bind_rows(candidate_list)