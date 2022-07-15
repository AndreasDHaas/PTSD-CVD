*** Mental disorders 

* Version 1: low certainty 

	* Any mental disorder 
		fdiag mhd1 using "$clean/ICD10_F_R_Z" if regexm(icd10_code, "^F") | regexm(icd10_code, "^R44.[0-3]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') ///
		label("Any mental disorder") censor(end) 
	
	* Top-level categories (F0-F9)
			
		fdiag su1 using "$clean/ICD10_F_R_Z" if regexm(icd10_code, "^F1[0-6]") | regexm(icd10_code, "^F1[8-9]") | regexm(icd10_code, "^Z50.[2-3]") | regexm(icd10_code, "^Z71.[4-5]") ///
		| regexm(icd10_code, "Z72.[1-2]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Substance use disorder") censor(end) // added Z72.1-2
		
		fdiag psy1 using "$clean/ICD10_F_R_Z" if regexm(icd10_code, "^F2") | regexm(icd10_code, "^R44.[0-3]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') ///
		label("Psychotic disorder") censor(end)
		
		fdrug psyMed1 using "$clean/MED_ATC_N" if regexm(med_id, "^N05A"), y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Antipsychotic medication") censor(end)
		
		fdiag mdd1 using "$clean/ICD10_F" if regexm(icd10_code, "^F3[2-3]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Major depressive disorder") censor(end)
		
		fdiag anx1 using "$clean/ICD10_F" if regexm(icd10_code, "^F4[0-8]") & !regexm(icd10_code, "F43.1") & !regexm(icd10_code, "F40.9") & !regexm(icd10_code, "F41.9") & !regexm(icd10_code, "F42.9") & !regexm(icd10_code, "F43.9") & !regexm(icd10_code, "F44.9") & !regexm(icd10_code, "F45.9") & !regexm(icd10_code, "F48.9"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Anxiety disorder") censor(end)
		
		fdiag ptsd1 using "$clean/ICD10_F" if regexm(icd10_code, "^F43.1"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Post-traumatic stress disorder") censor(end)
		
		fdiag sleep1 using "$clean/ICD10_F_G" if regexm(icd10_code, "^F51") | regexm(icd10_code, "^G47"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Sleep disorder") censor(end)
		
				
			
			
	* Variable labels
		foreach d in mhd su psy psyMed mdd anx ptsd sleep {
			if "`d'" == "mhd" local t "mental health (low certainty)" 
			else if "`d'" == "su" local t "substance use disorder (low certainty)" 
			else if "`d'" == "psy" local t "psychotic disorder disorder (low certainty)" 
			else if "`d'" == "psyMed" local t "antipsychotic medication (low certainty)"
			else if "`d'" == "mdd" local t "major depressive disorder (low certainty)" 
			else if "`d'" == "anx" local t "anxiety disorder (low certainty)" 
			else if "`d'" == "ptsd" local t "PTSD (low certainty)" 	
			else if "`d'" == "sleep" local t "sleep disorder (low certainty)" 
				
			else local t "----- MISSING -----"
			
			lab var `d'1_d "Date of first `t' diagnosis"
			lab var `d'1_y "Binary indicator for `t' diagnosis at end"
			lab var `d'1_n "Number of `t' events"
		
		}
		
* Version 2: medium certainty
	
	* Generate variables and assign value labels 
		foreach var in su psy psyMed mdd anx ptsd sleep {
			gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
			format `var'2_d %tdD_m_CY
			gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
			*listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
			lab val `var'2_y `var'1_y
		}
		
	* Variable labels 
		foreach d in su psy psyMed mdd anx ptsd sleep {
			if "`d'" == "su" local t "substance use disorder (moderate certainty)"  
			else if "`d'" == "psy" local t "psychotic disorder disorder (moderate certainty)"
			else if "`d'" == "psyMed" local t "antipsychotic medication (low certainty)"
			else if "`d'" == "mdd" local t "major depressive disorder (moderate certainty)" 
			else if "`d'" == "anx" local t "anxiety disorder (moderate certainty)" 
			else if "`d'" == "ptsd" local t "PTSD (moderate certainty)" 
			else if "`d'" == "sleep" local t "sleep disorder (moderate certainty)" 	
			
			else local t "----- MISSING -----"
			
			lab var `d'2_d "Date of first `t' diagnosis"
			lab var `d'2_y "Binary indicator for `t' diagnosis at end"
		
		}	
		
* Recoded PTSD variable for descriptive tables: PTSD==1, no PTSD==2
	gen ptsd = 2-ptsd1_y 
	lab define ptsd 1 "PTSD" 2 "No PTSD", replace
	lab val ptsd ptsd
	tab ptsd ptsd1_y
	lab var ptsd "Indicator for depression at end of follow-up: PTSD==1, no PTSD==2"
		
* Recoded anxiety variable for descriptive tables: anxiety==1, no anxiety==2
	gen anx = 2-anx1_y 
	lab define anx 1 "Anxiety" 2 "No anxiety", replace
	lab val anx anx
	tab anx anx1_y
	lab var anx "Indicator for anxiety at end of follow-up: anxiety==1, no anxiety==2"	
	
