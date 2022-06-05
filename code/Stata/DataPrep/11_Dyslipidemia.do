*** Dislipidemia (DL)
			
* Diagnoses 
	fdiag dlDiag using "$clean/ICD10_E" if regexm(icd10_code, "E78.[0-5]"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
				
* Medication
	fdrug dlMed using "$clean/MED_ATC_C" if regexm(med_id, "C10"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
			
* Laboratory results 
	
	* HDL cholesterol
		flab hdl using "$clean/CHOL_HDL" if lab_v < 1, mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
		
	* LDL cholesterol
		flab ldl using "$clean/CHOL_LDL" if lab_v > 4.1, mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
			
	* Total cholesterol
		flab tc using "$clean/CHOL_TOT" if lab_v > 6.2, mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
				
* DL definitions 
		
	* Version 1: low certainty 
			
		* Generate variables 
			egen dl1_d = rowmin(dlDiag_d dlMed_d hdl_d ldl_d tc_d)
			format dl1_d %tdD_m_CY
			egen dl1_n = rowtotal(dlDiag_n dlMed_n hdl_n ldl_n tc_n)
			egen dl1_y = rowmax(dlDiag_y dlMed_y hdl_y ldl_y tc_y)
			tab dl1_y, mi 
					
		* Checks
			assert inrange(dl1_d, `=d(01/01/2011)', `=d(01/07/2020)') if dl1_d !=. 
			assert inlist(dl1_y, 0, 1)
			assert dl1_y == 1 if dl1_d !=.
			assert dl1_d !=. if dl1_y == 1
			assert dl1_d ==. if dl1_y == 0
			
	* Version 2: moderate certainty
		foreach var in dl {
			gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
			format `var'2_d %tdD_m_CY
			gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
			listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
			lab val `var'2_y `var'1_y
		}
			
* Clean 
	drop dlDiag_d dlDiag_n dlDiag_y dlMed_d dlMed_n dlMed_y hdl_d hdl_n hdl_y ldl_d ldl_n ldl_y tc_d tc_n tc_y dl1_n
	
* Label 
	lab var dl1_d "Date of first dyslipidemia indicator: low certainty"
	lab var dl1_y "Binary indicator for dyslipidemia: low certainty"
	lab define dl1_y 1 "Dyslipidemia", replace 
	lab val dl1_y dl1_y
	
	lab var dl2_d "Date of first dyslipidemia indicator: moderate certainty"
	lab var dl2_y "Binary indicator for dyslipidemia: moderate certainty"
	lab define dl2_y 1 "Dyslipidemia", replace 
	lab val dl2_y dl2_y