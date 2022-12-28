# install and load packages
# install.packages('tidyverse')
# install.packages('jsonlite')
library(tidyverse)
library(jsonlite)

# Set working directory
setwd('/Users/catherinesmith/Desktop/unc_bootcamp/module_16/UNCBC-HW16-AutosRUs/01_Demo')

# how to write functions 
# function_name <- function(arg1, arg2=T, …){
# 
# <BODY OF FUNCTION>
#   
#   return <RETURN VALUE>
#   }

# load in data from csv
demo_table <- read.csv(file='demo.csv',check.names=F,stringsAsFactors = F)


# load in data from json
demo_table2 <- fromJSON(txt='demo.json')
filter_table <- demo_table2[demo_table2$price > 10000,]


#filter by price and drivetrain
filter_table2 <- subset(demo_table2, price > 10000 & drive == "4wd" & "clean" %in% title_status) 

# sampling rows of dataframe
demo_table[sample(1:nrow(demo_table), 3),]

demo_table <- demo_table %>% mutate(MileagePerYear = Total_Miles/(2020-Year),
                                    IsActive=TRUE)
# create summary table
# added argument to ignore NA values when computing mean milage
summarize_demo <- demo_table2 %>% group_by(condition) %>%
  summarize(Mean_Mileage=mean(odometer, na.rm = TRUE), .groups = 'keep')

# read in new data from csv
demo_table3 <- read.csv('demo2.csv',check.names = F,stringsAsFactors = F)

# use gather to reshape data from wide format into long format
long_table <- gather(demo_table3,key="Metric",value="Score",buying_price:safety_rating)

# use spread to reshape long table from long format to wide format
wide_table <- long_table %>% spread(key="Metric",value="Score")

# test to see if original table and wide_table are the same
all.equal(demo_table3, wide_table)

# If you ever compare two data frames that you expect to be equal,
# and the all.equal() function tells you they're not, try sorting
# the columns of both data frames using the order() and colnames()
# functions and bracket notation

################## PLOTTING WITH GGPLOT2 ##################

# get a sense of mpg dataset
head(mpg)

### MAKE FIRST BARPLOT ###

# read data into ggplot
plt <- ggplot(mpg, aes(x=class))

### plot the bar plot
## geom_bar makes bar height proportional to the number of cases in each group(stat_count).
plt + geom_bar()

### MAKE SECOND BARPLOT ###

# prepare summarized data: manufacturer data summarized by count
mpg_summary <- mpg %>% group_by(manufacturer) %>%
  summarize(VehicleCount = n(), .groups='keep')

# read the data into ggplot
plt <- ggplot(mpg_summary, aes(x=manufacturer, y=VehicleCount))

# plot the bar plot
# geom_col makes bar height representative of data values (stat_identity).
plt + geom_col() + 
  xlab('Manufacturer') +
  ylab('No. of Vehicles') +
  theme(axis.text.x = element_text(angle=45, hjust=1))

### MAKE FIRST LINE PLOT ###

# prepare summarized data: toyota data summarized by mean highway mpg
mpg_summary <- mpg %>%
  subset(manufacturer == 'toyota') %>%
  group_by(cyl) %>%
  summarize(MeanHwy = mean(hwy), .groups = 'keep')
plt <- ggplot(mpg_summary, aes(x=cyl, y=MeanHwy))
plt + 
  geom_line() +
  scale_x_discrete(limits = c(4,6,8)) + 
  scale_y_continuous(breaks = c(16:30))

### MAKE FIRST SCATTER PLOT ###

plt <- ggplot(mpg, aes(x=displ, y=cty, color = class, shape =drv))
plt +
  geom_point(size = 0.2*mpg$cty) +
  labs(x= 'Engine Size (L)',
       y='City Fuel Economy (MPG)',
       color='Vehicle Class',
       shape = 'Drive Train')

### MAKE FIRST BOXPLOT ###
plt <- ggplot(mpg, aes(y=hwy))
plt +
  geom_boxplot()

### MAKE SECOND BOXPLOT ###
# group boxplots by manufacturer
plt <- ggplot(mpg, aes(x=manufacturer, y=hwy))
plt +
  geom_boxplot(fill = '#ACDDDE',linetype='dotted' ) +
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45, hjust=1))

### MAKE FIRST HEATMAP, I.E. GEOM_TILE ###

# prepare summarized data: group by model and year, summarize by mean of hwy mpg
mpg_summary <- mpg %>%
  group_by(model, year) %>%
  summarize(MeanHwy = mean(hwy), .groups = 'keep')

