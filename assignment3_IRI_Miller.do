// Part A: Hypothesis tests evaluating models 1 vs 2, 1 vs 3, and 2 vs 3.

use "/Users/devynmiller/Downloads/common_value_sim.dta", clear
generate x_N6 = x * N6
generate x_eps24 = x * eps24
* Clear any existing data, load  dataset, create interaction terms for analysis.

* Model 1: Comprehensive Regression with Interaction Terms
* This regression includes all predictors and their interactions to understand their comprehensive effect on bids.
regress bid x balance x_N6 x_eps24
outreg2 using "\Users\devynmiller\Downloads\regression.doc", replace
* Results are exported for comparison and documentation purposes.

* Model 2: Regression Excluding Interaction Terms
* This model tests the direct effect of 'x' and 'balance' on 'bid', omitting interaction terms for simpler interpretation.

regress bid x balance
outreg2 using "\Users\devynmiller\Downloads\regression.doc", append






// Part B:  Bruesch-Pagan hypothesis test and Goldfeld-Quandt tests

* The Breusch-Pagan test follows to check for heteroskedasticity in this model.
estat hettest  
* Null hypothesis: Variances are homoscedastic. We will fail to reject this null if we get a high p-value (>0.05).

* Model 3: Regression with Only 'x' as the Predictor
* This model isolates the impact of the 'x' variable on the 'bid', simplifying the analysis to its most basic form.
regress bid x
outreg2 using "\Users\devynmiller\Downloads\regression.doc", append
* Results appended to the same document for comparative analysis.

* Goldfeld-Quandt Test for Model 1
* This test assesses heteroskedasticity specifically in Model 1, using 'eps24' as a grouping variable.
reg bid x balance x_N6 x_eps24 if eps24
scalar sigma2_high = e(rss) / e(df_r)
scalar df_high = e(df_r)
reg bid x balance x_N6 x_eps24 if !eps24
scalar sigma2_low = e(rss) / e(df_r)
scalar df_low = e(df_r)
scalar F = sigma2_high / sigma2_low
di Ftail(df_high, df_low,F)
* Null hypothesis: Variances between groups (high and low 'eps24') are equal. P > 0.05 means we fail to reject the null (that there is no heteroscedasticity).






* Part C: Three-Level Model for Auction Data

* Clearing existing data to import new dataset for Part C of the assignment.
clear
import excel "/Users/devynmiller/Downloads/auction data.xlsx", sheet("auction data") firstrow
generate N6 = (NumInGroup == 6)
generate v_N6 = VALUECOST * N6

* Estimating a Three-Level Model and a Model with Random Slopes
* First, a standard three-level model is estimated to understand the basic hierarchical structure.
xtmixed BID VALUECOST v_N6 || Session: || Subject:
est store three_level
* Then, a more complex model with random slopes is estimated to see if individual-level variations in Value/Cost and number of bidders significantly improve the model.
xtmixed BID VALUECOST v_N6 || Session: || Subject:VALUECOST || Subject:N6
est store random_slope

* LR Test to Compare Models
* This test compares the two nested models to determine if the more complex model (random_slope) provides a significantly better fit than the simpler model (three_level).
lrtest three_level random_slope
* Null hypothesis: The simpler model is sufficient. A low p-value (<0.05) means we reject the null in favor of the more complex model.
