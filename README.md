# Analysis of Available Electricity to Internal Market in Greece

---

## Table of Contents

1. [Introduction](#1-introduction)  
2. [Model Building](#2-model-building)  
   - [2.1 Dataset](#21-dataset)  
   - [2.2 Trend](#22-trend)  
   - [2.3 Preprocessing Seasonal Effect](#23-preprocessing-seasonal-effect)  
   - [2.4 Structural Break Analyses](#24-structural-break-analyses)  
   - [2.5 Temperature as an Explanatory Variable](#25-temperature-as-an-explanatory-variable)  
   - [2.6 Error Term and Other Assumptions](#26-error-term-and-other-assumptions)  
3. [Result](#3-result)  
   - [3.1 The Final Model](#31-the-final-model)  
   - [3.2 Trend Analyses](#32-trend-analyses)  
   - [3.3 Seasonality Analyses](#33-seasonality-analyses)  
   - [3.4 Seasonality Adjustment](#34-seasonality-adjustment)  
4. [Conclusion](#4-conclusion)  



# 1. Introduction

The electricity market is not a typical market, and this becomes clearer when you look at how it works. Unlike products like coal, wheat, or steel, electricity can’t be stored and used later. It must be generated and consumed at the same time. Because supply and demand need to be balanced in real time, electricity acts both as an economic commodity and as a critical public good. This means that prices alone can’t guarantee stability, so careful planning, reserves, and regulation are always necessary. The importance of this approach is magnified by the wide array of potential threats to energy security. Preparedness for events like pandemics, extreme weather, cyber-attacks, and war is not optional but essential, underscoring the need for a resilient electricity sector (Fabra et al. 2022).

To manage these unique challenges on a continental scale, the European Union began building a single, unified energy market. As part of this effort, Greece began opening up its electricity sector to competition in the late 1990s. A series of EU Energy Packages, from the First (1996) to the Fifth (2021), introduced new rules that broke up state monopolies, made it easier for companies to enter the market, and encouraged cross-border trading (Ntemou et al., 2025).

These regulatory changes were supported by key institutions like the national regulator (RAE) and new market mechanisms. The launch of the "European Target Model" in 2020 was a major milestone, leading Greece to establish the Day-Ahead, Intraday, and Balancing Markets, creating a competitive wholesale environment.

The solutions Greece is now pursuing to achieve stability directly address the core problem of balancing supply and demand. The first is building large batteries, known as Battery Energy Storage Systems (BESS), with a target of 3.1 gigawatts by 2030. The second is strengthening cross-border connections to trade power with neighboring countries. Both strategies are essential because, as recent crises have shown, market forces alone cannot guarantee the resilience of this critical public service (Fabra et al., 2022).

A central part of Greece's long-term strategy is a shift from fossil fuels to renewable energy, which supports long-term economic growth and climate goals. However, this transition introduces new challenges for grid stability. The rise of solar power, for example, has created a daily "solar wave" so a surplus of cheap power at midday that can lead to negative prices, followed by a rapid drop at night (Dimos Chatzinikolaou, 2025). This highlights the critical need for the storage solutions mentioned earlier, as excess solar energy often cannot be saved for later.

All these factors are reflected in the total available electricity. My hypotheses are as follows:

1. Whether the introduction of the Target Model led to a significant structural break  
2. Whether the increase in solar energy capacity makes temperature a relevant explanatory variable  
3. Whether the effects of COVID-19 are observable in the data  
4. Whether the surge in prices following the war in Ukraine affected the domestic electricity market  



# 2. Model Building

## 2.1 Dataset

The analysis is based on monthly data on electricity supplied to the internal market in Greece, measured in gigawatt-hours (GWh), and spans the period from 2008 to 2025, providing a clear picture of how the electricity supply has evolved over time.



## 2.2 Trend

The initial step in this time-series analysis was to develop a suitable model. Figure 1 reveals a distinct periodic pattern, justifying the selection of a deterministic modeling approach.

**Figure 1.**
<p align="center">
<img src="https://github.com/Livi8/Statistical-analysis-of-Greece-s-electricity/blob/main/data/Picture1.png?raw=true" width="60%">
</p>

The subsequent step was to identify an appropriate trend component. Linear, quadratic, and cubic trends were evaluated.

<p align="center">
<img src="https://github.com/Livi8/Statistical-analysis-of-Greece-s-electricity/blob/main/data/table1.png?raw=true" width="60%">
</p>


The linear trend demonstrated a poor fit, particularly between 2015 and 2020. Based on the Akaike Information Criterion (AIC) and the Bayesian Information Criterion (BIC), the quadratic trend was superior to the cubic trend. Furthermore, it achieved the highest adjusted R² (0.127), confirming that it provides the best explanation for the underlying trend in the data.



## 2.3 Preprocessing Seasonal Effect

As Figure 1 illustrates, the data exhibits a strong seasonal pattern. Seasonality was incorporated using contrast coding instead of traditional dummy variables, as the latter would violate several assumptions of linear regression.

Contrast coding allows each month to be compared to the overall mean rather than to a single reference month, allowing for a clearer interpretation of seasonal effects. Before examining these, let’s have a look at the structural breaks.


## 2.4 Structural Break Analyses

My assumption is that 2020 is a potential breakpoint due to the introduction of The Target Model marking a key milestone for market reform. This regulatory shift introduced a fundamentally new wholesale electricity market structure consisting of four distinct, coupled markets.

Another breakpoint was assumed for 2022, corresponding to the rapid scaling of solar capacity in Greece. That year also saw the impact of the COVID-19 pandemic and the Russia–Ukraine conflict.

These events contributed to significant increases in energy prices: in the second quarter of 2022, wholesale electricity prices rose year-on-year by 254% in France, 238% in Greece, and 234% in Italy, positioning Greece as the third most expensive market at €237/MWh.

Higher prices drive changes in consumption, which then influence energy production, capturing the equilibrium between supply and demand.

A statistical breakpoints function identified a single potential breakpoint in August 2022. To assess its significance, I used the Chow test.

**Figure 2.**
<p align="center">
<img src="https://github.com/Livi8/Statistical-analysis-of-Greece-s-electricity/blob/main/data/Picture2.png?raw=true" width="60%">
</p>



The test produced a p-value of 0.6677, indicating that the null hypothesis cannot be rejected. Therefore, no structural break is present in the series.

## 2.5 Temperature as an Explanatory Variable

Given the growth in solar capacity, it was hypothesized that temperature would significantly impact electricity availability.

I estimated a model with the quadratic trend, seasonal contrasts, and average temperature. The temperature variable had a statistically significant coefficient of approximately **−30.78 (p < 0.05)**.

This indicates that, all else being equal, a **1°C temperature increase is associated with a decrease of about 30.78 GWh** in electricity available to the internal market.

This model was also preferred compared to the model without the temperature variable by both **AIC and adjusted R²**, confirming temperature's meaningful role.


## 2.6 Error Term and Other Assumptions

Before concluding that this is the final model, it is important to examine the behavior of the residuals.

**Figure 3.**

<p align="center">
<img src="https://github.com/Livi8/Statistical-analysis-of-Greece-s-electricity/blob/main/data/Picture3.png?raw=true" width="60%">
</p>




Figure 3 indicates that the model periodically overestimates and underestimates the observed values, particularly failing to capture the magnitude of peak observations.

These apparent misestimations may not actually be errors rather outliers.

Examples include:

- **July 2012** — third hottest summer since 1960  
- **Summer 2023** — record-breaking heatwaves  
- **July 2024** — prolonged extreme temperatures across Greece  


# 3. Result

## 3.1 The Final Model

<p align="center">
<img src="https://github.com/Livi8/Statistical-analysis-of-Greece-s-electricity/blob/main/data/table21.png?raw=true" width="60%">
</p>

<p align="center">
<img src="https://github.com/Livi8/Statistical-analysis-of-Greece-s-electricity/blob/main/data/table22.png?raw=true" width="60%">
</p>


## 3.2 Trend Analyses

The model identifies a significant underlying positive trend. After controlling for seasonal effects and temperature, the initial underlying growth rate is **4.9224 GWh per month** on average.

The sign of the quadratic coefficient indicates an **inverted parabolic trend**.

The model explains **88% of the variance** in available electricity to Greece’s internal market. According to the **F-test**, the result is statistically significant.

## 3.3 Seasonality Analyses

The final model's coefficients were used to extract the seasonal effects.

The results show that summer months, particularly:

- **July:** +1394.08 GWh  
- **August:** +1074.79 GWh  

have the strongest positive seasonal effects.

The most negative seasonal effects occur in:

- **April:** −721.14 GWh  
- **November:** −491.15 GWh  
- **February:** −456.28 GWh  

These findings confirm that the market is **highly sensitive to seasonal fluctuations**.

## 3.4 Seasonality Adjustment
**Figure 4.**
<p align="center">
<img src="https://github.com/Livi8/Statistical-analysis-of-Greece-s-electricity/blob/main/data/Picture4.png?raw=true" width="60%">
</p>



Using the additive model, the estimated seasonal effects were subtracted from the original observations.

Seasonal adjustment confirms the downturn is real. The adjusted data shows a **consistent downward trend**, indicating a fundamental market shift.

# 4. Conclusion

This analysis set out to test several hypotheses regarding the Greek internal electricity market. The key findings are as follows: First, despite major regulatory and geopolitical events, no single structural break was statistically identified. Second, temperature has emerged as a significant negative predictor of available electricity, confirming its relevance in a system with high solar penetration. Third, while visual inspection suggests the impact of events like the COVID-19 pandemic and the Ukraine war, their effects appear as temporary shocks rather than permanent structural changes. Finally, the model reveals exceptionally strong seasonality, peaking in the summer months due to high cooling demand. It is important to note that this model has limitations, primarily the significant autocorrelation in the residuals, suggesting future research would benefit from a stochastic modeling approach. Since deterministic modeling requires confidence in the underlying trend, which we currently lack, we can only assume that the declining trend may reverse in the future. However, this remains to be seen.
<img width="468" height="281" alt="image" src="https://github.com/user-attachments/assets/1a1d7fc3-2c8e-4b64-ab04-f147e4c49e8d" />


# References

Fabra, N., Motta, M., & Peitz, M. (2022). Learning from electricity markets: How to design a resilience strategy. *Energy Policy*, 168, 113116.

Ntemou, E., Ioannidis, F., Kosmidou, K., & Andriosopoulos, K. (2025). Navigating electricity market design of Greece: Challenges and reform initiatives. *Energies*, 18(10), 2575.

Chatzinikolaou, D. (2025). Integrating sustainable energy development with energy ecosystems: Trends and future prospects in Greece. *Sustainability*, 17(4), 1487.

Wooldridge, J. M. (n.d.). *A modern approach (7th ed.).*

European Commission. (2022). *Quarterly report on European electricity markets: Market Observatory for Energy.*
