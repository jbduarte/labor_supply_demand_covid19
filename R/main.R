## Main script for replication of BDF2021 figures
## (except irfs, priors and posteriors, those are created in Matlab)
## Author: Joao B. Duarte
## Last update: 1/09/2021

rm(list = ls()) # Clear all

## User input ##
# Set here the working directory of where you have saved the replication folder
setwd("./R")

## Loading libraries and functions ##
library(readxl)
library(scales)
library(ggplot2)
library(gridExtra)
source("theme_publication.R")
source("getshocks.R")
source("hd_ts_plot.R")
source("my_bar.R")
source("my_bar_production.R")
source("getshocks_production.R")
source("getshocks_naics3.R")

## Figures Replication ##
# Figure 2 a): Total Private supply and demand shocks time series excluding COVID-19 months
dic <- read_excel("../Data/labels_naics2.xlsx")
sectors_data <- data.frame(sectors = dic$sector_name,
                          codes = dic$bls_code,
                          urls = dic$url)
sector <- sectors_data$sectors[14]
shocks <- getshocks(sector, subsectors=0)
g <- hd_ts_plot(sector, shocks[1:163, ])
ggsave(paste("../Paper Figures/figure2a.pdf", sep = ""),
         g, units = "mm",
         width = 160,
         height = 90)

# Figure 2 b): Leisure and Hospitality supply and demand shocks time series excluding COVID-19 months
sector <- sectors_data$sectors[12]
shocks <- getshocks(sector, subsectors=0)
g <- hd_ts_plot(sector, shocks[1:163, ])
ggsave(paste("../Paper Figures/figure2b.pdf", sep = ""),
         g, units = "mm",
         width = 160,
         height = 90)

# Figure 3: Historical decomposition of the growth rate of hours by NAICS 2-digit sectors in March 2020
p = my_bar(2)
ggsave(paste("../Paper Figures/figure3.pdf", sep = ""),
       p,
       units = "mm",
       width = 160,
       height = 120,
       dpi = 600)

# Figure 4: Historical decomposition of the growth rate of hours by NAICS 2-digit sectors in April 2020
p = my_bar(1)
ggsave(paste("../Paper Figures/figure4.pdf", sep = ""),
       p,
       units = "mm",
       width = 160,
       height = 120,
       dpi = 600)


# Figure 5: Historical decomposition of the growth rate of hours by NAICS 3-digit sectors in March 2020
sectors <- read_excel("../Data/labels_naics3.xls", col_names = FALSE)
sectors <- sectors$...1
shocks <- getshocks_naics3(sectors[1])
data_bar = data.frame(x = c(sectors[1], sectors[1]),
                      value = c(shocks$demand[length(shocks$date)-1], shocks$supply[length(shocks$date)-1]),
                      Shock = c("Demand","Supply")
)
for(i in 2:70){
  sector = sectors[i]
  shocks = getshocks_naics3(sector)
  data2 = data.frame(x = c(sector, sector),
                     value = c(shocks$demand[length(shocks$date)-1], shocks$supply[length(shocks$date)-1]),
                     Shock = c("Demand","Supply")
  )
  data_bar = rbind(data_bar, data2)
}
breaks <- seq(-15, 4, 1)
labels <- as.character(breaks)
p = ggplot(data_bar, aes(fill = Shock, x = x, y = value)) +
  #ggtitle("Sectoral Hours Historical Decomposition for March 2020 ") +
  geom_bar(position="stack", stat="identity", width = 0.5) +
  scale_fill_manual("Shock:",
                    values = c("Demand" = "blue", "Supply" = "red")
  ) +
  ylab("") + xlab("") +
  geom_hline(yintercept =  0,
             linetype = "solid",
             color = alpha("black", 0.8)
  ) +
  theme_publication(10)+ theme(axis.text.x=element_text(angle=75, hjust=1)) +
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
  ),
  legend.position="top") + scale_y_continuous(breaks = breaks, labels = labels )
p
ggsave(paste("../Paper Figures/figure5.pdf", sep = ""),
       p,
       units = "mm",
       width = 340,
       height = 200,
       dpi = 600)

