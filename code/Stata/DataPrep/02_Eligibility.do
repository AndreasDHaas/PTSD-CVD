*** Eligibility: $repo/figures/Flowchart.pptx 

	* Persons with insurance coverage between 1 Jan 2011 and 14 Mar 2020: N=1,537,046
		use if start < d(15/03/2020) using "$clean/FUPwide", clear   
		gunique pat 
				
	* Merge baseline characteristics  
		merge 1:1 patient using "$clean/BAS", keep(match) nogen keepusing(birth_d sex afa popgrp) 
		assertunique patient
		count // 1,537,046
		
	* Excluded: 
		
		* Unknown sex: N=9,928
			drop if sex ==3 // unknown sex: 0.6
			di %3.1fc 9928/1537046*100
			
		* Calculate age at end of follow-up 
			gen age_end = floor((end-birth_d)/365.25)
			egen age_end_cat = cut(age_end), at(18,25,35,45,55,65,75,120) label
			tabstat age_end, by(age_end_cat) stats(min max)
			lab define age_end_cat 0 "18-24" 1 "25-34" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65-74" 6 "75+", replace
			lab val age_end_cat age_end_cat 
			
		* Unknown age: N=9,108
			drop if age_end ==. // unknown age: 0.6
			di %3.1fc 9108/1537046*100
			assert inrange(age_end, 0, 100)
			
		* Age below 18 at end of follow-up: N=435,650
			drop if age_end <18 // 
			di %3.1fc 435650/1537046*100
			count 
			global N = `r(N)'
			
		* Merge vital status 
			merge 1:1 patient using "$clean/VITAL", keep(match) keepusing(linked death_d death_y cod2) 
			count if _merge ==3
			assert $N == `r(N)'
			drop _merge 
			macro drop N
			
				
		* Excluded total: 29.6%
			di 9928 + 9108 + 435650
			di %3.1fc 454686/1537046*100
			
	* Included: N=1,082,360 
		assertunique patient
		
	* Excluded + included = total 
		di 454686 + 1082360 
		
	* Compress
		compress
				
*** Censor deaths after end of insurance coverage
	
	* Confirm Ns 
		tab death_y // total deaths: 64,049
		assert death_d !=. if death_y ==1 // no missing death_d
		count if death_y ==1 & death_d > end // death after end of insurance coverage: 26,787
		count if death_y ==1 & death_d <= end // death while insured: 37,262
		di 26787 + 37262 // during & after insurance coverage = total 
	
	* Censor deaths after end of insurance coverage 
		gen censored = 1 if death_y ==1 & death_d > end
		
		* List censored cases  
			*listif patient death_y death_d end cod2 censored if death_y ==1 & death_d > end, id(pat) sort(pat) seed(1)
			list patient death_y death_d end cod2 censored if pat =="B011045487" // censored
		
		* List uncensored cases: plan end date was set to death date for patients who died while under insurance coverage  
			*listif patient death_y death_d end cod2 censored if death_y ==1 & death_d <= end, id(pat) sort(pat) seed(1)
			list patient death_y death_d end cod2 censored if pat =="B007826960" // not censored 
			
		* Overwrite censored death information 
			replace death_y = 0 if censored ==1
			replace death_d = . if censored ==1
			replace cod2 = . if censored ==1
			drop censored 
			
	* Left-truncate data at age 
	
		* Calculate age at start of follow-up 
			gen age_start = floor((start-birth_d)/365.25), before(age_end)
			gen start18 = start, after(start)
			format start18 %tdD_m_CY
			list patient age_start birth_d start start18 end if inlist(patient, "B000000233", "B000000131")
			replace start18 = birth_d + 18 * 365.25 if age_start < 18 
			replace age_start = floor((start18-birth_d)/365.25)
			assert age_start >=18 
			assert start18 < end
			egen age_start_cat = cut(age_start), at(18,25,35,45,55,65,75,120) label
			tabstat age_start, by(age_start_cat) stats(min max)
			lab define age_start_cat 0 "18-24" 1 "25-34" 2 "35-44" 3 "45-54" 4 "55-64" 5 "65-74" 6 "75+", replace
			lab val age_start_cat age_start_cat 
			order age_start_cat, after(age_start)
			
	* Follow-up time, years 
		gen fup = (end-start18)/365.25
			
	* Variable labels 
		lab var patient "Patient identifier"
		lab var start "Start of insurance coverage"
		lab var start18 "Start of insurance coverage or 18th birthday, whichever occurs later"
		lab var end "End of insurance coverage or deaths, whichever occurs first"
		lab var birth_d "Month and year of birth"
		lab var age_start "Age at start18"
		lab var age_end "Age at end"
		lab var age_end_cat "Age at end, categorized"
		lab var death_y "Binary indicator for death"
		lab var death_d "Date of death"
		lab var cod2 "Cause of death: natural/unnatural/unknown"
		lab var age_start_cat "Age at baseline, y" 
		lab var fup "Follow-up time, y" 
		lab var linked "Binary indicator for linkage to NPR"
		
	* Value labels 
		lab define popgrp 9 "Unknown", modify
		lab define death_y 1 "Mortality" 0 "Alive", replace 
		lab val death_y death_y 
		lab define cod2 1 "Natural causes" 2 "Unnatural causes" 4 "Unknown", modify
		
	* Checks 
		foreach var in start start18 end age_start age_start_cat age_end death_y birth_d {
			assert `var' !=. 
		}
		assertunique patient
		assert death_d !=. if death_y ==1
		assert death_d ==. if death_y ==0
		assert cod2 !=. if death_y ==1
		assert cod2 ==. if death_y ==0
		assert start1 < end
		assert inrange(age_start, 18, 100)
		
	* Confirm N 
		count 
		assert `r(N)' == 1082360 
		
	* Compress
		compress