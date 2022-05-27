*** HIV 
	
* Diagnoses 
	fdiag hivDiag using "$clean/ICD10_HIV" if regexm(icd10_code, "B2[0-4]") | regexm(icd10_code, "Z21") | regexm(icd10_code, "R75") | regexm(icd10_code, "O98.7") ///
											| regexm(icd10_code, "C85.9"),  mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') n y censor(end)
														
* Medication									    PIs | NNRTIs | NRTIs|                   IIs    |        ARV combinations   &  NOT     TDF/FTC  |   TAF     |   FTC   |    3TC  (used in PrEP)    
	fdrug hivMed using "$clean/MED_ATC_J" ///
										if ((regexm(med_id, "J05A[E-G]") |  regexm(med_id, "J05AF") |  regexm(med_id, "J05AR")) & !inlist(med_id, "J05AR03", "J05AF13", "J05AF09", "J05AF05")), /// 
										mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') n y censor(end)	
										
* Laboratory tests 
		
	* HIV viral load test 
		flab rna using "$clean/HIV_RNA" if lab_id =="HIV_RNA" & lab_v !=., mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') n y censor(end)
				
	* CD4 count or percent 
		flab cd4 using "$clean/CD4" if lab_v !=.,  mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') n y censor(end)
				
	* Positive HIV test: todo remove screening tests 
		flab hivPos using "$clean/HIV_TEST" if lab_id =="HIV_TEST" & lab_v ==1,  mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') n y censor(end)
				
* HIV definitions 
		
	* Version 1: low certainty 
			
		* Generate variables 
			egen hiv1_n = rowtotal(hivDiag_n hivMed_n rna_n cd4_n hivPos_n afa) 
			egen hiv1_d = rowmin(hivDiag_d hivMed_d rna_d cd4_d hivPos_d) 
			format hiv1_d %tdD_m_CY
			egen hiv1_y = rowmax(hivDiag_y hivMed_y rna_y cd4_y hivPos_y afa)
		
		* Checks 
			assert inrange(hiv1_d, `=d(01/01/2011)', `=d(01/07/2020)') if hiv1_d !=. 
			assert inlist(hiv1_y, 0, 1)
			assert hiv1_y == 1 if hiv1_d !=.
			count if hiv1_d ==. & hiv1_y == 1 // !!! AfA members wihtout other HIV indicator have missing hiv_d !!! 
			replace hiv1_d = start if hiv1_d ==. & hiv1_y==1 // set HIV positive date to start of follow-up
			assert hiv1_d ==. if hiv1_y == 0	
			
			
* Clean 
	drop hivDiag_d hivDiag_n hivDiag_y hivMed_d hivMed_n hivMed_y rna_d rna_n rna_y cd4_d cd4_n cd4_y hivPos_d hivPos_n hivPos_y hiv1_n
	
* Label 
	lab var hiv1_d "Date of first HIV indicator"
	lab var hiv1_y "Binary indicator for positive HIV status"
	lab define hiv1_y 1 "HIV", replace 
	lab val hiv1_y hiv1_y