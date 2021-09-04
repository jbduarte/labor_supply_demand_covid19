# Measuring Sectoral Supply and Demand Shocks during COVID-19

Matlab code for estimating labor supply and demand shocks during COVID-19. The code is a straightforward adaptation of Christiane Baumeister and James D. Hamilton (2015) code available at Christiane's personal [webpage](https://sites.google.com/site/cjsbaumeister/research).

**Reference**: Brinca, Duarte and Faria-e-Castro (2021) *Forthcoming European Economic Review*
"Measuring Sectoral Supply and Demand Shocks during COVID-19". [[Slides]](https://jbduarte.com/files/seacen_slides.pdf) &nbsp; [[Paper]](https://s3.amazonaws.com/real.stlouisfed.org/wp/2020/2020-011.pdf) 

## Contents

[Composition Effects](./Composition_Effects/): replication of robustness exercises to compositions effects 

[Data](./Data/): US monthly data on hours and real wages by NAICS2 and NAICS3 sectors of activity. For NAICS2, there is data on production only employees and all employees, while for NAICS3 all data is for production only employees. 

- There are also two spreadsheets with the sector names for NAICS2 and NAICS3, respectively.

[Matlab](./Matlab/): code

- [main.m](./Matlab/main.m): main file to run to compute the posterior distributions of the structural parameters, the IRF, and the historical decomposition
- [readData.m](./Matlab/readData.m): function that reads data and applies data transformations
- [model_estimation.m](./Matlab/model_estimation.m): function that estimates the posterior distribution of the SVAR using random walk Metropolis-Hastings
- [irf.m](./Matlab/irf.m): computes and saves IRF
- [histDecomp.m](./Matlab/histDecomp.m): computes and saves the historical decomposition of hours and wages
  
[Paper Figures](./Paper_Figures/): all paper figures in pdf

[Plots](./Plots/): plots of priors and posteriors of labor elasticities, and IRF

[R](./R/): code to replicate all figures in the paper

- [main.R](./R/main.R): main file to run to replicate all figures in the paper

[Shocks](./Shocks/): historical decomposition results for each NAICS2 and NAICS3 sector + Difference between HD of hours coming from supply and demand shocks for NAICS2 only. 
- No sufix in file name after hd: median estimate
- L sufix in file name after hd: 2.5 percentile estimate
- U sufix in file name after hd: 97.5 percentile estimate

To replicate historical decompositions of Brinca, Duarte and Faria-e-Castro (2021): 
- **NAICS2 for all employees**: run main with production=0 and subsectors=0
- **NAICS2 for production only employees**: run main with production=1 and subsectors=0
- **NAICS3 for production only employees**: run main with subsectors=1
