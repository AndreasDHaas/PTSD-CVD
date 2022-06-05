*** Prepare dataset for survival analysis 

* AnalyseWide 
	use "$clean/analyseWide", clear
		
* List of variables to be split at event dates 
	// global tvc "mve1 dm1 dl1 hiv1 ht1 mhd1 org1 su1 psy1 mood1 anx1 omd1 alc1 drug1 bp1 dep1 omood1 gad1 ptsd1 ad1 oad1"
	global tvc "mve1 dm1 dl1 hiv1 ht1 mhd1 org1 su1 psy1 mood1 anx1 omd1 ptsd1 othanx1 tobacco1 sleep1"

* Checks 
		
	* Start, end & patient ID 
		assert patient !=""
		assertunique patient
		assert start18 !=.
		assert end !=. 
		assert start18 < end
	
	* Death 
		assert death_y !=. 
		assert death_d !=. if death_y ==1
		assert death_d ==. if death_y ==0
	
	* Check consistency of _d and _y variables for of tvc 
		foreach var in $tvc {
			assert `var'_y !=. 
			assert `var'_y ==0 if `var'_d ==.
			assert `var'_y ==1 if `var'_d !=.
		}
		
	* Total follow-up time, y
		total fup // (end-start18)/365.25
		global fup = e(b)[1,1]
		di %16.0fc $fup // 4,118,256
		gen byte f=0
		stset end, failure(f==1) enter(start18) scale(365.25) 			
		gen fup_y = (_t-_t0) 
		total fup_y // estimated using stset 
		global fup_y = e(b)[1,1]
		di %16.2fc $fup_y // 4,118,255.65
		assert $fup == $fup_y 
			
	* Total person-time of patients with PTSD, y
		gen ptsd_fup = (end - ptsd1_d)/365.25
		replace ptsd_fup = (end-start18)/365.25 if ptsd1_d < start18 // left-truncate at 18th birthday 
		total ptsd_fup 
		global ptsd_fup = e(b)[1,1]
		di %16.2fc $ptsd_fup // 44,994.73
		*list patient start18 ptsd1_d ptsd_fup if inlist(patient, "B002178232", "B003860756", "B004373540")
			
	* Total person-time of patients after major vascular event, y
		gen mve_fup = (end - mve1_d)/365.25
		replace mve_fup = (end-start18)/365.25 if mve1_d < start18 // left-truncate at 18th birthday 
		total mve_fup 
		global mve_fup = e(b)[1,1]
		di %16.2fc $mve_fup // 143,558.56
			
	* Save dataset with person-time exposed and under follow-up
		preserve 
		keep patient fup fup_y ptsd_fup mve_fup start18 end ptsd1_d mve1_d
		save "$temp/personTime", replace
		restore
			
/* Example showing use of splittvc: split at PTSD diagnosis (ptsd1_d)
				
	* Example cases 
			
		* PTSD diagnosis on start date  
			listif patient start18 end ptsd1_* if ptsd1_d == start18, id(patient) sort(patient start18) seed(1) n(1) global(eos)
			list patient start18 ptsd1_d if inlist(patient, $eos), sepby(patient)
						
		* PTSD diagnosis on end date
			listif patient start18 end ptsd1_* if ptsd1_d == end, id(patient) sort(patient start18) seed(1) n(1) global(eoe) 
			list patient end ptsd1_d if inlist(patient, $eoe), sepby(patient)
			
		* PTSD diagnosis between start and end date 
			listif patient start18 end ptsd1_* if ptsd1_d > start & ptsd1_d < end & dep1_y ==1, id(patient) sort(patient start18) seed(1) n(1) global(ebse) 
			list patient start end ptsd1_d if inlist(patient, $ebse), sepby(patient)		
			
		* No PTSD diagnosis 
			listif patient start18 end ptsd1_* if ptsd1_y ==0, id(patient) sort(patient start18) seed(1) n(1) global(ne) 
			list patient start end ptsd1_d if inlist(patient, $ne), sepby(patient)	
		
	* Split at PTSD diagnosis
		splittvc patient start18 end ptsd1_d ptsd1_y, listid($eos, $eoe, $ebse, $ne) nolab 		
			
*/ 
			
* Split time-varing variabes specified in $tvc 
	foreach var in $tvc {
			
		* Example cases:  
			listif patient start18 end `var'_d `var'_y  if `var'_d == start18, id(patient) sort(patient start18) seed(1) n(1) global(eos) nolab // events on start18 
			listif patient start18 end `var'_d `var'_y  if `var'_d == end, id(patient) sort(patient start18) seed(1) n(1) global(eoe) nolab // events on end 
			listif patient start18 end `var'_d `var'_y  if `var'_d > start & `var'_d < end & `var'_y ==1, id(patient) sort(patient start18) seed(1) n(1) global(ebse) nolab // event between start and end 
			listif patient start18 end `var'_d `var'_y  if `var'_y ==0, id(patient) sort(patient start18) seed(1) n(1) global(ne) nolab // no event 
			
		* Split at PTSD diagnosis
				splittvc patient start18 end `var'_d `var'_y, listid($eos, $eoe, $ebse, $ne) nolab 	
			
	}
		
