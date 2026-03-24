# Analysis of Available Electricity to Internal Market in Greece

## Introduction

The electricity market is not a typical market, and this becomes clearer when you look at how it works. Unlike products like coal, wheat, or steel, electricity can't be stored and used later. It must be generated and consumed at the same time. Because supply and demand need to be balanced in real time, electricity acts both as an economic commodity and as a critical public good. This means that prices alone can't guarantee stability, so careful planning, reserves, and regulation are always necessary. The importance of this approach is magnified by the wide array of potential threats to energy security. Preparedness for events like pandemics, extreme weather, cyber-attacks, and war is not optional but essential, underscoring the need for a resilient electricity sector (Fabra et al. 2022).

To manage these unique challenges on a continental scale, the European Union began building a single, unified energy market. As part of this effort, Greece began opening up its electricity sector to competition in the late 1990s. A series of EU Energy Packages, from the First (1996) to the Fifth (2021), introduced new rules that broke up state monopolies, made it easier for companies to enter the market, and encouraged cross-border trading (Ntemou et al., 2025).

These regulatory changes were supported by key institutions like the national regulator (RAE) and new market mechanisms. The launch of the **"European Target Model"** in 2020 was a major milestone, leading Greece to establish the Day-Ahead, Intraday, and Balancing Markets, creating a competitive wholesale environment.

The solutions Greece is now pursuing to achieve stability directly address the core problem of balancing supply and demand:

1. **Battery Energy Storage Systems (BESS)** - Building large batteries with a target of 3.1 gigawatts by 2030
2. **Cross-border connections** - Strengthening connections to trade power with neighboring countries

Both strategies are essential because, as recent crises have shown, market forces alone cannot guarantee the resilience of this critical public service (Fabra et al., 2022).

A central part of Greece's long-term strategy is a shift from fossil fuels to renewable energy, which supports long-term economic growth and climate goals. However, this transition introduces new challenges for grid stability. The rise of solar power, for example, has created a daily "solar wave" — a surplus of cheap power at midday that can lead to negative prices, followed by a rapid drop at night (Dimos Chatzinikolaou, 2025). This highlights the critical need for the storage solutions mentioned earlier, as excess solar energy often cannot be saved for later.

### Research Hypotheses

All these factors are reflected in the total available electricity. The hypotheses are as follows:

1. Whether the introduction of the Target Model led to a significant structural break
2. Whether the increase in solar energy capacity makes temperature a relevant explanatory variable for the variation in available electricity
3. Whether the effects of COVID-19 are observable in the data
4. Whether the surge in prices following the war in Ukraine affected the domestic electricity market

---

## Model Building

### Dataset

The analysis is based on monthly data on electricity supplied to the internal market in Greece, measured in gigawatt-hours (GWh), and spans the period from **2008 to 2025**, providing a clear picture of how the electricity supply has evolved over time.

### Trend

The initial step in this time-series analysis was to develop a suitable model. Figure 1 reveals a distinct periodic pattern, justifying the selection of a deterministic modeling approach.

> **Figure 1:** Available electricity to internal market in Greece

The subsequent step was to identify an appropriate trend component. Linear, quadratic, and cubic trends were evaluated.

> **Table:** Trend comparison

The linear trend demonstrated a poor fit, particularly between 2015 and 2020. Based on the Akaike Information Criterion (AIC) and the Bayesian Information Criterion (BIC), the quadratic trend was superior to the cubic trend. Furthermore, it achieved the highest adjusted R² (0.127), confirming that it provides the best explanation for the underlying trend in the data.

### Preprocessing Seasonal Effect

As Figure 1 illustrates, the data exhibits a strong seasonal pattern. Seasonality was incorporated using **contrast coding** instead of traditional dummy variables, as the latter would violate several assumptions of linear regression. Contrast coding allows each month to be compared to the overall mean, rather than to a single reference month, allowing for a clearer interpretation of seasonal effects.

### Structural Break Analyses

My assumption is that **2020** is a potential breakpoint due to the introduction of The Target Model marking a key milestone for market reform. This regulatory shift introduced a fundamentally new wholesale electricity market structure consisting of four distinct, coupled markets.

