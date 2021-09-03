hd_ts_plot = function(sector, shocks){
data_h = read_csv(paste0("../Data/NAICS2/All/", sector, "_data.csv"), col_names = FALSE)
delta_h = diff(log(data_h$X3))[5:167]*100
shocks$h = delta_h
  p1 = ggplot(data = shocks, aes(x = date, y = demand)) + 
    geom_line(color = "blue") + geom_line(aes(x=date, y=h, lty = 'Observed hours'), color = "black", alpha = 0.5) +
    geom_ribbon(aes(ymin=demand_L, ymax=demand_U), alpha = 0.15,
                fill = "blue") +
    ggtitle("Hours if only demand shocks had happened vs. observed hours") +
    xlab("") + ylab("%") +
    scale_y_continuous(breaks=seq(-2.5,2.5,0.5)) + 
    geom_hline(yintercept =  0, 
               linetype = "solid", 
               color = alpha("black", 0.8)
    ) +
    scale_x_date(date_labels = "%Y", date_breaks = "1.5 years") +
    theme_publication(8) +
    theme(axis.text.x=element_text(angle=60, hjust=1), 
          legend.position = c(0.8, 0.2),
          legend.title=element_blank(),
          plot.title = element_text(size=8))
  p2 = ggplot(data = shocks, aes(x = date, y = supply)) + 
    geom_line(color = "red") +
    geom_line(aes(x=date, y=h, lty = 'Observed hours'), color = "black", alpha = 0.5) +
    geom_ribbon(aes(ymin=supply_L, ymax=supply_U), alpha = 0.15,
                fill = "red") +
    ggtitle("Hours if only supply shocks had happened vs. observed hours") +
    xlab("") + ylab("%") +
    scale_y_continuous(breaks=seq(-2.5,2.5,0.5)) + 
    geom_hline(yintercept =  0, 
               linetype = "solid", 
               color = alpha("black", 0.8)
    ) +
    scale_x_date(date_labels = "%Y", date_breaks = "1.5 years") +
    theme_publication(8) +
    theme(axis.text.x=element_text(angle=60, hjust=1), 
          legend.position = c(0.8, 0.2),
          legend.title=element_blank(),
          plot.title = element_text(size=8)) 
  g = grid.arrange(p1, p2, nrow = 2)
  return(g)
}