* Split follow-up time by age_group 
	
	* Stslit ignores gaps in follow-up if option id() is specified. Use fake id identifying each observation instead
		sort patient start18 
		gen fid = _n
		assert f ==0
					
	* Stset 
		stset end, failure(f==1) enter(start18) origin(birth_d) scale(365.25) id(patient)
		format _origin %tdD_m_CY
		list patient start start18 end _t0 _t _d _origin _st ptsd1_y_tvc ptsd1_d if inlist(patient, "B000000316", "B000032442", "B000000369", "B000000131", "B000001031"), sepby(patient ptsd1_y_tvc)
		assert inrange(_t0, 18, 100)
		stsplit age, at(25 35 45 55 65 75)
		* age
		recode age (0=0) (25=1) (35=2) (45=3) (55=4) (65=5) (75=6), test
		lab var age "Age (time-varying)"
		lab define age 0 "18-24" 1 "25-34" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65-74" 6 "75+", replace
		lab val age age
		list fid patient age start start18 end _t0 _t _d _origin _st ptsd1_y_tvc ptsd1_d if inlist(patient, "B000000316", "B000032442", "B000000369", "B000000131", "B000001031"), sepby(patient ptsd1_y_tvc)
		assert age !=. 
		* update start18: stsplit is updating _t0 _t _d and end but not start <- update start based on _origin and _t0
		replace start18 = _origin + _t0*365.25 
		drop fid f
	
* Split by calendar year 
	
	* Generate fake id	& dummy event
		sort patient start18 
		gen fid = _n
		gen f =0
	
	* Stset 
		stset end, failure(f==1) id(fid) enter(start18) origin(time d(01/01/2011)) 
		list patient age start18 end _t0 _t _d _st if inlist(patient, "B000000131"), sepby(pat) 
		*stsplit year, at(365 731 1096 1461 1826 2192 2557 2922 3287 3653 4018 4383 4748 5114) // every 365 or 366 days for leap years (2012, 2016, 2020)
		stsplit year, at(1096 2192 3287) // 2011-2013, 2014-2016, 2017-2019, and 2020-2023 // split at beginning of 2014, 2017, and 2020
		* year
		replace year = round(2011 + year/365)
		lab define year 2011 "2011-2013" 2014 "2014-2016" 2017 "2017-2019" 2020 "2020"
		lab val year year
		* update start18
		replace start18 = d(01/01/2011) + _t0
		list patient age year start18 end _t0 _t _d _st if inlist(patient, "B000000131"), sepby(pat)  
		drop start fid f

* Confirm follow-up time & exposure time
	
	* Total follow-up time, y
		gen f=0
		stset end, failure(f==1) enter(start18) scale(365.25) 			
		gen fup1_y = (_t-_t0) 
		total fup1_y  
		global fup1_y = e(b)[1,1]
		di %16.2fc $fup1_y // 4,118,255.64
		di %16.2fc $fup_y // 4,118,255.65
		assert float($fup_y) == float($fup1_y)
			
	* Total person-time of patients with PTSD, y
		gen ptsd_fup1 = (end - start18)/365.25 if ptsd1_y_tvc==1
		listif patient start18 end ptsd1_y_tvc ptsd1_d ptsd_fup1 if ptsd1_d !=., sepby(patient) id(patient) sort(patient start18) seed(3) n(5)
		total ptsd_fup1 
		global ptsd_fup1 = e(b)[1,1]
		di %16.2fc $ptsd_fup // 491,243.54
		di %16.2fc $ptsd_fup1 // 491,243.54
		assert float($ptsd_fup) == float($ptsd_fup1)			
			/* identify cases with inconcistent exposure durations 
			preserve 
			bysort patient (start18): egen dep_fup2 = total(dep_fup1) 
			listif patient start18 end dep1_y_tvc dep1_d dep_fup1 dep_fup2 if dep1_d !=., sepby(patient) id(patient) sort(patient start18) seed(3) n(5)
			bysort patient (start18): keep if _n ==1
			keep patient dep_fup2
			merge 1:1 patient using "$temp/personTime", assert(match) nogen
			order patient dep_fup2 dep_fup
			replace dep_fup = 0 if dep_fup ==.
			gen diff = (dep_fup-dep_fup2)*365.25
			list patient start18 end dep1_d dep_fup dep_fup2 diff if diff !=0, header(20)
			restore */
						
	* Total person-time of patients after major vascular event, y
		gen mve_fup1 = (end - start18)/365.25 if mve1_y_tvc==1
		listif patient start18 end mve1_y_tvc mve1_d mve_fup1 if mve1_d !=., sepby(patient) id(patient) sort(patient start18) seed(3) n(5)
		total mve_fup1 
		global mve_fup1 = e(b)[1,1]
		di %16.2fc $mve_fup // 140,267.53
		di %16.2fc $mve_fup1 // 140,267.53
		assert float($mve_fup) == float($mve_fup1)	
		
