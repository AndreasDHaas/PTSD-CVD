*** Major cardiovascular events:  
	
* Version 1: Diagnoses from all levels are considered. Stroke mimics are not considered 
		
	* Ischaemic heart diseases   
				
		* Unstable angina (I20)
			fdiag ua1 using "$clean/ICD10_I" if icd10_code == "I20.0", minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end) 
				
		* Acute myocardial infarction (I21)  
			fdiag stemi1 using "$clean/ICD10_I" if regexm(icd10_code, "I21.[0-3]") | regexm(icd10_code, "I22") , minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end)  // STEMI
			fdiag nstemi1 using "$clean/ICD10_I" if regexm(icd10_code, "I21.4"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end)  // NSTEMI
			fdiag umi1 using "$clean/ICD10_I" if regexm(icd10_code, "I21.9"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end) // unsepcified MI
					
	* Cerebrovascular diseases   
				
		* Stroke 
			fdiag bs1 using "$clean/ICD10_I" if regexm(icd10_code, "I6[0-1]"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end)  // bleeding stroke
			fdiag is1 using "$clean/ICD10_I" if (regexm(icd10_code, "I63") & !regexm(icd10_code, "I63.6")) | regexm(icd10_code,  "H34.1"), ///
													 minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end)  // ischaemic stroke
			fdiag us1 using "$clean/ICD10_I" if regexm(icd10_code, "I64"), minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end)  // unspecified stroke

	* Revascularization prcedures
		fhos revasc1 using "$clean/HOS" if code_type =="CPT" & (inlist(hosp_code , "33503", "33504", "33511", "33512", "33513", "33514", "33516", "33517", "33518") | /// 
										inlist(hosp_code , "33519", "33521", "33522", "33523", "33530", "33533", "33534", "33535", "33536") | /// 
										inlist(hosp_code , "33572", "92920", "92921", "92924", "92929", "92933", "92934", "92937", "92938") | /// 
										inlist(hosp_code , "92941", "92944", "92973", "92980", "92981", "92982", "92984")), ///
										minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end)  // revascularization
												
	* Major vascular event: 49,403 (4.6%) 
		egen mve1_y = rowmax(ua1_y stemi1_y nstemi1_y umi1_y bs1_y is1_y us1_y revasc1_y) 
		tab mve1_y, mi 
		egen mve1_d = rowmin(ua1_d stemi1_d nstemi1_d umi1_d bs1_d is1_d us1_d revasc1_d) 
		format mve1_d %tdD_m_CY
		assert inrange(mve1_d, `=d(01/01/2011)', `=d(01/07/2020)') if mve1_d !=.
				
	* Checks
		assert inlist(mve1_y, 0, 1)
		assert mve1_y ==1 if mve1_d !=.
		assert mve1_d !=. if mve1_y ==1
		assert mve1_d ==. if mve1_y ==0
				
* Version 2: Diagnoses from all levels are considered. Stroke mimics are not excluded

	* Strokes excluding mimicks 
		fdiag bs2 using "$clean/ICD10_stroke" if regexm(icd10_code, "I6[0-1]"), /// bleeding stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///	
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end) listpat(B000742345)
							
		fdiag is2 using "$clean/ICD10_stroke" if (regexm(icd10_code, "I63") & !regexm(icd10_code, "I63.6")) | regexm(icd10_code,  "H34.1"), /// ischaemic stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end) listpat(B012318585) 
													
		fdiag us2 using "$clean/ICD10_stroke" if regexm(icd10_code, "I64"),  /// unspecified stroke
			notif(A06.6 A17 A52.[1-3] A54.8 A81.2 B00.3 B01.0 B02.1 B37.5 B38.4 B43.1 B45.1 B45.9 B58.2 B58.9 B69.0 B90.0 G0[0-7] G09 C70-7[2] C79.3) ///
			minage(18) y n mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') censor(end)  listpat(B012318585) 
		
	* Major vascular event: 49,403 (4.6%) 
		egen mve2_y = rowmax(ua1_y stemi1_y nstemi1_y umi1_y bs2_y is2_y us2_y revasc1_y) 
		tab mve2_y, mi 
		egen mve2_d = rowmin(ua1_d stemi1_d nstemi1_d umi1_d bs2_d is2_d us2_d revasc1_d) 
		format mve2_d %tdD_m_CY
		assert inrange(mve2_d, `=d(01/01/2011)', `=d(01/07/2020)') if mve2_d !=.
				
	* Checks  
		assert inlist(mve2_y, 0, 1)
		assert mve2_y ==1 if mve2_d !=.
		assert mve2_d !=. if mve2_y ==1
		assert mve2_d ==. if mve2_y ==0
		assertunique patient	
		
	* Compress
		compress
		
	* Clean 
		drop ua1_n stemi1_n nstemi1_n umi1_n bs1_n is1_n us1_n revasc1_n bs2_n is2_n us2_n
		
	* Variable labels 
		lab var ua1_d "Date of first unstable angina diagnosis"
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
		lab var mve1_d "Date of first major vascular event"
		lab var mve1_y "Binary indicator for major vascular event"		
		lab var bs2_d "Date of first hemorrhagic stroke, excluding mimicks"
		lab var bs2_y "Binary indicator for hemorrhagic stroke, excluding mimicks"		
		lab var is2_d "Date of first ischaemic stroke, excluding mimicks"
		lab var is2_y "Binary indicator for ischaemic stroke, excluding mimicks"		
		lab var us2_d "Date of first unspecified stroke, excluding mimicks"
		lab var us2_y "Binary indicator for unspecified stroke, excluding mimicks"			
		lab var mve2_d "Date of first major vascular event, excluding mimicks"
		lab var mve2_y "Binary indicator for major vascular event, excluding mimicks"
		
	* Value labels 
		lab define mve2_y 1 "Major vascular event", replace 
		lab val mve2_y mve2_y
		lab define mve1_y 1 "Major vascular event", replace 
		lab val mve1_y mve1_y
		lab define ua1_y 1 "Unstable angina", replace 
		lab val ua1_y ua1_y
		lab define stemi1_y 1 "STEMI", replace 
		lab val stemi1_y stemi1_y
		lab define nstemi1_y 1 "NSTEMI", replace 
		lab val nstemi1_y nstemi1_y
		lab define umi1_y 1 "Unspecified MI", replace 
		lab val umi1_y umi1_y
		lab define bs2_y 1 "Hemorrhagic stroke", replace 
		lab val bs2_y bs2_y
		lab define is2_y 1 "Ischaemic stroke", replace 
		lab val is2_y is2_y
		lab define us2_y 1 "Unspecified stroke", replace 
		lab val us2_y us2_y
		lab define revasc1_y 1 "Revascularization", replace 
		lab val revasc1_y revasc1_y