# Figure 6: Historical decomposition of the growth rate of hours by NAICS 3-digit sectors in April 2020
sectors <- read_excel("../Data/labels_naics3.xls", col_names = FALSE)
sectors <- sectors$...1
shocks <- getshocks_naics3(sectors[1])
data_bar = data.frame(x = c(sectors[1], sectors[1]),
                      value = c(shocks$demand[length(shocks$date)], shocks$supply[length(shocks$date)]),
                      Shock = c("Demand","Supply")
)
for(i in 2:70){
  sector = sectors[i]
  shocks = getshocks_naics3(sector)
  data2 = data.frame(x = c(sector, sector),
                     value = c(shocks$demand[length(shocks$date)], shocks$supply[length(shocks$date)]),
                     Shock = c("Demand","Supply")
  )
  data_bar = rbind(data_bar, data2)
}
breaks <- seq(-95, 5, 5)
labels <- as.character(breaks)
p = ggplot(data_bar, aes(fill = Shock, x = x, y = value)) +
  #ggtitle("Sectoral Hours Historical Decomposition for March 2020 ") +
  geom_bar(position="stack", stat="identity", width = 0.5) +
  scale_fill_manual("Shock:",
                    values = c("Demand" = "blue", "Supply" = "red")
  ) +
  ylab("") + xlab("") +
  geom_hline(yintercept =  0,
             linetype = "solid",
             color = alpha("black", 0.8)
  ) +
  theme_publication(10)+ theme(axis.text.x=element_text(angle=75, hjust=1)) +
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
  ),
  legend.position="top") + scale_y_continuous(breaks = breaks, labels = labels )
p
ggsave(paste("../Paper Figures/figure6.pdf", sep = ""),
       p,
       units = "mm",
       width = 340,
       height = 200,
       dpi = 600)

# Figure 7: Historical decomposition of the growth rate of hours by NAICS 2-digit sectors in May 2020
p = my_bar(0)
ggsave(paste("../Paper Figures/figure7.pdf", sep = ""),
       p,
       units = "mm",
       width = 160,
       height = 120,
       dpi = 600)


# Figure 9: Supply and demand shocks across closed and open sectors during lockdown.
data <- read_excel("../Data/data_open_close_classification.xlsx")
data$open[data$open == 1] <- "Open"
data$open[data$open == 0] <- "Closed"
data$label <- NA
data$label[data$naics3 == "Transportation equipment"] <- 1
data$label[data$naics3 == "Apparel"] <- 1
data$label[data$naics3 == "Amusements, gambling, and recreation"] <- 1
data$label[data$naics3 == "Accommodation"] <- 1
data$label[data$naics3 == "Food services and drinking places"] <- 1
data$label[data$naics3 == "Clothing and clothing accessories stores"] <- 1
data$label[data$naics3 == "Motion picture and sound recording industries"] <- 1
data$label[data$naics3 == "Personal and laundry services"] <- 1
data$label[data$naics3 == "Furniture and home furnishings stores"] <- 1
data$label[data$naics3 == "Sporting goods, hobby, book, and music stores"] <- 1
data$label[data$naics3 == "Nonstore retailers"] <- 1
data$label[data$naics3 == "Food and beverage stores"] <- 1
data$label[data$naics3 == "Couriers and messengers"] <- 1
data$label[data$naics3 == "Building material and garden supply stores"] <- 1
data$label[data$naics3 == "General merchandise stores"] <- 1
p <- ggplot(data, aes(x=supply, y=demand) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 0.8, aes(colour = factor(open))) +
  xlab("Supply shocks") +
  ylab("Demand shocks") +
  ylim(-80,12)+
  xlim(-80,12)+
  theme_publication(9) +
  geom_hline(yintercept =  0,
               linetype = "solid", size=0.25,
               color = alpha("black", 0.8)
    )+
  geom_vline(xintercept =  0,
               linetype = "solid", size=0.25,
               color = alpha("black", 0.8)
    ) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4),
                                            linetype = "dashed",
                                            size = 0.2
    ),
    panel.grid.major.x = element_line(alpha("black", 0.4),
                                      linetype = "dashed",
                                      size = 0.2
    )) +
  labs(colour = "Sectors") +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed")+
  annotate(geom="text", x=-50, y=-60, label="45 degree line",
              color="black", size=2)+
  geom_text(data=subset(data, label == 1),
            aes(supply,demand,label=naics3),hjust=-0.02, vjust=-0.2, size = 1.4) +
  theme(legend.text=element_text(size=7), legend.title=element_text(size=7))