* Generate time-varing variables for moderate certainty 
	foreach var in ptsd othanx org su psy mood omd mve dm dl hiv ht sleep tobacco { 
		gen byte `var'2_y_tvc = `var'1_y_tvc  
		replace `var'2_y_tvc = 0 if `var'2_d ==.
		*listif start18 end `var'1_d `var'1_y `var'1_n `var'1_y_tvc `var'2_d `var'2_y `var'2_y_tvc if `var'1_d !=. & `var'2_d ==., sepby(patient) id(patient) sort(patient start18) n(1) nolab seed(1)
		*listif start18 end `var'1_d `var'1_y `var'1_n `var'1_y_tvc `var'2_d `var'2_y `var'2_y_tvc if `var'1_d !=. & `var'2_d !=., sepby(patient) id(patient) sort(patient start18) n(1) nolab seed(1)
		assert `var'2_y_tvc == `var'1_y_tvc if `var'2_d !=.
		assert `var'2_y_tvc == 0 if `var'2_d ==.
	}
		
* Generate time-varying variable for death 
	listif patient start18 end death_d death_y if death_y ==1, id(patient) sort(patient start18) seed(5) sepby(patient) nolab n(1) global(died)
	listif patient start18 end death_d death_y if death_y ==0, id(patient) sort(patient start18) seed(1) sepby(patient) nolab n(1) global(alive)
	gen death_y_tvc = death_d == end, after(death_y)
	gunique patient if death_y ==1
	local d = `r(J)'
	count if death_y_tvc ==1
	assert `d'==`r(N)'
	list patient start18 end death_d death_y death_y_tvc if inlist(patient, $died), sepby(patient)
	list patient start18 end death_d death_y death_y_tvc if inlist(patient, $alive), sepby(patient)
	assert death_y_tvc ==0 if death_d ==.
	assert death_y_tvc ==1 if end == death_d
	
* Update time-varing variable for mve
	forvalues j = 1/2 {
		list patient start18 end mve`j'_d mve`j'_y mve`j'_y_tvc if patient =="B001727470", nolab
		replace mve`j'_y_tvc = 1 if end == mve`j'_d & mve`j'_y ==1
		listif patient start18 end mve`j'_d mve`j'_y mve`j'_y_tvc if mve`j'_y ==1, id(patient) sort(patient start18) nolab seed(1) n(5) sepby(patient mve`j'_y_tvc)
		assert mve`j'_y_tvc ==1 if end == mve`j'_d
		bysort patient mve`j'_y_tvc (start18): gen n = _n
		listif patient start18 end mve`j'_d mve`j'_y mve`j'_y_tvc n if mve`j'_y ==1, id(patient) sort(patient start18) nolab seed(1) n(2) sepby(patient mve`j'_y_tvc)
		listif patient start18 end mve`j'_d mve`j'_y mve`j'_y_tvc n if mve`j'_y ==1, id(patient) sort(patient start18) nolab seed(1) n(2) sepby(patient mve`j'_y_tvc)
		count if end != mve`j'_d & n ==1 & mve`j'_y ==1 & mve`j'_y_tvc ==1
		* events on start18 <- set _tvc to 0
		listif patient start18 end mve`j'_d mve`j'_y mve`j'_y_tvc n if end != mve`j'_d & n ==1 & mve`j'_y ==1 & mve`j'_y_tvc ==1, id(patient) sort(patient start18) nolab seed(1) n(2) sepby(patient mve`j'_y_tvc)
		replace mve`j'_y_tvc = 0 if end != mve`j'_d & n ==1 & mve`j'_y ==1 & mve`j'_y_tvc ==1
		assert end == mve`j'_d if n ==1 & mve`j'_y_tvc ==1 
		assert mve`j'_y_tvc ==1 if end == mve`j'_d
		drop n
	}
	
