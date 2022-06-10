*** Obesity (OB) & overweight (OW)
			
* Diagnoses 
	fdiag obDiag using "$clean/ICD10_E_Z" if regexm(icd10_code, "^E66"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) lab("Obesity")
	
* Medication									  
	fdrug obMed using "$clean/MED_ATC_A" if regexm(med_id, "^A08"), mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end)	
	
* BMI 
	flab obBMI using "$clean/WEIGHT_HEIGHT_BMI" if lab_id =="BMI" & lab_v >30 & lab_v !=.,  mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end)
	flab ow1 using "$clean/WEIGHT_HEIGHT_BMI" if lab_id =="BMI" & inrange(lab_v, 25, 30),  mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) labe("Overweight")
	flab bmi using "$clean/WEIGHT_HEIGHT_BMI" if lab_id =="BMI",  mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') n y censor(end) label("BMI data recorded")	
	
* HOS 19. MODIFIERS RELATED TO PHYSICAL STATUS - 0018 BMI > 35 https://www.sajaa.co.za/index.php/sajaa/article/download/2061/2418
	fhos obHos using "$clean/HOS" if code_type =="NRPL" & inlist(hosp_code , "0018"), y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // 

	* Version 1: low certainty 
			
		* Generate variables 
			egen ob1_n = rowtotal(obDiag_n obMed_n obBMI_n obHos_n) 
			egen ob1_d = rowmin(obDiag_d obMed_d obBMI_d obHos_d) 
			format ob1_d %tdD_m_CY
			egen ob1_y = rowmax(obDiag_y obMed_y obBMI_y obHos_y)
		
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
	drop ob1_n
	
* Variable Label 
	lab var ob1_d "Date of first obesity indicator: low certainty"
	lab var ob1_y "Binary indicator for obesity: low certainty"
	
	lab var ob2_d "Date of first obesity indicator: moderate certainty"
	lab var ob2_y "Binary indicator for obesity: moderate certainty"
	
* Value label 
	lab define ob1_y 1 "Obesity", replace 
	lab val ob1_y ob1_y
	lab define ob2_y 1 "Obesity", replace 
	lab val ob2_y ob2_y