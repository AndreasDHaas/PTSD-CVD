*** Smoking (SM)
			
* Diagnoses 
	fdiag smDiag using "$clean/ICD10_F_R_Z" if regexm(icd10_code, "F17") | regexm(icd10_code, "Z71.6") | regexm(icd10_code, "Z72.0"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) 
	
	
* Medication:  N07BA drugs used in nicotine dependence									  
	fdrug smMed using "$clean/MED_ATC_N" if regexm(med_id, "N07BA"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end)	
	
	* Version 1: low certainty 
			
		* Generate variables 
			egen sm1_n = rowtotal(smDiag_n smMed_n) 
			egen sm1_d = rowmin(smDiag_d smMed_d) 
			format sm1_d %tdD_m_CY
			egen sm1_y = rowmax(smDiag_y smMed_y)
		
		* Checks 
			assert inrange(sm1_d, `=d(01/01/2011)', `=d(15/03/2020)') if sm1_d !=. 
			assert inlist(sm1_y, 0, 1)
			assert sm1_y == 1 if sm1_d !=.
			assert sm1_d !=. if sm1_y == 1 
			assert sm1_d ==. if sm1_y == 0	
			
	* Version 2: moderate certainty
		foreach var in sm {
			gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
			format `var'2_d %tdD_m_CY
			gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
			listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
			lab val `var'2_y `var'1_y
		}
		
* Clean 
	drop sm1_n
	
* Variabel label 
	lab var sm1_d "Date of first smoking indicator: low certainty"
	lab var sm1_y "Binary indicator for smoking: low certainty"
	
	lab var sm2_d "Date of first smoking indicator: moderate certainty"
	lab var sm2_y "Binary indicator for smoking: moderate certainty"
	
* Value label 
	lab define sm1_y 1 "Smoking", replace 
	lab val sm1_y sm1_y
	lab define sm2_y 1 "Smoking", replace 
	lab val sm2_y sm2_y