my_bar = function(month = 0){
sectors = c("Total Private", 
            "Mining and Logging",
            "Construction",
            "Manufacturing",
            "Wholesale Trade",
            "Retail Trade",
            "Transportation and Warehousing",
            "Utilities",
            "Information",
            "Financial Activities",
            "Professional and Business Services",
            "Education and Health Services",
            "Leisure and Hospitality",
            "Other Services")
#sector = as.character(sectors_data$sectors[1])
shocks = getshocks(sectors[1])
data_bar = data.frame(x = c(sectors[1], sectors[1]), 
                      value = c(shocks$demand[length(shocks$date)-month], shocks$supply[length(shocks$date)-month]),
                      Shock = c("Demand","Supply")
)
for(i in 2:length(sectors)){
  sector = sectors[i]
  shocks = getshocks(sector)
  data2 = data.frame(x = c(sector, sector), 
                     value = c(shocks$demand[length(shocks$date)-month], shocks$supply[length(shocks$date)-month]),
                     Shock = c("Demand","Supply")
  )
  data_bar = rbind(data_bar, data2)
}

data_bar$x <- factor(data_bar$x, levels = sectors)

if(month == 2){
breaks <- seq(-13, 2, 1)
labels <- as.character(breaks)
}

if(month == 1){
breaks <- seq(-62, 2, 5)
labels <- as.character(breaks)
}

if(month == 0){
  breaks <- seq(-10, 20, 2)
  labels <- as.character(breaks)
}

p = ggplot(data_bar, aes(fill = Shock, x = x, y = value)) +
  #ggtitle("Sectoral Hours Historical Decomposition for March 2020 ") +
  geom_bar(position="stack", stat="identity", width = 0.5) + 
  scale_fill_manual("Shock", 
                    values = c("Demand" = "blue", "Supply" = "red")
  ) +
  ylab("") + xlab("") +
  geom_hline(yintercept =  0, 
             linetype = "solid", 
             color = alpha("black", 0.8)
  ) +
  theme_publication(10)+ theme(axis.text.x=element_text(angle=60, hjust=1)) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4), 
                                          linetype = "dashed",
                                          size = 0.2
  ),
  panel.grid.major.x = element_line(alpha("black", 0.4), 
                                    linetype = "dashed",
                                    size = 0.2
  ),
  panel.grid.minor.y =  element_line(alpha("black", 0.3), 
                                     linetype = "dashed",
                                     size = 0.1
  )
  ) + scale_y_continuous(breaks = breaks, labels = labels ) +
  ylab("%")

return(p)
}