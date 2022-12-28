# MechaCar Statistical Analysis

## Linear Regression to Predict Fuel Economy (MPG)

A linear model was constructed to predict fuel economy (MPG) of MechaCar prototypes based on other variables avariable (Vehicle Length, Weight, Spoiler Angle, Ground Clearance, and AWD). 

![ModelPlot](Challenge/ModelPlot.png)


*Linear Model of mpg ~ Length + Weight + Spoiler Angle + Ground Clearance + AWD with 95% Confidence Interval*

Additonally, diagnostic plots of the model show that the conditions of linearity, homoscedasticity, indepedence, and normality are met. Thus, this is a valid model.

![DiagnosticPlots.pdf](Challenge/DiagnosticPlots.png)


*Diagnostic Plots of linear model show that assumptions are met*

The model was found to be highly significant (p = 5.35E-11) and explained roughly 70% of the variation in the dependent variable (R<sup>2</sup> = 0.7149). Thus, H<sub>0</sub> can be rejected in favor of H<sub>A</sub>, i.e. the slope is statistically different from zero. The model indicates that vehicle weight and ground clearance are highly significant predictors (p << 0.05 for both). Since the model is valid and R<sup>2</sup> > 0.7, it can be concluded that there is a strong relationship between the predictors and mpg and that this model is effective.

![ModelSummary](Challenge/ModelSummary.png)


*Summarized Results of linear model, p = 5.35E-11, R<sup>2</sup> = 0.7149*