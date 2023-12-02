* Load the common_value_sim.dta file
use "/Users/devynmiller/Downloads/common_value_sim.dta", clear


// Part A: Estimation of Models Using common_value_sim.dta


* Model 1
reg profit x
outreg2 using results.doc, replace ctitle(Model 1)

* Model 2
reg profit x bid
outreg2 using results.doc, append ctitle(Model 2)

* Model 3
reg profit x bid x_0
outreg2 using results.doc, append ctitle(Model 3)




// Part B: Heteroscedasticity Tests
* Bruesch-Pagan test for Model 2
reg profit x bid
estat hettest

* Note: No need for lrtest as models are not nested

* Load the auction_data.xlsx file
import excel "/Users/devynmiller/Downloads/auction data.xlsx", clear

* Proceed with analysis for auction data as necessary



// Part C: Three-Level Model Using auction data.xls

* Load the auction_data.xlsx file
import excel "/Users/devynmiller/Downloads/auction data.xlsx", clear

* Convert string variables to numeric if necessary
destring A B C, replace

* Three level model for forward auctions (Buy)
xtmixed F H G || _all:R.A || _all:R.B || _all:R.C if I == 1
estimates store forward

* Three level model for reverse auctions (Sell)
xtmixed F H G || _all:R.A || _all:R.B || _all:R.C if I == 2
estimates store reverse

* Test the null of the three level model versus the alternative of the joint random slope terms
lrtest forward reverse



