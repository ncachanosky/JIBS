# Corporate Cash Holdings Under Populism: The Inflation Channel and Dollarization

## Research Question

How does populism affect corporate cash holdings, and does this relationship differ between dollarized and non-dollarized economies?

## Core Contribution

**Twofold contribution:**

1. **Dual mechanism framework:** Left-Populism creates competing forces on cash holdings:
   - **Precautionary motive (+):** Institutional damage and policy uncertainty incentivize firms to hold more cash for financial flexibility
   - **Inflation cost (-):** Higher expected inflation increases the opportunity cost of holding cash, pushing firms to reduce cash reserves

2. **Dollarization as natural experiment:** Formally dollarized countries (Ecuador, El Salvador, Panama) provide a clean test of the inflation channel—when populist regimes cannot affect inflation expectations, does the cash holdings response differ?

## Key Theoretical Insight

**Left-wing vs. right-wing populism operate through different channels:**

- **Left-wing populism:** Works through both mechanisms—institutional damage (precautionary ↑) AND inflation expectations (opportunity cost ↑), creating ambiguous net effect
- **Dollarization breaks the inflation channel:** In dollarized regimes, neither type of populism can credibly threaten inflation, isolating the pure institutional effect

## Empirical Strategy

**Panel structure:** Firm-year observations from Compustat Global (post-2000)

**Baseline specification:**

```
Cash/Assets(i,c,t) = β₁·LeftPop(c,t)
				   + β₂·(LeftPop × Dollarized)(c,t)
                   + Controls + Firm FE + Year FE + ε(i,c,t)
```

**Identification:**
- **Firm fixed effects:** Control for time-invariant firm characteristics (industry, ownership, business model)
- **Year fixed effects:** Control for global shocks (financial crises, commodity cycles)
- **Country-level clustering:** Conservative standard errors accounting for within-country correlation
- **Wild cluster bootstrap:** Robust inference given finite number of countries

**Key coefficients:**

- **β1:** Net effects of left-populism in non-dollarized countries
- **β2:** Differential effects in dollarized regimes (tests whether inflation channel matters)
- **Critical test:** β1 ≠ β2 confirms differential mechanisms for left vs. right populism

## Data Sources

**Firm-level:**

- Compustat Global (cash/assets ratios, firm controls)
- Worldwide coverage conditional on data availability

**Country-level:**

- V-Party dataset: Populism indices + left-right ideological positioning
- World Bank (WDI/GFD): GDP growth, inflation, financial development indicators
- Dollarization classification: Ecuador, El Salvador, Panama

**Controls:**

- *Firm-level:* Size, profitability, leverage, capex, cash flow volatility
- *Country-level:* GDP growth, actual inflation, credit/GDP, banking crises

## Expected Findings

**Hypotheses:**

1. **Left populism in non-dollarized countries:** Ambiguous sign (competing forces)
2. **Dollarization moderation for left populism:** Positive interaction (removing inflation cost reveals precautionary motive)

## Methodological Approach

**Primary specification:** Country-year panel (collapsed firm means)

- Cleaner given country-level treatment
- Avoids sample dominance issues (US has 30,000+ firms vs. Ecuador ~1,000)
- Asset-weighted aggregation to reflect economic importance

**Robustness checks:**

- Firm-level regressions with equal country weighting
- Nonlinear populism effects (quadratic terms)
- Dynamic specifications (leads/lags to test anticipatory behavior)
- Heterogeneity by firm size, sector, financial constraints
- Separate regional analyses (Latin America, Europe, Asia)

**Software:** STATA

**Policy relevance:**

- Guides corporate strategy under populist regimes
- Informs debates about dollarization/currency unions
- Distinguishes between populist ideologies for investment risk assessment

**Relates to broader literatures:**

- Corporate finance (cash holdings determinants)
- Political economy (populism's economic effects)
- International finance (monetary regime choice)

## Division of Labor

**John G.**

* Download Compustat data

* Relevant Lit Review

* Draft non-empirical sections

  **Nick C.**

* Merge dataset
* Run main regression(s)
* Draft empirical sections

**JP**

* Empirical strategy feedback while busy defending
* Robustness checks
* Draft remaining of the paper