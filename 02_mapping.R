map <- ggmap::get_map(location = c(lon = -87.6298, lat = 41.8781), zoom = 12, maptype="terrain-lines", source="stamen")
map2 <- ggmap::get_map(location = c(lon = -87.6298, lat = 41.8781), zoom = 11, maptype="terrain-lines", source="stamen")

g <- ggmap(map2, extennt = "device") +
  geom_point(data = uber_clean, aes(x = lon_or, y = lat_or, colour = "blue")) +
  geom_point(data = uber_clean, aes(x = lon_des, y = lat_des, colour = "red")) +
  theme_minimal() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        legend.position = "none")

g

h <- ggmap(map2, extennt = "device") +
  geom_segment(data = routes_df, aes(x = start_lon,
                                     y = start_lat,
                                     xend = end_lon,
                                     yend = end_lat),
               colour = "blue") +
  theme_minimal() +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        legend.position = "none")

h