* Final cleaning 
	
	* Clean 
		drop f _st _d _t _t0 fup1_y ptsd_fup1 mve_fup1 ptsd_fup fup_y mve_fup
				
	* Order 
		order patient start start18 end sex popgrp age year ptsd1_y_tvc ptsd1_d mve1_y_tvc mve1_d death_d cod2 death_y_tvc ///
			dm1_y_tvc dm1_d dl1_y_tvc dl1_d hiv1_y_tvc hiv1_d ht1_y_tvc ht1_d ///
			org1_y_tvc org1_d su1_y_tvc su1_d psy1_y_tvc psy1_d anx1_y_tvc mood1_y_tvc mood1_d anx1_y_tvc anx1_d omd1_y_tvc omd1_d ptsd1_y_tvc ptsd1_d othanx1_y_tvc othanx1_d ///
			age_start age_start_cat age_end age_end_cat
				
	* Variable labels 
		lab var start18 "Start of time at risk: time-varying, left-truncated at 18th birthday"
		lab var end "End of time at risk: time-varying"
		lab var death_y_tvc "Time-varying binary variable for death at end"
		lab var dm1_y_tvc "Time-varying binary variable for diabetes between start18 and end"
		lab var dl1_y_tvc "Time-varying binary variable for dyslipidemia between start18 and end"		
		lab var hiv1_y_tvc "Time-varying binary variable for HIV between start18 and end"	
		lab var ht1_y_tvc "Time-varying binary variable for hypertension between start18 and end"	
		lab var su1_y_tvc "Time-varying binary variable for substance use disorder between start18 and end"	
		lab var psy1_y_tvc "Time-varying binary variable for psychotic disorder between start18 and end"	
		lab var anx1_y_tvc "Time-varying binary variable for anxiety disorder between start18 and end"	
		lab var mood1_y_tvc "Time-varying binary variable for mood disorders between start18 and end"	
		lab var ptsd1_y_tvc "Time-varying binary variable for PTSD between start18 and end"
		lab var mve1_y_tvc "Time-varying binary variable for major vascular between start18 and end"			
		lab var fup "Total follow-up time from start18 to end, y"
		lab var age_end_cat "Age at end of follow-up time, categorised"
		lab var year "Year (time-varying), categorised"
		lab var age "Age (time-varying), categorised"
		
	* Value lables
		lab define ptsd1_y_tvc 1 "PTSD", replace 
		lab val ptsd1_y_tvc ptsd1_y_tvc
		lab define mood1_y_tvc 1 "Mood disorder", replace 
		lab val mood1_y_tvc mood1_y_tvc
		lab define org1_y_tvc 1 "Organic mental disorder", replace 
		lab val org1_y_tvc org1_y_tvc
		lab define omd1_y_tvc 1 "Other mental disorder", replace 
		lab val omd1_y_tvc omd1_y_tvc
		lab define othanx1_y_tvc 1 "Other anxiety disorder", replace 
		lab val othanx1_y_tvc
		lab define mhd1_y_tvc 1 "Mental disorder", replace 
		lab val mhd1_y_tvc mhd1_y_tvc
		lab define dm1_y_tvc 1 "Diabetes mellitus", replace 
		lab val dm1_y_tvc dm1_y_tvc		
		lab define dl1_y_tvc 1 "Dyslipidemia", replace 
		lab val dl1_y_tvc dl1_y_tvc		
		lab define ht1_y_tvc 1 "Hypertension", replace 
		lab val ht1_y_tvc ht1_y_tvc	
		lab define hiv1_y_tvc 1 "HIV", replace 
		lab val hiv1_y_tvc hiv1_y_tvc	
		lab define su1_y_tvc 1 "Substance use disorder", replace 
		lab val su1_y_tvc su1_y_tvc		
		lab define psy1_y_tvc 1 "Psychotic disorder", replace 
		lab val psy1_y_tvc psy1_y_tvc			
		lab define anx1_y_tvc 1 "Anxiety disorder", replace 
		lab val anx1_y_tvc anx1_y_tvc	
		lab define mve1_y_tvc 1 "Major cardiovascular event", replace 
		lab val mve1_y_tvc mve1_y_tvc	
		lab define othanx1_y_tvc 1 "Other anxiety disorders", replace 
		lab val othanx1_y_tvc othanx1_y_tvc	
		lab define sleep1_y_tvc 1 "Sleep disorders", replace 
		lab val sleep1_y_tvc sleep1_y_tvc	
		lab define tobacco1_y_tvc 1 "Tobacco use disorders", replace 
		lab val tobacco1_y_tvc tobacco1_y_tvc	
		
		
	* Labels for variables with moderate certainty 
		foreach var in ptsd othanx org su psy mood omd mve dm dl hiv ht sleep tobacco {  
			lab val `var'2_y_tvc `var'1_y_tvc
		}
		
	* Compress 
		compress
		
	* Save 
		save "$clean/analyseSurv", replace
	