# read data into ggplot
plt <- ggplot(mpg_summary, aes(y=model, x=factor(year), fill=MeanHwy))
plt +
  geom_tile() +
  labs(y = 'Model',
       x = 'Vehicle Year',
       fill = 'Mean Highway Fuel Economy (MPG)') +
  theme(axis.text.x = element_text(angle=0, hjust=1))

### FIRST LAYERED PLOT: BOXPLOT + SCATTER PLOT ###
# plot the same data in two ways

plt <- ggplot(mpg, aes(x=manufacturer, y=hwy))

plt + 
  geom_boxplot() +
  geom_point() +
  theme(axis.text.x = element_text(angle=45, hjust=1))

### SECOND LAYERED PLOT: SCATTER PLOT (MEAN) + ERROR BARS (STD DEV) ###

mpg_summary <- mpg %>%
  group_by(class) %>%
  summarize(MeanEngine = mean(displ), SDEngine = sd(displ), .groups = 'keep')
plt <- ggplot(mpg_summary, aes(x=class, y=MeanEngine))
plt +
  geom_point(size= 4) +
  labs(x='Vehicle Class', y='Mean Engine Size') +
  scale_y_continuous(limits = c(1,7), breaks = seq(1,7,2))+
  geom_errorbar(ymin=mpg_summary$MeanEngine-mpg_summary$SDEngine,
                ymax = mpg_summary$MeanEngine+mpg_summary$SDEngine)

### FACETED PLOT: BOXPLOT GROUPED BY MPG TYPE (CTY OR HWY)

# prepare long format dataframe using gather
mpg_long <- mpg %>% gather(key="MPG_Type",value="Rating",c(cty,hwy))

# read data into ggplot
plt <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type))

# make plot faceted by mpg-type (city or highway)
 plt +
   geom_boxplot() +
   facet_wrap(vars(MPG_Type)) +
   theme(axis.text.x = element_text(angle=45, hjust=1),
         legend.position = 'none') +
   xlab('Manufacturer')
 
 ################## BASIC STATISTICS ##################
 
 # test distribution of data for normality
 shapiro.test(mtcars$wt)
 
 #plot distribuion of data to visually assess normality
 ggplot(mtcars,aes(x=wt)) + geom_density()

# randomly sample a dataframe with dplyr
pop_tbl <- read.csv('used_car_data.csv', check.names = F, stringsAsFactors = F)

# test for normality
shapiro.test(log10(pop_tbl$Miles_Driven))
plt<- ggplot(pop_tbl, aes(x=Miles_Driven))
plt+geom_density()

#obviously right-skewed, apply log10 transformation
plt<- ggplot(pop_tbl, aes(x=log10(Miles_Driven)))
plt+geom_density()

# randomly sample 50 observations from dataset
sample_tbl <- pop_tbl %>%
  sample_n(50)
plt <- ggplot(sample_tbl, aes(x=log10(Miles_Driven)))
plt + 
  geom_density()

# perform one-sample t-test --> 
# H0: sample mean is not different from pop mean
# HA: sample mean is different from pop mean
t.test(log10(sample_tbl$Miles_Driven), mu=mean(log10(pop_tbl$Miles_Driven)))

# t-test results --> p > 0.05 --> Fail to reject H0
# One Sample t-test
# 
# data:  log10(sample_tbl$Miles_Driven)
# t = -0.20688, df = 49, p-value = 0.837
# alternative hypothesis: true mean is not equal to 4.39449
# 95 percent confidence interval:
#   4.242185 4.518364
# sample estimates:
#   mean of x 
# 4.380274 

# perform two-sample t-test -->
# H0: there is no difference between the two sample means.
# H0: there is a difference between the two sample means.
sample_tbl2 <- pop_tbl %>%
  sample_n(50)

t.test(log10(sample_tbl$Miles_Driven), log10(sample_tbl2$Miles_Driven))
# t-test results --> p > 0.05 --> Fail to reject H0
# Welch Two Sample t-test
# 
# data:  log10(sample_tbl$Miles_Driven) and log10(sample_tbl2$Miles_Driven)
# t = -0.034536, df = 97.053, p-value = 0.9725
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -0.1871988  0.1807953
# sample estimates:
#   mean of x mean of y 
# 4.380274  4.383476 

# perform paired t-test: cars made in 1999 vs 2008
mpg_data <- read.csv('mpg_modified.csv')
mpg_1999 <- mpg_data %>% filter(year==1999)
mpg_2008 <- mpg_data %>% filter(year==2008)
t.test(mpg_1999$hwy,mpg_2008$hwy,paired = T)

# t-test results --> p > 0.05 --> fail to reject H0
# Paired t-test
# 
# data:  mpg_1999$hwy and mpg_2008$hwy
# t = -1.1165, df = 37, p-value = 0.2714
# alternative hypothesis: true mean difference is not equal to 0
# 95 percent confidence interval:
#   -2.1480860  0.6217702
# sample estimates:
#   mean difference 
# -0.7631579 