p
ggsave(paste("../Paper Figures/figure9.pdf", sep = ""),
         p, units = "mm",
         width = 120,
         height = 120)


# Figure 10 a): Supply and demand shocks across closed and open sectors during lockdown - March.
data <- read_excel("../Data/trade_demand_shocks.xlsx")
reg_supply <- lm(Demand~Trade, data = data[data$Month==3,])
fit = summary(reg_supply)
# Trade Scatter
p <- ggplot(data[data$Month==3,], aes(x=Trade, y=Demand) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Fraction of foreign intermediate inputs") +
  ylab("Demand shocks") +
  theme_publication(10) +
  geom_hline(yintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  )+
  geom_vline(xintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  ) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4),
                                          linetype = "dashed",
                                          size = 0.2
  ),
  panel.grid.major.x = element_line(alpha("black", 0.4),
                                    linetype = "dashed",
                                    size = 0.2
  )) +
  labs(colour = "Sectors") +
  geom_text(aes(label=Label,hjust=-0.02, vjust=-0.2))+
  xlim(0,0.4)+
  geom_smooth(method=lm, se=TRUE) +
  annotate("text",
           x = c(0.1), y = c(-3),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )
p
ggsave(paste("../Paper Figures/figure10a.pdf", sep = ""),
       p, units = "mm",
       width = 120,
       height = 120)

# Figure 10 b): Supply and demand shocks across closed and open sectors during lockdown - April.
reg_supply <- lm(Demand~Trade, data = data[data$Month==4,])
fit = summary(reg_supply)
# Trade Scatter
p <- ggplot(data[data$Month==4,], aes(x=Trade, y=Demand) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Fraction of foreign intermediate inputs") +
  ylab("Demand shocks") +
  theme_publication(10) +
  geom_hline(yintercept =  0,
               linetype = "solid", size=0.25,
               color = alpha("black", 0.8)
    )+
  geom_vline(xintercept =  0,
               linetype = "solid", size=0.25,
               color = alpha("black", 0.8)
    ) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4),
                                            linetype = "dashed",
                                            size = 0.2
    ),
    panel.grid.major.x = element_line(alpha("black", 0.4),
                                      linetype = "dashed",
                                      size = 0.2
    )) +
  labs(colour = "Sectors") +
  geom_text(aes(label=Label,hjust=-0.02, vjust=-0.2))+
  xlim(0,0.4)+
  geom_smooth(method=lm, se=TRUE) +
  annotate("text",
           x = c(0.1), y = c(-15),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )
p
ggsave(paste("../Paper Figures/figure10b.pdf", sep = ""),
         p, units = "mm",
         width = 120,
         height = 120)


# Figure 11 a): Correlation between sectoral shocks and share of UI claims - Supply/March.
data <- read_excel("../Data/UIclaims_supply_shocks.xlsx")
reg_supply <- lm(Supply~UI_claims, data = data[data$Month==3, ])
fit = summary(reg_supply)
p <- ggplot(data[data$Month==3, ], aes(x=UI_claims, y=Supply) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Sectoral share in UI claims") +
  ylab("Supply shocks") +
  theme_publication(10) +
  geom_hline(yintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  )+
  geom_vline(xintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  ) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4),
                                          linetype = "dashed",
                                          size = 0.2
  ),
  panel.grid.major.x = element_line(alpha("black", 0.4),
                                    linetype = "dashed",
                                    size = 0.2
  )) +
  labs(colour = "Sectors") +
  geom_text(aes(label=Label,hjust=-0.02, vjust=-0.2))+
  xlim(0,0.24)+
  geom_smooth(method=lm, se=TRUE) +
  annotate("text",
           x = c(0.05), y = c(-4),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )
