# modeling lyft price

library(data.table)

uber_clean <- data.table::fread("uber_clean.csv")[1:80,]
routes_df <- data.table::fread("routes_df.csv")

distance <- aggregate(miles ~ .id, routes_df, FUN = sum)