Another breakpoint was assumed for **2022**, corresponding to:
- The rapid scaling of solar capacity in Greece
- The impact of the COVID-19 pandemic
- The Russia–Ukraine conflict

These events contributed to significant increases in energy prices: in the second quarter of 2022, wholesale electricity prices rose year-on-year by:
- **254%** in France
- **238%** in Greece
- **234%** in Italy

This positioned Greece as the third most expensive market at **€237/MWh** (Quarterly Report on European Electricity Markets, 2022).

A statistical breakpoints function identified a single potential breakpoint in **August 2022**. To assess its significance, I used the **Chow test**. The test splits the dataset into groups by the breakpoint:

- **H₀**: Error variances for the two groups are equal
- **H₁**: Significant difference, implying structural change

The test produced a **p-value of 0.6677**, indicating that the null hypothesis cannot be rejected. Therefore, **no structural break is present** in the series.

> **Figure 2:** Potential structural breaks

Despite the lack of a formal structural break, the visual downward trend suggests underlying market shifts, potentially due to:

- **Rapid expansion of solar energy** — leading to midday oversupply and curtailments due to insufficient storage infrastructure
- **Cross-border market integration** — facilitating exports to neighboring countries, potentially reducing domestic supply during peak trading periods
- **Temperature influence** — as solar generation and seasonal demand patterns increasingly shape daily and monthly availability
- **External shocks** — COVID-19 pandemic and energy price surge following the Russia–Ukraine conflict

### Temperature as an Explanatory Variable

Given the growth in solar capacity, it was hypothesized that temperature would significantly impact electricity availability. A model was estimated with the quadratic trend, seasonal contrasts, and average temperature.

**Key Finding:** The temperature variable had a statistically significant coefficient of approximately **-30.78 (p < 0.05)**. This indicates that, all else being equal, a 1°C temperature increase is associated with a decrease of about **30.78 GWh** in electricity available to the internal market.

The finding that higher temperatures reduce available electricity is important. Although heat increases air conditioning demand, it also causes a large jump in solar power production. The result shows that this solar surge is so strong that it creates an oversupply. To keep the grid stable, Greece must either waste this excess solar power or export it. This is why, on hotter days, less electricity ends up being counted as available for the Greek internal market.

This model was also preferred compared to the model without the temperature variable by both AIC and adjusted R², confirming temperature's meaningful role.

### Error Term and Other Assumptions

Before concluding that this is the final model, it is important to examine the behavior of the residuals. Ideally, the residuals should resemble white noise, exhibiting weak stationarity and no autocorrelation.

#### Durbin–Watson Test (First-order autocorrelation)

- **H₀**: No first-order autocorrelation
- **H₁**: Presence of first-order autocorrelation
- **Result**: DW statistic = **0.9153** (outside the 1.8–2.2 range)
- **Conclusion**: Reject H₀; first-order autocorrelation is present

#### Ljung–Box and Breusch–Godfrey Tests (Higher-order autocorrelation)

- **H₀**: Autocorrelations up to lag 13 are zero
- **H₁**: At least one autocorrelation is non-zero
- **Result**: p-value ≈ 0 for both tests
- **Conclusion**: Autocorrelation exists up to 13 lags

This indicates that the error term contains information not yet extracted, suggesting that a **stochastic modeling approach (e.g., ARIMA)** would be more suitable for forecasting. However, for identifying and interpreting the primary deterministic components (trend, seasonality, temperature), the current model is retained.

> **Figure 3:** Final model

Figure 3 indicates that the model periodically overestimates and underestimates the observed values, particularly failing to capture the magnitude of peak observations. These apparent misestimations may not actually be errors, but rather **outliers**:

- **July 2012** (dark green dashed line) — Third hottest summer recorded since 1960
- **Summer 2023** (dark red dashed line) — Record-breaking heatwaves; post-COVID economic recovery increased both residential and commercial electricity consumption
- **July 2024** (dark blue dashed line) — Prolonged periods of exceptionally high temperatures, significantly surpassing seasonal norms

---

## Results

### The Final Model

> **Table:** Final model

### Trend Analyses

