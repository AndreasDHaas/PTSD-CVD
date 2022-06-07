*** Obesity (OB)
			
* Diagnoses 
	fdiag obDiag using "$clean/ICD10_E_Z" if regexm(icd10_code, "E66") | regexm(icd10_code, "Z71.3"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) lab("Obesity")
	
* Medication									  
	fdrug obMed using "$clean/MED_ATC_A" if regexm(med_id, "A08"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end)	
	

	
	* Version 1: low certainty 
			
		* Generate variables 
			egen ob1_n = rowtotal(obDiag_n obMed_n) 
			egen ob1_d = rowmin(obDiag_d obMed_d) 
			format ob1_d %tdD_m_CY
			egen ob1_y = rowmax(obDiag_y obMed_y)
		
		* Checks 
			assert inrange(ob1_d, `=d(01/01/2011)', `=d(15/03/2020)') if ob1_d !=. 
			assert inlist(ob1_y, 0, 1)
			assert ob1_y == 1 if ob1_d !=.
			assert ob1_d !=. if ob1_y == 1 
			assert ob1_d ==. if ob1_y == 0	
			
	* Version 2: moderate certainty
		foreach var in ob {
			gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
			format `var'2_d %tdD_m_CY
			gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
			listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
			lab val `var'2_y `var'1_y
		}
		
* Clean 
	drop ob_n
	
* Label 
	lab var ob1_d "Date of first obesity indicator: low certainty"
	lab var ob1_y "Binary indicator for obesity: low certainty"
	
	lab var ob2_d "Date of first obesity indicator: moderate certainty"
	lab var ob2_y "Binary indicator for obesity: moderate certainty"