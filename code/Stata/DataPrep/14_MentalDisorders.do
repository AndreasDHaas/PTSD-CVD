*** Mental disorders 

* Version 1: low certainty 

	* Any mental disorder 
		fdiag mhd1 using "$clean/ICD10_F_R" if regexm(icd10_code, "F") | regexm(icd10_code, "R44.[0-3]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Any mental disorder") censor(end) 
	
	* Top-level categories (F0-F9)
		fdiag org1 using "$clean/ICD10_F" if regexm(icd10_code, "F0"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Organic mental disorder") censor(end)
		fdiag su1 using "$clean/ICD10_F" if regexm(icd10_code, "F1[0-6]") | regexm(icd10_code, "F1[8-9]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Substance use disorder") censor(end)
		fdiag psy1 using "$clean/ICD10_F_R" if regexm(icd10_code, "F2") | regexm(icd10_code, "R44.[0-3]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Psychotic disorder") censor(end)
		fdiag mood1 using "$clean/ICD10_F" if regexm(icd10_code, "F3"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Mood disorder") censor(end)
		fdiag anx1 using "$clean/ICD10_F" if regexm(icd10_code, "F4"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Anxiety disorder") censor(end)
		fdiag omd1 using "$clean/ICD10_F" if regexm(icd10_code, "F[5-9]") & !regexm(icd10_code, "F51", n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Other mental disorders") censor(end)
	
	* Sub-categories 
		
		* F1
			fdiag alc1 using "$clean/ICD10_F" if regexm(icd10_code, "F10"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Alcohol use disorder") censor(end)
			fdiag drug1 using "$clean/ICD10_F" if regexm(icd10_code, "F1[1-6]") | regexm(icd10_code, "F1[8-9]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Drug use disorder") censor(end)
			fdiag tobacco1 using "$clean/ICD10_F" if regexm(icd10_code, "F17"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Tobacco use disorder") censor(end)
		
		* F3
			fdiag bp1 using "$clean/ICD10_F" if regexm(icd10_code, "F31"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Bipolar disorder") censor(end)
			fdiag dep1 using "$clean/ICD10_F" if regexm(icd10_code, "F3[2-3]") | regexm(icd10_code, "F34.1"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Depression") censor(end)
			fdiag omood1 using "$clean/ICD10_F" if regexm(icd10_code, "F3") & ( !regexm(icd10_code, "F31") & !regexm(icd10_code, "F3[2-3]") & !regexm(icd10_code, "F34.1") ) ///
			, n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Other mood disorders") censor(end)
			
		* F4 
			fdiag panic1 using "$clean/ICD10_F" if regexm(icd10_code, "F41.0"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Panic disorder") censor(end) 
			fdiag gad1 using "$clean/ICD10_F" if regexm(icd10_code, "F41.1"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Generalised anxiety disorder") censor(end)
			fdiag ad1 using "$clean/ICD10_F" if regexm(icd10_code, "F41.2"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Mixed anxiety and depressive disorder") censor(end) 	
			fdiag uad1 using "$clean/ICD10_F" if regexm(icd10_code, "F41.9"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Unspecified anxiety disorder") censor(end)
			fdiag asr1 using "$clean/ICD10_F" if regexm(icd10_code, "F43.0") | regexm(icd10_code, "F43.[8-9]"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Acute or severe stress reaction") ///
			censor(end)
			fdiag ptsd1 using "$clean/ICD10_F" if regexm(icd10_code, "F43.1"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Post-traumatic stress disorder") censor(end)
			fdiag adj1 using "$clean/ICD10_F" if regexm(icd10_code, "F43.2"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Adjustment disorder") censor(end)
			fdiag oad1 using "$clean/ICD10_F" if regexm(icd10_code, "F4") & (!regexm(icd10_code, "F41.[0-2]") & !regexm(icd10_code, "F41.9") & !regexm(icd10_code, "F43.[0-2]") & !regexm(icd10_code, "F43.[8-9]")), ///
			n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Other anxiety disorders") censor(end) 
			fdiag othanx1 using "$clean/ICD10_F" if regexm(icd10_code, "F4") & (!regexm(icd10_code, "F43.1") & !regexm(icd10_code, "F41.9") ), ///
			n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Other anxiety disorders") censor(end) 	
			
		* F5 
			fdiag sleep1 using "$clean/ICD10_F_G" if regexm(icd10_code, "F51") | regexm(icd10_code, "G47"), n y mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') label("Sleep disorder") censor(end)
			
	* Variable labels
		foreach d in mhd org su psy mood anx omd alc drug tobacco bp dep omood panic gad ad uad asr ptsd adj oad othanx sleep  {
			if "`d'" == "mhd" local t "mental health (low certainty)" 
			else if "`d'" == "org" local t "organic mental disorder (low certainty)" 
			else if "`d'" == "su" local t "substance use disorder (low certainty)" 
			else if "`d'" == "psy" local t "psychotic disorder disorder (low certainty)" 
			else if "`d'" == "mood" local t "mood disorder (low certainty)" 
			else if "`d'" == "anx" local t "anxiety disorder (low certainty)" 
			else if "`d'" == "ptsd" local t "PTSD (low certainty)" 
			else if "`d'" == "othanx" local t "other anxiety (F4* excl. PTSD and unsp. anxiety)"	
			else if "`d'" == "omd" local t "other mental disorder (low certainty)" 
			else if "`d'" == "sleep" local t "sleep disorder (low certainty)" 
			
			else if "`d'" == "alc" local t "alcohol use disorder (low certainty)" 		
			else if "`d'" == "drug" local t "durg use disorder (low certainty)" 
			else if "`d'" == "tobacco" local t "tobacco use disorder (low certainty)" 
			else if "`d'" == "bp" local t "bipolar disorder (low certainty)" 
			else if "`d'" == "dep" local t "depression (low certainty)" 
			else if "`d'" == "omood" local t "other mood disorder (low certainty)" 
			else if "`d'" == "panic" local t "panic disorder (low certainty)" 
			else if "`d'" == "gad" local t "generalized anxiety disorder (low certainty)" 
			else if "`d'" == "ad" local t "anxiety and depression (low certainty)" 
			else if "`d'" == "uad" local t "unspecified anxiety disorder (low certainty)" 
			else if "`d'" == "asr" local t "acute or severe stress reaction (low certainty)" 
			else if "`d'" == "adj" local t "adjustment disorder (low certainty)" 
			else if "`d'" == "oad" local t "other anxiety disorder disorder (low certainty)" 
			
			else local t "----- MISSING -----"
			
			lab var `d'1_d "Date of first `t' diagnosis"
			lab var `d'1_y "Binary indicator for `t' diagnosis at end"
			lab var `d'1_n "Number of `t' events"
		
		}
		
* Version 2: medium certainty
	
	* Generate variables and assign value labels 
		foreach var in org su psy mood anx omd ptsd othanx sleep alc drug tobacco bp dep omood panic gad ad uad asr adj oad {
			gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
			format `var'2_d %tdD_m_CY
			gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
			*listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
			lab val `var'2_y `var'1_y
		}
		
	* Variable labels 
		foreach d in org su psy mood anx omd ptsd othanx sleep alc drug tobacco bp dep omood panic gad ad uad asr adj oad   {
			if "`d'" == "org" local t "organic mental disorder (moderate certainty)" 
			else if "`d'" == "su" local t "substance use disorder (moderate certainty)" 
			else if "`d'" == "psy" local t "psychotic disorder disorder (moderate certainty)" 
			else if "`d'" == "mood" local t "mood disorder (moderate certainty)" 
			else if "`d'" == "anx" local t "anxiety disorder (moderate certainty)" 
			else if "`d'" == "ptsd" local t "PTSD (moderate certainty)" 
			else if "`d'" == "othanx" local t "other anxiety (moderate certainty)" 	
			else if "`d'" == "omd" local t "other mental disorder (moderate certainty)" 
			
			else if "`d'" == "alc" local t "alcohol use disorder (moderate certainty)" 		
			else if "`d'" == "drug" local t "durg use disorder (moderate certainty)" 
			else if "`d'" == "tobacco" local t "tobacco use disorder (moderate certainty)" 
			else if "`d'" == "bp" local t "bipolar disorder (moderate certainty)" 
			else if "`d'" == "dep" local t "depression (moderate certainty)" 
			else if "`d'" == "omood" local t "other mood disorder (moderate certainty)" 
			else if "`d'" == "panic" local t "panic disorder (moderate certainty)" 
			else if "`d'" == "gad" local t "generalized anxiety disorder (moderate certainty)" 
			else if "`d'" == "ad" local t "anxiety and depression (moderate certainty)" 
			else if "`d'" == "uad" local t "unsepcified anxiety disorder (moderate certainty)" 
			else if "`d'" == "asr" local t "acute or severe stress reaction (moderate certainty)" 
			else if "`d'" == "adj" local t "adjustment disorder (moderate certainty)" 
			else if "`d'" == "oad" local t "other anxiety disorder disorder (moderate certainty)" 
			
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
	
