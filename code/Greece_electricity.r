
library(readxl)
library(ggplot2)
library(lmtest)
library(stargazer)
electricity <- read_excel("Greece_electricity.xlsx",sheet="Data")
electricity$TIME <- as.Date(paste0(electricity$TIME, "-01"), format = "%Y-%m-%d")

#I am going to build a deterministic model, so I need to determine if I use multiplicative or additive method
ggplot(data = electricity, aes(x = TIME)) +
  geom_line(aes(y = Available_to_internal_market)) +
  labs(title = "Available Electricity to the Internal Market Over Time",
       x = "Time",
       y = "Electricity (GWh)") +
  theme_minimal() +
  theme(plot.title = element_text(size = 18, face = "bold"))


#I assume additive method is better

electricity$t <- 1:nrow(electricity)

electricity$months <- months(electricity$TIME)
electricity$months <- as.factor(electricity$months)
contrasts(electricity$months)
cm <- contr.sum(12)
rownames(cm) <- rownames(contrasts(electricity$months))
colnames(cm) <- c("April","August","December","February","January","July","June","March","May","November","October")
contrasts(electricity$months) <- cm
cm

ggplot(data=electricity, aes(x=TIME))+geom_line(aes(y=Available_to_internal_market))

#lets build some model
base_model <- lm(Available_to_internal_market ~ t,data=electricity)
summary(base_model)

quadratic_model <- lm(Available_to_internal_market~t+I(t^2), data=electricity)
summary(quadratic_model)

cubic_model <- lm(Available_to_internal_market~t + I(t^2) + I(t^3), data=electricity)
summary(cubic_model)

library(ggplot2)

ggplot(electricity, aes(x = TIME)) +
  geom_line(aes(y = Available_to_internal_market, color = "Observed")) +
  geom_line(aes(y = base_model$fitted.values, color = "Linear trend")) +
  geom_line(aes(y = quadratic_model$fitted.values, color = "Quadratic trend")) +
  geom_line(aes(y = cubic_model$fitted.values, color = "Cubic trend")) +
  labs(title = "Observed Electricity and Fitted Trend Models",
       x = "Time",
       y = "Electricity (GWh)",
       color = "Series") +
  theme_minimal() +
  theme(plot.title = element_text(size = 18, face = "bold"))



#which trend is better: the linear or the quadratic or cubic

#lets compare them
aic_values <- c(AIC(base_model), AIC(quadratic_model), AIC(cubic_model))
bic_values <- c(BIC(base_model), BIC(quadratic_model), BIC(cubic_model))
adj_r2_values <- c(summary(base_model)$adj.r.squared,
                   summary(quadratic_model)$adj.r.squared,
                   summary(cubic_model)$adj.r.squared)

stargazer(base_model, quadratic_model, cubic_model,
          type = "html",                         
          out = "trend_comparison.html",         
          title = "Trend Model Comparison",
          column.labels = c("Linear Trend", "Quadratic Trend", "Cubic Trend"),
          dep.var.labels = "Available to Internal Market (GWh)",
          omit = ".",            
          keep.stat = c("n"),     
          no.space = TRUE,
          add.lines = list(
            c("AIC", aic_values),
            c("BIC", bic_values),
            c("Adjusted R²", round(adj_r2_values, 4))
          ),
          align = TRUE)

#according to AIC and BIC the quadtatic trend is the best
#and the adjusted R squared also greater in case of the quadratic model


quadratic_model_season <- lm(Available_to_internal_market~t+I(t^2)+months, data=electricity)
summary(quadratic_model_season)

#lets check the structural breaks
library(strucchange)
str_breaks <- breakpoints(electricity$Available_to_internal_market~1,data=electricity)
length(str_breaks$breakpoints)
str_breaks$breakpoints
electricity$Sections <-  ifelse(electricity$t>176,"Part2","Part1")
quadratic_model_season_breaks <- lm(Available_to_internal_market~t+I(t^2)+Sections*t+Sections+months, data=electricity)
summary(quadratic_model_season)

ggplot(data=electricity, aes(x=TIME))+ 
  geom_line(aes(y=Available_to_internal_market,col="Observation"))+ 
  geom_line(aes(y=quadratic_model$fitted.values,col="Quadratic trend"))+ 
  geom_line(aes(y=quadratic_model_season$fitted.values,col="Quadratic trend with seasons"))+ 
  geom_line(aes(y=quadratic_model_season_breaks$fitted.values,col="Quadratic trend with seasons and breakpoint"))+ 
  theme_minimal()