The model identifies a significant underlying **positive trend**. After controlling for seasonal effects and temperature:

- Initial underlying growth rate: **4.9224 GWh per month** on average
- The sign of the quadratic coefficient indicates an **inverted parabolic trend**
- The model accounts for **88%** of the variance in the available electricity to Greece's internal market
- According to the F test, the result is **statistically significant**

### Seasonality Analyses

The final model's coefficients were used to extract the seasonal effects. With contrast coding, the coefficient for September was derived as the negative sum of the other monthly coefficients.

| Season | Months | Seasonal Effect |
|--------|--------|-----------------|
| **Summer Peak** | July | +1394.08 GWh |
| | August | +1074.79 GWh |
| | June | +283.72 GWh |
| **Spring/Autumn Decline** | April | -721.14 GWh |
| | November | -491.15 GWh |
| | February | -456.28 GWh |
| **Near Average** | January | +88.10 GWh |
| | September | +34.05 GWh |
| | December | -58.58 GWh |

**Key Insights:**
- Summer months have the strongest positive seasonal effects, primarily driven by high demand for air conditioning
- Spring and late autumn months demonstrate notable declines, reflecting reduced energy generation/import, reduced renewable output, or maintenance cycles
- These findings confirm that the market is **highly sensitive to seasonal fluctuations**

### Seasonality Adjustment

To obtain a clearer view of the underlying trend, the data was examined with the seasonal component removed.

> **Figure 4:** Seasonally adjusted electricity

Using the additive model, the estimated seasonal effects were subtracted from the original observations. Seasonal adjustment confirms the **downturn is real**. The notable peak in August 2021 (orange dashed line) was driven by typical seasonal patterns, not underlying growth.

The adjusted data shows a **consistent and narrowing downward trend**, indicating a fundamental market shift. The consistent decline could be primarily due to two factors:

1. **Domestically**: A significant rise in electricity prices has led to reduced consumption by both households and industries
2. **Externally**: An increase in electricity exports to other countries has diverted power away from the Greek internal market

---

## Conclusion

This analysis set out to test several hypotheses regarding the Greek internal electricity market. The key findings are as follows:

| Hypothesis | Finding |
|------------|---------|
| Structural break from Target Model | **Not statistically identified** despite major regulatory and geopolitical events |
| Temperature as predictor | **Significant negative predictor** of available electricity, confirming its relevance in a system with high solar penetration |
| COVID-19 and Ukraine war effects | Effects appear as **temporary shocks** rather than permanent structural changes |
| Seasonality | **Exceptionally strong**, peaking in summer months due to high cooling demand |

### Limitations

It is important to note that this model has limitations, primarily the **significant autocorrelation in the residuals**, suggesting future research would benefit from a stochastic modeling approach. Since deterministic modeling requires confidence in the underlying trend, which we currently lack, we can only assume that the declining trend may reverse in the future. However, this remains to be seen.

---

## References

1. Fabra, N., Motta, M., & Peitz, M. (2022). Learning from electricity markets: How to design a resilience strategy. *Energy Policy*, 168, 113116. https://doi.org/10.1016/j.enpol.2022.113116

2. Ntemou, E., Ioannidis, F., Kosmidou, K., & Andriosopoulos, K. (2025). Navigating electricity market design of Greece: Challenges and reform initiatives. *Energies*, 18(10), 2575. https://doi.org/10.3390/en18102575

3. Chatzinikolaou, D. (2025). Integrating sustainable energy development with energy ecosystems: Trends and future prospects in Greece. *Sustainability*, 17(4), 1487. https://doi.org/10.3390/su17041487

4. Wooldridge, J. M. (n.d.). *Introductory Econometrics: A Modern Approach* (7th ed.). http://lib.ysu.am/disciplines_bk/33b6e2aa30379171d53274830843d3f8.pdf

5. European Commission. (2022). Quarterly report on European electricity markets: Market Observatory for Energy, DG Energy (Vol. 15, Issue 2, covering the second quarter of 2022). https://commission.europa.eu/system/files/2022-10/quarterly_report_on_european_electricity_markets_q2_2022_final.pdf
