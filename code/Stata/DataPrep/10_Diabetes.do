*** Diabetes mellitus (DM)
		
* Diagnoses
	fdiag dmDiag using "$clean/ICD10_DM" if regexm(icd10_code, "E1[0-4]") | regexm(icd10_code, "G59.0") | regexm(icd10_code, "G63.2") | regexm(icd10_code, "G99.0")  ///
										  | regexm(icd10_code, "H28.0")   | regexm(icd10_code, "H36.0")   | regexm(icd10_code, "M14.2") | regexm(icd10_code, "M14.6"), ///
										  mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end)

* Medications
	fdrug dmMed using "$clean/MED_ATC_A" if regexm(med_id, "^A10"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
		
* Laboratory results 
		
	* HBA1C
		flab hba1c using "$clean/HBA1C" if lab_id == "HBA1C" & lab_v >= 48, mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
		
	* Fasting blood glucose
		flab fast using "$clean/BGLUC_FAST" if lab_id == "BGLUC_FAST" & lab_v >=7, mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
 
	* Random blood glucose
		flab ran using "$clean/BGLUC_RAN" if lab_id == "BGLUC_RAN" & lab_v >= 11.1, mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) 
					
* DM definitions 
	
	* Version 1: low certainty 
	
		* Generate variables 
			egen dm1_n = rowtotal(dmDiag_n dmMed_n hba1c_n fast_n ran_n)
			egen dm1_d = rowmin(dmDiag_d dmMed_d hba1c_d fast_d ran_d)
			format dm1_d %tdD_m_CY
			egen dm1_y = rowmax(dmDiag_y dmMed_y hba1c_y fast_y ran_y)
			tab dm1_y, mi
			
		* Checks 
 			assert inrange(dm1_d, `=d(01/01/2011)', `=d(15/03/2020)')  if dm1_d !=. 
			assert inlist(dm1_y, 0, 1)
			assert dm1_y == 1 if dm1_d !=.
			assert dm1_d !=. if dm1_y == 1
			
	* Version 2: moderate certainty
		foreach var in dm {
			gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
			format `var'2_d %tdD_m_CY
			gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
			listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
			lab val `var'2_y `var'1_y
		}
			
* Clean 
	drop dmDiag_d dmDiag_n dmDiag_y dmMed_d dmMed_n dmMed_y hba1c_d hba1c_n hba1c_y fast_d fast_n fast_y ran_d ran_n ran_y dm1_n
	
* Label 
	lab var dm1_d "Date of first diabetes indicator: low certainty"
	lab var dm1_y "Binary indicator for diabetes: low certainty"
	lab define dm1_y 1 "Diabetes mellitus", replace 
	lab val dm1_y dm1_y
	lab var dm2_d "Date of first diabetes indicator: moderate certainty"
	lab var dm2_y "Binary indicator for diabetes: moderate certainty"
	lab define dm2_y 1 "Diabetes mellitus", replace 
	lab val dm2_y dm2_y