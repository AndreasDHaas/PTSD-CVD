*** Prepare tables for case definitions 

	* Append tables with mental health diagnoses 
		use "$clean/ICD10_F", clear
		append using "$clean/ICD10_R"
		sort patient icd10_date
		save "$clean/ICD10_F_R", replace
		
	* Append tables with sleep disorder diagnoses 
		use "$clean/ICD10_F", clear
		append using "$clean/ICD10_G"
		sort patient icd10_date
		keep if regexm(icd10_code, "F51") | regexm(icd10_code, "G47")
		save "$clean/ICD10_F_G", replace
	
	* Append tables with diabetes diagnoses  
		use "$clean/ICD10_E", clear
		append using "$clean/ICD10_G" 
		append using "$clean/ICD10_H00-H59"
		append using "$clean/ICD10_M"
		save "$clean/ICD10_DM", replace
		
	* Append CD4 count and CD4 percent tables  
		use "$clean/CD4_A", clear 
		append using "$clean/CD4_P"
		sort patient lab_d
		save "$clean/CD4", replace
			
	* Append tables with HIV diagnoses 
		use "$clean/ICD10_AB", clear
		append using "$clean/ICD10_Z"
		append using "$clean/ICD10_R"
		append using "$clean/ICD10_O"
		append using "$clean/ICD10_C00-D49"
		save "$clean/ICD10_HIV", replace
		
	* Append tables with hypertension diagnoses 
		use "$clean/ICD10_H00-H59", clear
		append using "$clean/ICD10_I"
		save "$clean/ICD10_HT", replace
		
	* Append tables with mental health diagnoses 
		use "$clean/ICD10_F", clear
		append using "$clean/ICD10_R"
		sort patient icd10_date
		save "$clean/ICD10_F_R", replace
		
	* Append tables with stroke diagnoses and stoke mimicks 
		clear 
		foreach t in AB G I C00-D49 {
			qui append using "$clean/ICD10_`t'"
		}
		save "$clean/ICD10_stroke", replace 