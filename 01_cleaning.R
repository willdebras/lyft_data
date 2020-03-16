###cleaning uber data and geocoding addresses for analysis
library(data.table)
library(ggmap)
library(dplyr)
library(stringr)

#list files to programmatically read by by pattern
file_list <- list.files(pattern = ".csv")

#read all files into a list
csv_list <- lapply(file_list, data.table::fread)

#bind all elements of list
uber_master <- do.call(rbind, csv_list)

uber_geo <- uber_master %>%
  dplyr::mutate(origin = ifelse(stringr::str_detect(origin, "Chicago"), paste0(origin, ", IL"), origin)) %>%
  ggmap::mutate_geocode(origin)

uber_dest <- uber_geo %>%
  dplyr::mutate(destination = ifelse(stringr::str_detect(destination, "Chicago"), paste0(destination, ", IL"), destination)) %>%
  ggmap::mutate_geocode(destination)

uber_clean <- uber_dest %>%
  `colnames<-`(c("date", "origin", "destination", "cost", "currency", "lon_or", "lat_or", "lon_des", "lat_des")) %>%
 dplyr::mutate(date = lubridate::mdy_hm(date)) %>%
  dplyr::mutate(cost = as.numeric(gsub('[$,]', '', .$cost)))


fwrite(uber_clean, file = "uber_clean.csv")

uber_route <- ggmap::route(uber_clean$origin[[1]], uber_clean$destination[[1]])

routes <- mapply(ggmap::route, uber_clean$origin, uber_clean$destination)

routes_df <- data.table::rbindlist(routes, fill = TRUE, idcol = TRUE)[1:582,]

fwrite(routes_df, file = "routes_df.csv")