#I test the breakpoint with Chow test
#H0: there is no breakpoint in the dataset (it splits into groups by the breakpoint, 
#if the coefficients of these are the same, there is no breakpoint)
#H1: there is significant breakpoint (so the coefficients are not the same)
sctest(quadratic_model_season_breaks, type = "Chow", point = 176)
#based on the test there is no significant structural break

library(ggplot2)

ggplot(data = electricity, aes(x = TIME)) +
  geom_line(aes(y = Available_to_internal_market)) +
  geom_vline(xintercept = as.Date(c("2020-01-01", "2022-01-01")), 
             linetype = "dashed", color = "red", size = 0.8) +
  geom_vline(xintercept = as.Date(c("2021-08-01")), 
             linetype = "dashed", color = "orange", size = 0.8) +
  labs(
    title = "Available electricity on the internal market in Greece",
    x = "Time",
    y = "Electricity (GWh)",
    color = "Legend"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold",hjust = 0.50),
    axis.title = element_text(face = "bold")
  ) + annotate("text", x = as.Date("2020-01-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
              label = "2020-01", vjust = 1.5, color = "red", size = 3, angle = 90) +
  annotate("text", x = as.Date("2022-01-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2022-01", vjust = 1.5, color = "red", size = 3, angle = 90) +
  annotate("text", x = as.Date("2021-08-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2021-08", vjust = 1.5, color = "orange", size = 3, angle = 90) 




#lets include the tempretures as well as an explanatory variable
temp <- read_excel("Temperature.xlsx")
colnames(temp) <- c("TIME","Temperature")
temp$TIME <- as.Date(temp$TIME)
electricity <- merge(electricity, temp,by="TIME",all.x=T)
quadratic_season_temp <- lm(Available_to_internal_market~t+I(t^2)+Temperature+months, data=electricity)
summary(quadratic_season_temp)
coef(quadratic_season_temp)

#is it better than the model without the temperature?


#lets see the AIC and BIC
broom::glance(quadratic_model_season)
broom::glance(quadratic_season_temp)
#The BIC is the same for these, the AIC is lower in case of the model with temperature
#and the adjusted R^2 prefers also that model, so I chose quadratic_season_temp model

#y(t) = Trend + Season + Error

##test autocorrelation on my model

#lets check the first order autocorrelation
#H0: there is no first order autocorrelation
#H1: there is first order autocorrelation
dwtest(quadratic_season_temp$residuals~1,alternative = "two.sided") 
#between 1.8 and 2.2 there is no autocorrelation, but our test value is 0.9153, so 
#we reject H0, there is first order autocorrelation

#testing higher order autocorrelation
#Ljung-box test
Box.test(quadratic_season_temp$residuals, lag=13, type="Ljung-Box") #annual lag is 4-5, monthly lag is periods +1 so 12-13, quarterly is 8, daily 10-15 lags
#H0: rho1=rho2=...=rho10=0 there is no autocorrelation up to 10 lags
#H1: there is autocorr so exist k such that rho_k = rho_k-t
#p is almost 0, so I reject H0 so there is autocorrelation up to 13 lags

#recommanded test: Breusch-godfrey
bgtest(quadratic_season_temp$residuals~1, order=13)
#X(t) = alpha+phi1*x(t-1) +phi2*x(t-2)+---
#H0: phi1=phi2=phi10=0 there is no autocorr up to 10 lags
#H1: there is autocorrelation up to 10 lags
#p is almost 0, so I reject H0 so there is autocorrelation up to 13 lags

#Trend
summary(quadratic_season_temp)
coef(quadratic_season_temp)
4.9958045+2*-0.0366762

# Load stargazer
library(stargazer)
library(stargazer)

stargazer(quadratic_season_temp,
          type = "html",
          title = "Deterministic Model with Seasonal and Temperature Effects",
          dep.var.labels = "Available electricity (GWh)",
          covariate.labels = c(
            "Time (t)",
            "Time squared (t²)",
            "Temperature",
            "April",
            "August",
            "December",
            "February",
            "January",
            "July",
            "June",
            "March",
            "May",
            "November",
            "October",
            "Intercept"
          ),
          digits = 3,
          align = TRUE,out = "model_quadratic_season_temp.html")



#seasonal differences
coef(quadratic_season_temp)
seasonal_effect <- coef(quadratic_season_temp)[5:15]
seasonal_effect <- data.frame(seasonal_effect)
rownames(seasonal_effect) <- c( "April", "August", "December", "February", "January", "July", "June", "March", "May", "November", "October")
September_value <- -sum(seasonal_effect$seasonal_effect)
seasonal_effect["September", ] <- September_value
seasonal_effect

mean(seasonal_effect$seasonal_effect)
seasonal_effect$months <- rownames(seasonal_effect)
seasonal_effect
electricity <- merge(electricity, seasonal_effect, by = "months", all.x = TRUE)
electricity <- electricity[order(electricity$TIME), ]


#seasonal adjustment
electricity$adjusted_seasonally <- electricity$Available_to_internal_market-electricity$seasonal_effect
electricity$seasonal_effect
ggplot(data=electricity, aes(x=TIME))+
  geom_line(aes(y=Available_to_internal_market,col="Observation"))+
  geom_line(aes(y=adjusted_seasonally,col="Seasonally adjusted"),size=1)+
  geom_vline(xintercept = as.Date(c("2020-01-01", "2022-01-01")), 
             linetype = "dashed", color = "red", size = 0.8) +
  geom_vline(xintercept = as.Date(c("2021-08-01")), 
             linetype = "dashed", color = "orange", size = 0.8) +
  labs(title = "Seasonally adjusted observations",
       x = "Time",
       y = "Electricity (GWh)") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold",hjust = 0.63),
    axis.title = element_text(face = "bold")
  ) + annotate("text", x = as.Date("2020-01-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
               label = "2020-01", vjust = 1.5, color = "red", size = 3, angle = 90) +
  annotate("text", x = as.Date("2022-01-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2022-01", vjust = 1.5, color = "red", size = 3, angle = 90) +
  annotate("text", x = as.Date("2021-08-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2021-08", vjust = 1.5, color = "orange", size = 3, angle = 90) 

ggplot(data=electricity, aes(x=TIME))+
  geom_line(aes(y=Available_to_internal_market,col="Observation"))+
  geom_line(aes(y=quadratic_season_temp$fitted.values,col="quadratic model with season and temperature"))+
  theme_minimal()

#lets visualize it
ggplot(data = electricity, aes(x = TIME)) +
  geom_line(aes(y = Available_to_internal_market, col = "Observation")) +
  geom_line(aes(y = adjusted_seasonally, col = "Adjusted seasonally")) +
  geom_line(aes(y = quadratic_season_temp$fitted.values, 
                col = "Quadratic Trend with Seasons and Temperature"), size = 1) +  
  geom_vline(xintercept = as.Date(c("2021-07-01")), 
             linetype = "dashed", color = "purple", size = 0.8) +
  geom_vline(xintercept = as.Date(c("2012-07-01")), 
             linetype = "dashed", color = "darkgreen", size = 0.8) +
  geom_vline(xintercept = as.Date(c("2024-07-01")), 
             linetype = "dashed", color = "darkblue", size = 0.8) +
  geom_vline(xintercept = as.Date(c("2023-07-01")), 
             linetype = "dashed", color = "darkred", size = 0.8) +
  labs(
    title = "Final deterministic model",
    x = "Time",
    y = "Electricity (GWh)",
    color = "Legend"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.70),
    axis.title = element_text(face = "bold")
  )+
  # Add text at the bottom of each dashed line
  annotate("text", x = as.Date("2021-07-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2021-07", vjust = 1.5, color = "purple", size = 3, angle = 90) +
  annotate("text", x = as.Date("2012-07-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2012-07", vjust = 1.5, color = "darkgreen", size = 3, angle = 90) +
  annotate("text", x = as.Date("2023-07-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2023-07", vjust = 1.5, color = "darkred", size = 3, angle = 90) +
  annotate("text", x = as.Date("2024-07-01"), y = min(electricity$Available_to_internal_market, na.rm = TRUE),
           label = "2024-07", vjust = 1.5, color = "darkblue", size = 3, angle = 90) 
