## Create a data frame with the historical decomposition of hours
## Author: Joao B. Duarte
## Last update: 13/5/2020

getshocks_production = function(sector, subsectors = 0){
  s = read.table(paste("../Shocks/NAICS2/", sector ,"_hd_supply_production.txt", sep = ""),
                 sep=",", 
                 col.names=c("supply"), 
                 fill=FALSE, 
                 strip.white=TRUE)
  s_L = read.table(paste("../Shocks/NAICS2/", sector ,"_hdL_supply_production.txt", sep = ""),
                   sep=",", 
                   col.names=c("supply_L"), 
                   fill=FALSE, 
                   strip.white=TRUE)
  s_U = read.table(paste("../Shocks/NAICS2/", sector ,"_hdU_supply_production.txt", sep = ""),
                   sep=",", 
                   col.names=c("supply_U"), 
                   fill=FALSE, 
                   strip.white=TRUE)
  d = read.table(paste("../Shocks/NAICS2/", sector ,"_hd_demand_production.txt", sep = ""),
                 sep=",", 
                 col.names=c("demand"), 
                 fill=FALSE, 
                 strip.white=TRUE)
  d_L = read.table(paste("../Shocks/NAICS2/", sector ,"_hdL_demand_production.txt", sep = ""),
                   sep=",", 
                   col.names=c("demand_L"), 
                   fill=FALSE, 
                   strip.white=TRUE)
  d_U = read.table(paste("../Shocks/NAICS2/", sector ,"_hdU_demand_production.txt", sep = ""),
                   sep=",", 
                   col.names=c("demand_U"), 
                   fill=FALSE, 
                   strip.white=TRUE)
  if(subsectors == 0){
    shocks = data.frame(date = seq(from = as.Date("1984/1/1"), to = as.Date("2020/4/1"), by = "month"),
                        d,d_L, d_U,  s, s_L, s_U)
  }
  if(subsectors == 1){
    shocks = data.frame(date = seq(from = as.Date("1984/1/1"), to = as.Date("2020/3/1"), by = "month"),
                        d,d_L, d_U,  s, s_L, s_U)
  }
  return(shocks)
  
}