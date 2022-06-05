*** Hypertension
		
* Diagnoses 
	fdiag htDiag using "$clean/ICD10_HT" if regexm(icd10_code, "H35.0") | regexm(icd10_code, "I1[0-5]") | regexm(icd10_code, "I67.4"), ///
											y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)
							
* Medication 
	fdrug htMed using "$clean/MED_ATC_C" if regexm(med_id, "C03[A-B]") | regexm(med_id, "C03EA01") | regexm(med_id, "C07[B-D]") | regexm(med_id, "C08G") | regexm(med_id, "C09BA") ///
										| regexm(med_id, "C09DA") | regexm(med_id, "C09DX01") | regexm(med_id, "C09DX03") | regexm(med_id, "C09DX06") | regexm(med_id, "C09XA52") ///
										| regexm(med_id, "C09XA54") | regexm(med_id, "C10BX13"), y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)
			
* Clinical results
	flab sbp using "$clean/BPS" if lab_id =="sbp" & lab_v >=140, y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)
	flab dbp using "$clean/BPD" if lab_id =="dbp" & lab_v >=90,  y n mindate(`=d(01/01/2011)') maxdate(`=d(15/03/2020)') censor(end)
			
* Hypertension definitions 
		
	* Version 1: low certainty 
			
		* Generate variables: Restrict to at least two clinical results at different dates or one clinical result plus medication and/or diagnosis 
			egen ht1_n = rowtotal(htDiag_n htMed_n sbp_n dbp_n)
			gen sbp =.
			gen dbp=.
			replace sbp = 1 if (sbp_y==1 & ht1_n>=2 &!missing(ht1_n))
			replace sbp = . if (ht1_n==2 & sbp_n==1 & dbp_n==1 & sbp_d==dbp_d)
			replace dbp = 1 if (dbp_y==1 & ht1_n>=2 &!missing(ht1_n))
			replace dbp = . if (ht1_n==2 & sbp_n==1 & dbp_n==1 & sbp_d==dbp_d)
			replace sbp_d=. if sbp!=1
			replace dbp_d=. if dbp!=1	
			egen ht1_d = rowmin(htDiag_d htMed_d sbp_d dbp_d)
			format ht1_d %tdD_m_CY
			egen ht1_y = rowmax(htDiag_y htMed_y sbp dbp)
			tab ht1_y, mi 
										
		* Checks
			assert inrange(ht1_d, `=d(01/01/2011)', `=d(15/03/2020)') if ht1_d !=. 
			assert inlist(ht1_y, 0, 1)
			assert ht1_y == 1 if ht1_d !=.
			assert ht1_d !=. if ht1_y == 1
			assert ht1_d ==. if ht1_y == 0
			
	* Version 2: moderate certainty
		foreach var in ht {
			gen `var'2_d = `var'1_d if `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1 
			format `var'2_d %tdD_m_CY
			gen `var'2_y = `var'1_n >= 2 & `var'1_n !=. & `var'1_y ==1
			listif patient `var'1_n `var'1_d `var'1_y `var'2_d `var'2_y if `var'1_y==1, id(patient) sort(patient) sepby(patient) seed(1) n(5)
			lab val `var'2_y `var'1_y
		}
			
* Clean 
	drop htDiag_d htDiag_n htDiag_y htMed_d htMed_n htMed_y sbp_d sbp_n sbp_y dbp_d dbp_n dbp_y sbp dbp ht1_n
	
* Label 
	lab var ht1_d "Date of first hypertension indicator: low certainty"
	lab var ht1_y "Binary indicator for hypertension: low certainty"
	lab define ht1_y 1 "Hypertension", replace 
	lab val ht1_y ht1_y
	
	lab var ht2_d "Date of first hypertension indicator: moderate certainty"
	lab var ht2_y "Binary indicator for hypertension: modearte certainty"
	lab define ht2_y 1 "Hypertension", replace 
	lab val ht2_y ht2_y