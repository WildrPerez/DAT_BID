********************************************************************************
********************************************************************************
***********************      Data Analysis Test    *****************************
********************************************************************************
********************************************************************************
********************************************************************************

set more off
clear all 

********************       Data Cleaning    ************************************
*-------------------       Importing Data   ------------------------------------

cap log close

log using DAT_project, replace // open log file

** Variable Path 
global user "C:"

** Setting working file 

cd "$user\Users\enriq\Dropbox\Task_BID"

global fuente "$user\Users\enriq\Dropbox\Task_BID"

** Fixed paths
global input "$fuente\Data"
global code  "$fuente\Code"

import excel "$input\Data for Analysis Test.xlsx", sheet("Sheet1") firstrow clear
save "$input\data_1.dta", replace

import excel "$input\Town Names for Analysis Test.xlsx", sheet("Sheet1") firstrow clear
save "$input\data_2.dta", replace
 
*----------------    Merging suplementary database    --------------------------

use "$input\data_1.dta"

merge m:1 town_id using "$input\data_2.dta"
drop _merge
drop if missing(turnout_total)

*----------------    Creating numerical variable to distric  -------------------

encode district, generate(n_dis)
codebook(n_dis)

*----------------------    Creating unique ID ----------------------------------

*label values n_dis
*label values town_id "town_id"

drop if missing(town_id)

egen uniqueid = concat(town_id turnout_total n_dis)
encode uniqueid, generate(id)

*----------------------    Missings check     ----------------------------------

cap ssc install mdesc
mdesc

*----------------------    Creating dummy to town_id ---------------------------

summarize i.town_id
tabulate town_id, generate(dum)


*---------------------------    Labelling   ------------------------------------

label variable town_id   "ID variable" 
label variable TownName  "ID variable" 
label variable n_dis     "ID variable" 
label variable uniqueid  "ID variable" 
label variable district  "ID district variable " 

label variable dum1  "ID variable" 
label variable dum2  "ID variable" 
label variable dum3  "ID variable" 
label variable dum4  "ID variable" 
label variable dum5  "ID variable" 
label variable dum6  "ID variable" 
label variable dum7  "ID variable" 
label variable dum8  "ID variable" 
label variable dum9  "ID variable" 
label variable dum10  "ID variable" 
label variable dum11  "ID variable" 
label variable dum12  "ID variable" 
label variable dum13  "ID variable" 
label variable dum14  "ID variable" 
label variable dum15  "ID variable" 
label variable dum16  "ID variable" 
label variable dum17  "ID variable" 
label variable dum18  "ID variable" 
label variable dum19  "ID variable" 
label variable dum20  "ID variable" 
label variable dum21  "ID variable" 
label variable dum22  "ID variable" 
label variable dum23  "ID variable" 
label variable dum24  "ID variable" 
label variable dum25  "ID variable" 
label variable dum26  "ID variable" 
label variable dum27  "ID variable" 

label variable turnout_total     "Electoral data" 
label variable turnout_male      "Electoral data" 
label variable turnout_female    "Electoral data" 
label variable registered_total  "Electoral data" 
label variable registered_male   "Electoral data" 
label variable registered_female "Electoral data" 

label variable treatment     		"Intervention" 
label variable treatment_phase      "Intervention" 
label variable take_up    			"Intervention" 

label define treatment1 0 "Control Group 1" 1 "Experimental Group 1" , replace
label values treatment treatment1  
	
label define treatment2 1 "Phase 1" 2 "Phase 2", replace
label values treatment_phase treatment2  

label define treatment3 0 "No campaing" 1 "Campaing", replace
label values take_up treatment3  

********************       Descriptive Statistic    ****************************

* 9.- We obtain the mean, highet and lowest as follows:
sum turnout_total

* 10.- 
tab treatment treatment_phase

* 11.- 
tab district  if turnout_total >= 0.75, sum(turnout_female)

* 12.- 
tab treatment, sum(turnout_female)

*  The following command tests the null hypothesis that the mean of average turnout rate for females is the same for treateds and controls: 

ttest turnout_female, by(treatment)

* A t-statistic for assessing that hypothesis is -4.9. The p-value for the two-sided alternative
* (middle panel beneath the table) is very high, beneath 1.000. Because the p value is very
* high, we could not reject the assertion that the group means are equal, at any
* plausible significance level that we might select.

* 13.- 

tab treatment, sum(turnout_female)
tab treatment, sum(turnout_male)
tab treatment, sum(turnout_total)

global varlist turnout_female turnout_male turnout_total

graph bar (mean) turnout_total, over(treatment) ///
title("Total") ///
ytitle("Average") yscale(range(450 (10) 480)) /// 
ylab(, nogrid) graphregion(color(white)) plotregion(icolor(none)) ///
saving(graph_1.gph, replace)

graph bar (mean) turnout_male, over(treatment) ///
title("Male") ///
ytitle("Average") yscale(range(250 (1) 255)) /// 
ylab(, nogrid) graphregion(color(white)) plotregion(icolor(none)) ///
saving(graph_2.gph, replace)

graph bar (mean) turnout_female, over(treatment) ///
title("Female") ///
ytitle("Average") yscale(range(200 (5) 220)) /// 
ylab(, nogrid) graphregion(color(white)) plotregion(icolor(none)) ///
saving(graph_3.gph, replace)

graph combine   ///
graph_3.gph   ///
graph_2.gph   ///
graph_1.gph, rows(2) altshrink ///
title("Average turnout in treatment and control groups, by gender", size(medium)) graphregion(color(white)) saving(aic.gph, replace) ///
note("Source: Data Task") 

*************************       Regression Part   ******************************

teffects ra (turnout_total town_id n_dis registered_total registered_male registered_female id dum27 dum26 dum25 dum24 dum23 dum22 dum21 dum20 dum19 dum18 dum17 dum16 dum15 dum14 dum13 dum12 dum11 dum1 dum2 dum3 dum4 dum5 dum6 dum7 dum8 dum9 dum10, linear noconstant) (treatment)


*************************       Instrumental Variables   ***********************

*-------------------------------------------------------------------------------

save DAT_project, replace
log close