p
ggsave(paste("../Paper Figures/figure11a.pdf", sep = ""),
       p, units = "mm",
       width = 120,
       height = 120)


# Figure 11 c): Correlation between sectoral shocks and share of UI claims - Supply/April.
reg_supply <- lm(Supply~UI_claims, data = data[data$Month==4, ])
fit = summary(reg_supply)
# UI CLAIMS
p <- ggplot(data[data$Month==4, ], aes(x=UI_claims, y=Supply) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Sectoral share in UI claims") +
  ylab("Supply shocks") +
  theme_publication(10) +
  geom_hline(yintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  )+
  geom_vline(xintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  ) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4),
                                          linetype = "dashed",
                                          size = 0.2
  ),
  panel.grid.major.x = element_line(alpha("black", 0.4),
                                    linetype = "dashed",
                                    size = 0.2
  )) +
  labs(colour = "Sectors") +
  geom_text(aes(label=Label,hjust=-0.02, vjust=-0.2))+
  xlim(0,0.17)+
  geom_smooth(method=lm, se=TRUE) +
  annotate("text",
           x = c(0.05), y = c(-25),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )
p
ggsave(paste("../Paper Figures/figure11c.pdf", sep = ""),
       p, units = "mm",
       width = 120,
       height = 120)


# Figure 11 b): Correlation between sectoral shocks and share of UI claims - Demand/March.
reg_supply <- lm(Demand~UI_claims, data = data[data$Month==3, ])
fit = summary(reg_supply)
p <- ggplot(data[data$Month==3, ], aes(x=UI_claims, y=Demand) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Sectoral share in UI claims") +
  ylab("Demand shocks") +
  theme_publication(10) +
  geom_hline(yintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  )+
  geom_vline(xintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  ) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4),
                                          linetype = "dashed",
                                          size = 0.2
  ),
  panel.grid.major.x = element_line(alpha("black", 0.4),
                                    linetype = "dashed",
                                    size = 0.2
  )) +
  labs(colour = "Sectors") +
  geom_text(aes(label=Label,hjust=-0.02, vjust=-0.2))+
  xlim(0,0.24)+
  geom_smooth(method=lm, se=TRUE) +
  annotate("text",
           x = c(0.05), y = c(-4),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )
p
ggsave(paste("../Paper Figures/figure11b.pdf", sep = ""),
       p, units = "mm",
       width = 120,
       height = 120)


