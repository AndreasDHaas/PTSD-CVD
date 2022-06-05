*** Major cardiovascular events:  
	
* Version 0: Diagnoses from all levels are considered. Stroke mimics are not considered 
		
	* Ischaemic heart diseases   
				
		* Unstable angina (I20)
			fdiag ua0 using "$clean/ICD10_I" if icd10_code == "I20.0", minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) 
				
		* Acute myocardial infarction (I21)  
			fdiag stemi0 using "$clean/ICD10_I" if regexm(icd10_code, "I21.[0-3]") | regexm(icd10_code, "I22") , minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // STEMI
			fdiag nstemi0 using "$clean/ICD10_I" if regexm(icd10_code, "I21.4"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // NSTEMI
			fdiag umi0 using "$clean/ICD10_I" if regexm(icd10_code, "I21.9"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) // unsepcified MI
					
	* Cerebrovascular diseases   
				
		* Stroke 
			fdiag bs0 using "$clean/ICD10_I" if regexm(icd10_code, "I6[0-1]"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // bleeding stroke
			fdiag is0 using "$clean/ICD10_I" if (regexm(icd10_code, "I63") & !regexm(icd10_code, "I63.6")) | regexm(icd10_code,  "H34.1"), ///
													 minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // ischaemic stroke
			fdiag us0 using "$clean/ICD10_I" if regexm(icd10_code, "I64"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  // unspecified stroke

	* Revascularization prcedures
		fhos revasc0 using "$clean/HOS" if code_type =="CPT" & (inlist(hosp_code , "33503", "33504", "33511", "33512", "33513", "33514", "33516", "33517", "33518") | /// 
										inlist(hosp_code , "33519", "33521", "33522", "33523", "33530", "33533", "33534", "33535", "33536") | /// 
										inlist(hosp_code , "33572", "92920", "92921", "92924", "92929", "92933", "92934", "92937", "92938") | /// 
										inlist(hosp_code , "92941", "92944", "92973", "92980", "92981", "92982", "92984")), ///
										minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  
												
	* Major vascular event: 49,403 (4.6%) 
		egen mve0_y = rowmax(ua0_y stemi0_y nstemi0_y umi0_y bs0_y is0_y us0_y revasc0_y) 
		tab mve0_y, mi 
		egen mve0_d = rowmin(ua0_d stemi0_d nstemi0_d umi0_d bs0_d is0_d us0_d revasc0_d) 
		format mve0_d %tdD_m_CY
		assert inrange(mve0_d, `=d(01/01/2011)', `=d(15/03/2020)') if mve0_d !=.
				
	* Checks
		assert inlist(mve0_y, 0, 1)
		assert mve0_y ==1 if mve0_d !=.
		assert mve0_d !=. if mve0_y ==1
		assert mve0_d ==. if mve0_y ==0
				
* Version 1: MVE, excluding stroke mimicks (low certainty) 

	* Strokes excluding mimicks 
		fdiag bs1 using "$clean/ICD10_stroke" if regexm(icd10_code, "I6[0-1]"), /// bleeding stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///	
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) listpat(B000742345)
							
		fdiag is1 using "$clean/ICD10_stroke" if (regexm(icd10_code, "I63") & !regexm(icd10_code, "I63.6")) | regexm(icd10_code,  "H34.1"), /// ischaemic stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end) listpat(B012318585) 
													
		fdiag us1 using "$clean/ICD10_stroke" if regexm(icd10_code, "I64"),  /// unspecified stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)  listpat(B012318585) 
		
	* Major vascular event: 49,403 (4.6%) 
		egen mve1_n = rowtotal(ua0_n stemi0_n nstemi0_n umi0_n bs1_n is1_n us1_n revasc0_n) 
		egen mve1_y = rowmax(ua0_y stemi0_y nstemi0_y umi0_y bs1_y is1_y us1_y revasc0_y) 
		tab mve1_y, mi 
		egen mve1_d = rowmin(ua0_d stemi0_d nstemi0_d umi0_d bs1_d is1_d us1_d revasc0_d) 
		format mve1_d %tdD_m_CY
		assert inrange(mve1_d, `=d(01/01/2011)', `=d(15/03/2020)') if mve1_d !=.
				
	* Checks  
		assert inlist(mve1_y, 0, 1)
		assert mve1_y ==1 if mve1_d !=.
		assert mve1_d !=. if mve1_y ==1
		assert mve1_d ==. if mve1_y ==0
		assertunique patient	
		
* Version 2: MVE, excluding stroke mimicks (moderate certainty)
	foreach var in mve {
		gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
		format `var'2_d %tdD_m_CY
		gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
		listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
		lab val `var'2_y `var'1_y
	}
		
* Clean & label 

	* Compress
		compress
		
	* Clean 
		drop ua0_n stemi0_n nstemi0_n umi0_n bs0_n is0_n us0_n revasc0_n bs1_n is1_n us1_n
		
	* Variable labels 
		lab var ua0_d "Date of first unstable angina diagnosis: low certainty"
		lab var ua0_y "Binary indicator for unstable angina"
		lab var stemi0_d "Date of first STEMI"
		lab var  stemi0_y "Binary indicator for STEMI"		
		lab var nstemi0_d "Date of first NSTEMI"
		lab var nstemi0_y "Binary indicator for NSTEMI"		
		lab var umi0_d "Date of first unsepcified MI"
		lab var umi0_y "Binary indicator for unsepcified MI"		
		lab var bs0_d "Date of first hemorrhagic stroke"
		lab var bs0_y "Binary indicator for hemorrhagic stroke"		
		lab var is0_d "Date of first ischaemic stroke"
		lab var is0_y "Binary indicator for ischaemic stroke"		
		lab var us0_d "Date of first unspecified stroke"
		lab var us0_y "Binary indicator for unspecified stroke"		
		lab var revasc0_d "Date of first revascularization prcedure"
		lab var revasc0_y "Binary indicator for revascularization prcedure"		
		lab var bs1_d "Date of first hemorrhagic stroke, excluding mimicks"
		lab var bs1_y "Binary indicator for hemorrhagic stroke, excluding mimicks"		
		lab var is1_d "Date of first ischaemic stroke, excluding mimicks"
		lab var is1_y "Binary indicator for ischaemic stroke, excluding mimicks"		
		lab var us1_d "Date of first unspecified stroke, excluding mimicks"
		lab var us1_y "Binary indicator for unspecified stroke, excluding mimicks"		
		
		lab var mve0_d "Date of first major vascular event: low certainty"
		lab var mve0_y "Binary indicator for major vascular event: low certainty"	
		lab var mve1_d "Date of first major vascular event, excluding mimicks: low certainty"
		lab var mve1_y "Binary indicator for major vascular event, excluding mimicks: low certainty"
		lab var mve2_d "Date of first major vascular event, excluding mimicks: moderate certainty"
		lab var mve2_y "Binary indicator for major vascular event, excluding mimicks: modearte certainty"
		
	* Value labels 
		forvalues j = 0/2 {
			lab define mve`j'_y 1 "Major vascular event", replace 
			lab val mve`j'_y mve`j'_y
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
		}