# one-way ANOVA: an extension of paired t-tests
# mean of one dependent variable across multiple factors of one independent variable
# H0: mu1 = mu2 = ... = mun 
# HA: there exists {i,j} such that mui != muj

# prepare the data, independent variable must be a factor, all data must be in dataframe
mtcars_filtered <- mtcars[,c('hp', 'cyl')] %>% mutate(cyl=as.factor(cyl))
aov(hp ~ cyl, data = mtcars_filtered) %>% summary()

# results of one-way ANOVA --> p << 0.05 --> Reject H0
# Call:
#   aov(formula = hp ~ cyl, data = mtcars_filtered)
# 
# Terms:
#   cyl Residuals
# Sum of Squares  104030.54  41696.33
# Deg. of Freedom         2        29
# 
# Residual standard error: 37.91839
# Estimated effects may be unbalanced
#
#              Df Sum Sq Mean Sq F value   Pr(>F)    
# cyl          2 104031   52015   36.18 1.32e-08 ***
#   Residuals   29  41696    1438                     
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# determine correlation between variables
cor(mtcars$hp, mtcars$qsec)

# make scatter plot and show correlation coefficient in top right

plt <- ggplot(mtcars, aes(x=hp, y=qsec, color=factor(cyl)))
plt +
  geom_point() + 
  annotate('text', 
           label = paste("Correlation:",round(cor(mtcars$hp, mtcars$qsec),3)),
           x = max(mtcars$hp),
           y = max(mtcars$qsec),
           vjust = 1,
           hjust = 1) +
  labs(x= 'Horsepower',
       y = 'Quarter-mile Race Time (s)',
       color="Number of Cylinders")+
  theme_minimal()

# make a linear model
lm(qsec ~ hp, mtcars) %>% summary()

# results of linear model --> p << 0.05 --> slope is not zero, model has predictive value
#
# Call:
#   lm(formula = qsec ~ hp, data = mtcars)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -2.1766 -0.6975  0.0348  0.6520  4.0972 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 20.556354   0.542424  37.897  < 2e-16 ***
#   hp          -0.018458   0.003359  -5.495 5.77e-06 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1.282 on 30 degrees of freedom
# Multiple R-squared:  0.5016,	Adjusted R-squared:  0.485 
# F-statistic: 30.19 on 1 and 30 DF,  p-value: 5.766e-06

# make plot of linear model
model <- lm(qsec ~ hp, mtcars)
plt <- ggplot(mtcars, aes(x=hp, y=qsec))
plt +
  geom_point() +
  geom_line(color='red',
            aes(y=model$coefficients['hp']*mtcars$hp + model$coefficients['(Intercept)'])) + 
  annotate('text', 
           label = paste("Correlation:",round(cor(mtcars$hp, mtcars$qsec),3)),
           x = max(mtcars$hp),
           y = max(mtcars$qsec),
           vjust = 1,
           hjust = 1) +
  labs(x= 'Horsepower',
       y = 'Quarter-mile Race Time (s)',
       color="Number of Cylinders")+
  theme_minimal()

# make a multiple linear regression model
lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars) %>% summary()

# results of linear model

# Call:
#   lm(formula = qsec ~ mpg + disp + drat + wt + hp, data = mtcars)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -1.6628 -0.6138  0.0706  0.4087  3.3885 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 16.541651   3.413109   4.847 5.04e-05 ***
#   mpg          0.108579   0.077911   1.394  0.17523    
# disp        -0.008076   0.004384  -1.842  0.07689 .  
# drat        -0.578953   0.551771  -1.049  0.30371    
# wt           1.792793   0.513897   3.489  0.00175 ** 
#   hp          -0.018383   0.005421  -3.391  0.00223 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1.053 on 26 degrees of freedom
# Multiple R-squared:  0.7085,	Adjusted R-squared:  0.6524 
# F-statistic: 12.64 on 5 and 26 DF,  p-value: 2.767e-06

# perform chi-squared test to compare frequency distributions between two groups
# H0: there is no difference in frequency distribution between the two groups
# HA: There is a difference in the frequency distribution between two groups

# prepare contingency table
tbl <- table(mpg$class, mpg$year)

#perform chi-squared test
chisq.test(tbl)

# results of chi-squared test --> p >> 0.05 --> Fail to reject H0
#  warning due to small sample size, but large p lessens degree of concern 

# Pearson's Chi-squared test
# # 
# # data:  tbl
# # X-squared = 1.0523, df = 6, p-value = 0.9836
# # 
# # Warning message:
# # In chisq.test(tbl) : Chi-squared approximation may be incorrect
