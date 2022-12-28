#### Deliverable 1: Linear Regression to Predict MPG ####

# load packages
library(dplyr)

# setwd (commented out after running)
setwd('/Users/catherinesmith/Desktop/unc_bootcamp/module_16/UNCBC-HW16-AutosRUs/Challenge')

# read in data from file
df <- read.csv('MechaCar_mpg.csv')

# create linear model
model <- lm(mpg ~ vehicle_length + vehicle_weight + spoiler_angle + ground_clearance + AWD, df)

# get intercept and regression coefficients
model

# get model summary: R^2 = 0.7149, p = 5.35E-11
summary(model)

# create plot of model with regression line. Annotate with R^2 and p-value.
# adapted from code sources:
# https://sejohnston.com/2012/08/09/a-quick-and-easy-function-to-plot-lm-results-in-r/
# https://stackoverflow.com/questions/5587676/pull-out-p-values-and-r-squared-from-a-linear-regression
ggplotRegression <- function (fit) {
  
  require(ggplot2)
  
  f <- summary(fit)$fstatistic
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point() +
    stat_smooth(method = "lm", col = "red") +
    labs(title = paste("R^2 = ",signif(summary(fit)$r.squared, 5),
                       "Intercept =",signif(fit$coef[[1]],5 ),
                       " Slope =",signif(fit$coef[[2]], 5),
                       " P =",signif(pf(f[1],f[2],f[3],lower.tail=F), 5)),
         x = paste('Model: ', as.character(summary(fit)$call)[2] )) +
    theme_minimal()
}

png('ModelPlot.png')
ggplotRegression(model)
dev.off()

# a good way to assess a linear model: diagnostic plots
# Simon Sheather, A Modern Approach to Regression with R
png('DiagnosticPlots.png')
par(mfrow=c(2,2))
plot(model)
dev.off()


# 1. Residuals vs fitted: no clear pattern --> there does not appear to be a non-linear
# relationship between predictors and dependent variable --> good
# 2. Normal Q-Q: roughly linear with a slope of 1 --> residuals are normally distributed --> good
# 3. The spread in residuals appears constant across the range of predictors --> good
# 4. All Cook's distances are less than 0.5 --> no outliers/points of high leverage --> good

#### Deliverable 2: Trip Analysis ####

# read in the data from file
tbl <- read.csv('Suspension_Coil.csv')

# create summary dataframe
total_summary <- tbl %>%
  summarize(Mean = mean(PSI),
            Median = median(PSI),
            Variance = var(PSI),
            SD = sd(PSI))

# create  lot summary dataframe
lot_summary <- tbl %>%
  group_by(Manufacturing_Lot) %>%
  summarize(Mean = mean(PSI),
            Median = median(PSI),
            Variance = var(PSI),
            SD = sd(PSI),
            .groups='keep')

#### Deliverable 3: T-tests on Suspension Coils ####
t.test(tbl$PSI, mu=1500) # p=0.06028 --> Fail to reject H0 (but a bit too close to 0.05)
t.test(subset(tbl$PSI, tbl$Manufacturing_Lot == 'Lot1'), mu=1500) # p = 1 --> fail to reject H0
t.test(subset(tbl$PSI, tbl$Manufacturing_Lot == 'Lot2'), mu=1500)  # p=0.6072 --> fail to reject H0
t.test(subset(tbl$PSI, tbl$Manufacturing_Lot == 'Lot3'), mu=1500)  # p=0.04168 --> Reject H0, Lot3 mean is statistically different from 1500