# Figure 11 d): Correlation between sectoral shocks and share of UI claims - Demand/April.
reg_supply <- lm(Demand~UI_claims, data = data[data$Month==4, ])
fit = summary(reg_supply)
p <- ggplot(data[data$Month==4, ], aes(x=UI_claims, y=Demand) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Sectoral share in UI claims") +
  ylab("Demand shocks") +
  theme_publication(10) +
  geom_hline(yintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  )+
  geom_vline(xintercept =  0,
             linetype = "solid", size=0.25,
             color = alpha("black", 0.8)
  ) +
  theme(panel.grid.major.y = element_line(alpha("black", 0.4),
                                          linetype = "dashed",
                                          size = 0.2
  ),
  panel.grid.major.x = element_line(alpha("black", 0.4),
                                    linetype = "dashed",
                                    size = 0.2
  )) +
  labs(colour = "Sectors") +
  geom_text(aes(label=Label,hjust=-0.02, vjust=-0.2))+
  xlim(0,0.17)+
  geom_smooth(method=lm, se=TRUE) +
  annotate("text",
           x = c(0.05), y = c(-14),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )
p
ggsave(paste("../Paper Figures/figure11d.pdf", sep = ""),
       p, units = "mm",
       width = 120,
       height = 120)

# Figure 12: Historical decomposition of the growth rate of hours across sectors using production and nonsupervisory employees only, March 2020
p = my_bar_production(1)
ggsave(paste("../Paper Figures/figure12.pdf", sep = ""),
       p,
       units = "mm",
       width = 160,
       height = 120,
       dpi = 600)

# Figure 13: Historical decomposition of the growth rate of hours across sectors using production and nonsupervisory employees only, April 2020
p = my_bar_production(0)
ggsave(paste("../Paper Figures/figure13.pdf", sep = ""),
       p,
       units = "mm",
       width = 160,
       height = 120,
       dpi = 600)


# Figure 15 a): Correlation between sectoral shocks in April 2020 and the sectoral share of jobs that can be done at home
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

shocks = getshocks(sectors[1])
data_bar = data.frame(x = c(sectors[1], sectors[1]),
                      value = c(shocks$demand[length(shocks$date)-1], shocks$supply[length(shocks$date)-1]),
                      Shock = c("Demand","Supply")
)
for(i in 2:length(sectors)){
  sector = sectors[i]
  shocks = getshocks(sector)
  data2 = data.frame(x = c(sector, sector),
                     value = c(shocks$demand[length(shocks$date)-1], shocks$supply[length(shocks$date)-1]),
                     Shock = c("Demand","Supply")
  )
  data_bar = rbind(data_bar, data2)
}
# Get shares
financial_ser_total = 8853
finance_insurance = 6497.5
real_estate_rental_leasing = 2355.2
fi_share = finance_insurance/financial_ser_total
bss_total = 21507
ptec = 9712.1
man = 2455.6
ptec_share = ptec/bss_total
man_share = man/bss_total
edu_hlt_total = 24523
edu = 3822.6
edu_share = edu/edu_hlt_total
lei_acc_total = 16393
lei = 2462.3
lei_share = lei/lei_acc_total
data_scat = data_bar[data_bar$Shock == "Supply", ]
data_scat = data_scat[-1,] # drop total private
data_scat$tele[1] = 0.25448045 # mining
data_scat$tele[2] = 0.18559921 # construction
data_scat$tele[3] = 0.22480325 # manufacturing
data_scat$tele[4] = 0.51755255 # wholesale trade
data_scat$tele[5] = 0.14343524 # retail trade
data_scat$tele[6] = 0.18614481 # transportation and warehousing
data_scat$tele[7] = 0.37001538 # utilities
data_scat$tele[8] = 0.71706247 # information
data_scat$tele[9] = 0.76203007*fi_share + 0.41810879*(1-fi_share) # financial activities
data_scat$tele[10] = 0.80275732*ptec_share + 0.79189116*man_share + 0.3106325*(1-ptec_share - man_share) # professional and business services
data_scat$tele[11] =  0.82646495*edu_share + 0.25252154*(1-edu_share) # education and health services
data_scat$tele[12] =  0.29749355*lei_share + 0.035365932*(1-lei_share) # leisure and accomodation
data_scat$tele[13] = 0.31235081 # other services
data_scat$label = c("ML", "C", "M", "WT", "RT", "TW", "U", "I", "FA", "PBS", "EHS", "LH", "OS")
reg_supply = lm(value~tele, data = data_scat)
fit = summary(reg_supply)
p = ggplot(data_scat, aes(x=tele, y=value) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Share of jobs that can be done from home ") +
  ylab("Supply Shocks") +
  geom_smooth(method=lm, se=TRUE) +
  theme_publication(10) +
  geom_text(aes(label=label),hjust=-0.2, vjust=-0.2, size = 3.2) +
  annotate("text",
           x = c(0.5), y = c(-30),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  ) + coord_cartesian(ylim=c(-42,6), xlim=c(0.05,0.7))
p
ggsave(paste("../Paper Figures/figure15a.pdf", sep = ""),
       p,
       units = "mm",
       width = 130,
       height = 90,
       dpi = 300)


# Figure 15 c): Correlation between sectoral shocks in April 2020 and the sectoral share of jobs that can be done at home
data_scat2 = data_scat[-12,]
reg2 = lm(value~tele, data = data_scat2)
fit = summary(reg2)
p = ggplot(data_scat2, aes(x=tele, y=value) ) +
  #ggtitle("Supply shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Share of jobs that can be done from home ") +
  ylab("Supply Shocks") +
  geom_smooth(method=lm, se=TRUE) +
  theme_publication(10) +
  geom_text(aes(label=label),hjust=-0.2, vjust=-0.2, size = 3.2) +
  annotate("text",
           x = c(0.5), y = c(-30),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )  + ylim(-42,6)
p
ggsave(paste("../Paper Figures/figure15c.pdf", sep = ""),
       p,
       units = "mm",
       width = 130,
       height = 90,
       dpi = 300)


# Figure 15 b): Correlation between sectoral shocks in April 2020 and the sectoral share of jobs that can be done at home
data_scat = data_bar[data_bar$Shock == "Demand", ]
data_scat = data_scat[-1,] # drop total private
data_scat$tele[1] = 0.25448045 # mining
data_scat$tele[2] = 0.18559921 # construction
data_scat$tele[3] = 0.22480325 # manufacturing
data_scat$tele[4] = 0.51755255 # wholesale trade
data_scat$tele[5] = 0.14343524 # retail trade
data_scat$tele[6] = 0.18614481 # transportation and warehousing
data_scat$tele[7] = 0.37001538 # utilities
data_scat$tele[8] = 0.71706247 # information
data_scat$tele[9] = 0.76203007*fi_share + 0.41810879*(1-fi_share) # financial activities
data_scat$tele[10] = 0.80275732*ptec_share + 0.79189116*man_share + 0.3106325*(1-ptec_share - man_share) # professional and business services
data_scat$tele[11] =  0.82646495*edu_share + 0.25252154*(1-edu_share) # education and health services
data_scat$tele[12] =  0.29749355*lei_share + 0.035365932*(1-lei_share) # leisure and accomodation
data_scat$tele[13] = 0.31235081 # other services
data_scat$label = c("ML", "C", "M", "WT", "RT", "TW", "U", "I", "FA", "PBS", "EHS", "LH", "OS")
reg_demand = lm(value~tele, data = data_scat)
fit = summary(reg_demand)
p = ggplot(data_scat, aes(x=tele, y=value) ) +
  #ggtitle("Demand shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Share of jobs that can be done from home ") +
  ylab("Demand Shocks") +
  geom_smooth(method=lm, se=TRUE) +
  theme_publication(10) +
  geom_text(aes(label=label),hjust=-0.2, vjust=-0.2, size = 3.2) +
  annotate("text",
           x = c(0.4), y = c(-30),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )  + coord_cartesian(ylim=c(-42,6), xlim=c(0.05,0.7))
p
ggsave(paste("../Paper Figures/figure15b.pdf", sep = ""),
       p,
       units = "mm",
       width = 130,
       height = 90,
       dpi = 300)

# Figure 15 d): Correlation between sectoral shocks in April 2020 and the sectoral share of jobs that can be done at home
data_scat2 = data_scat[-12,]
reg2 = lm(value~tele, data = data_scat2)
fit = summary(reg2)
p = ggplot(data_scat2, aes(x=tele, y=value) ) +
  #ggtitle("Demand shocks vs. share of jobs that can be done from home ") +
  geom_point(size = 1.3) +
  xlab("Share of jobs that can be done from home ") +
  ylab("Demand Shocks") +
  geom_smooth(method=lm, se=TRUE) +
  theme_publication(10) +
  geom_text(aes(label=label),hjust=-0.2, vjust=-0.2, size = 3.2) +
  annotate("text",
           x = c(0.5), y = c(-30),
           label = paste("y = ", signif(fit$coefficients[1,1], 2),
                         " + ", signif(fit$coefficients[2,1], 2), "x",
                         "\nR2 = ",signif(fit$r.squared, 2),
                         "\nr = ",  signif(sqrt(fit$r.squared), 2),  ", p-value = ", signif(fit$coefficients[2,4], 2),
                         sep = ""), hjust = 0,
           color="black",
           fontface="bold",
           size = 2.5
  )  + ylim(-42,6)
p
ggsave(paste("../Paper Figures/figure15d.pdf", sep = ""),
       p,
       units = "mm",
       width = 130,
       height = 90,
       dpi = 300)