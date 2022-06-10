*** Major adverse cardiovascular event: https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-021-01440-5
	
* Version 1: low certainty (excluding stroke mimicks)
				
	* Acute myocardial infarction (I21)  
		fdiag stemi1 using "$clean/ICD10_I" if regexm(icd10_code, "^I21.[0-3]") | regexm(icd10_code, "^I22") , minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // STEMI
		fdiag nstemi1 using "$clean/ICD10_I" if regexm(icd10_code, "^I21.4"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // NSTEMI
		fdiag umi1 using "$clean/ICD10_I" if regexm(icd10_code, "^I21.9"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) // unsepcified MI
			
	* Strokes excluding mimicks 
		fdiag bs1 using "$clean/ICD10_stroke" if regexm(icd10_code, "^I6[0-1]"), /// bleeding stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///	
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) listpat(B000742345)
								
		fdiag is1 using "$clean/ICD10_stroke" if (regexm(icd10_code, "^I63") & !regexm(icd10_code, "^I63.6")) | regexm(icd10_code,  "^H34.1"), /// ischaemic stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) listpat(B012318585) 
													
		fdiag us1 using "$clean/ICD10_stroke" if regexm(icd10_code, "^I64"),  /// unspecified stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  listpat(B012318585) 
			
	* Unstable angina (I20)
		fdiag ua1 using "$clean/ICD10_I" if (icd10_code == "I20.0" & source ==3), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)

	* Revascularization prcedures
		fhos revasc1 using "$clean/HOS" if code_type =="CPT" & (inlist(hosp_code , "33503", "33504", "33511", "33512", "33513", "33514", "33516", "33517", "33518") | /// 
										inlist(hosp_code , "33519", "33521", "33522", "33523", "33530", "33533", "33534", "33535", "33536") | /// 
										inlist(hosp_code , "33572", "92920", "92921", "92924", "92929", "92933", "92934", "92937", "92938") | /// 
										inlist(hosp_code , "92941", "92944", "92973", "92980", "92981", "92982", "92984")), ///
										minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  
										
	* Heart failure 
		fdiag hf1 using "$clean/ICD10_I" if regexm(icd10_code, "^I11.0") | regexm(icd10_code, "^I50") | regexm(icd10_code, "^I97.1"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  
		
* Two-point MACE outcome: MI or stroke	

	* Generate variable 
		egen mac2e1_n = rowtotal(stemi1_n nstemi1_n umi1_n bs1_n is1_n us1_n) 
		egen mac2e1_y = rowmax(stemi1_y nstemi1_y umi1_y bs1_y is1_y us1_y) 
		tab mac2e1_y, mi 
		egen mac2e1_d = rowmin(stemi1_d nstemi1_d umi1_d bs1_d is1_d us1_d) 
		format mac2e1_d %tdD_m_CY
		assert inrange(mac2e1_d, `=d(01/01/2011)', `=d(15/03/2020)') if mac2e1_d !=.
				
	* Checks  
		assert inlist(mac2e1_y, 0, 1)
		assert mac2e1_y ==1 if mac2e1_d !=.
		assert mac2e1_d !=. if mac2e1_y ==1
		assert mac2e1_d ==. if mac2e1_y ==0
		assertunique patient	

* Three-point MACE: MI, stroke, unstable angina/revascularization

	* Generate variable 
		egen mac3e1_n = rowtotal(stemi1_n nstemi1_n umi1_n bs1_n is1_n us1_n ua1_n revasc1_n) 
		egen mac3e1_y = rowmax(stemi1_y nstemi1_y umi1_y bs1_y is1_y us1_y ua1_y revasc1_y) 
		tab mac3e1_y, mi 
		egen mac3e1_d = rowmin(stemi1_d nstemi1_d umi1_d bs1_d is1_d us1_d ua1_d revasc1_d) 
		format mac3e1_d %tdD_m_CY
		assert inrange(mac3e1_d, `=d(01/01/2011)', `=d(15/03/2020)') if mac3e1_d !=.
				
	* Checks  
		assert inlist(mac3e1_y, 0, 1)
		assert mac3e1_y ==1 if mac3e1_d !=.
		assert mac3e1_d !=. if mac3e1_y ==1
		assert mac3e1_d ==. if mac3e1_y ==0
		assertunique patient	

* Four-point MACE: MI, stroke, unstable angina/revascularization or heart failure (HF)

	* Generate variable 
		egen mac4e1_n = rowtotal(stemi1_n nstemi1_n umi1_n bs1_n is1_n us1_n ua1_n revasc1_n hf1_n) 
		egen mac4e1_y = rowmax(stemi1_y nstemi1_y umi1_y bs1_y is1_y us1_y ua1_y revasc1_y hf1_y) 
		tab mac4e1_y, mi 
		egen mac4e1_d = rowmin(stemi1_d nstemi1_d umi1_d bs1_d is1_d us1_d ua1_d revasc1_d hf1_d) 
		format mac4e1_d %tdD_m_CY
		assert inrange(mac4e1_d, `=d(01/01/2011)', `=d(15/03/2020)') if mac4e1_d !=.
				
	* Checks  
		assert inlist(mac4e1_y, 0, 1)
		assert mac4e1_y ==1 if mac4e1_d !=.
		assert mac4e1_d !=. if mac4e1_y ==1
		assert mac4e1_d ==. if mac4e1_y ==0
		assertunique patient
			
* Version 2: moderate certainty (excluding stroke mimicks)
	foreach var in mac2e mac3e mac4e {
		gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
		format `var'2_d %tdD_m_CY
		gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
		listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
		lab val `var'2_y `var'1_y
	}
		
* Clean & label 

	* Compress
		compress
		
	* Variable labels 
		lab var ua1_d "Date of first unstable angina diagnosis: low certainty"
		lab var ua1_y "Binary indicator for unstable angina"
		lab var stemi1_d "Date of first STEMI"
		lab var  stemi1_y "Binary indicator for STEMI"		
		lab var nstemi1_d "Date of first NSTEMI"
		lab var nstemi1_y "Binary indicator for NSTEMI"		
		lab var umi1_d "Date of first unsepcified MI"
		lab var umi1_y "Binary indicator for unsepcified MI"		
		lab var bs1_d "Date of first hemorrhagic stroke"
		lab var bs1_y "Binary indicator for hemorrhagic stroke"		
		lab var is1_d "Date of first ischaemic stroke"
		lab var is1_y "Binary indicator for ischaemic stroke"		
		lab var us1_d "Date of first unspecified stroke"
		lab var us1_y "Binary indicator for unspecified stroke"		
		lab var revasc1_d "Date of first revascularization prcedure"
		lab var revasc1_y "Binary indicator for revascularization prcedure"	
	
		lab var bs1_d "Date of first hemorrhagic stroke, excluding mimicks"
		lab var bs1_y "Binary indicator for hemorrhagic stroke, excluding mimicks"		
		lab var is1_d "Date of first ischaemic stroke, excluding mimicks"
		lab var is1_y "Binary indicator for ischaemic stroke, excluding mimicks"		
		lab var us1_d "Date of first unspecified stroke, excluding mimicks"
		lab var us1_y "Binary indicator for unspecified stroke, excluding mimicks"		
		
		lab var mac2e1_d "Date of first MACE2 event: low certainty"
		lab var mac2e1_y "Binary indicator for MACE2: low certainty"	
		lab var mac2e1_d "Date of first MACE2, excluding mimicks: low certainty"
		lab var mac2e1_y "Binary indicator for MACE2, excluding mimicks: low certainty"
		lab var mac2e2_d "Date of first MACE2, excluding mimicks: moderate certainty"
		lab var mac2e2_y "Binary indicator MACE, excluding mimicks: modearte certainty"
		
	* Value labels 
		forvalues j = 1/2 {
			lab define mac2e`j'_y 1 "MACE 2", replace 
			lab val mac2e`j'_y mac2e`j'_y
			lab define mac3e`j'_y 1 "MACE 3", replace 
			lab val mac3e`j'_y mac3e`j'_y
			lab define mac4e`j'_y 1 "MACE 4", replace 
			lab val mac4e`j'_y mac4e`j'_y
			capture lab define ua`j'_y 1 "Unstable angina", replace 
			capture lab val ua`j'_y ua`j'_y
			capture lab define stemi`j'_y 1 "STEMI", replace 
			capture lab val stemi`j'_y stemi`j'_y
			capture lab define nstemi`j'_y 1 "NSTEMI", replace 
			capture lab val nstemi`j'_y nstemi`j'_y
			capture lab define umi`j'_y 1 "Unspecified MI", replace 
			capture lab val umi`j'_y umi`j'_y
			capture lab define bs`j'_y 1 "Hemorrhagic stroke", replace 
			capture lab val bs`j'_y bs`j'_y
			capture lab define is`j'_y 1 "Ischaemic stroke", replace 
			capture lab val is`j'_y is`j'_y
			capture lab define us`j'_y 1 "Unspecified stroke", replace 
			capture lab val us`j'_y us`j'_y
			capture lab define revasc`j'_y 1 "Revascularization", replace 
			capture lab val revasc`j'_y revasc`j'_y
			capture lab define hf`j'_y 1 "Heart failure", replace 
			capture lab val hf`j'_y hf`j'_y
			
		}