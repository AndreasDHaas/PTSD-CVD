*** Mental disorders 
	fdiag su1 using "$clean/ICD10_F" if regexm(icd10_code, "F1[0-6]") | regexm(icd10_code, "F1[8-9]") , y mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') label("Substance use disorder") censor(end)
	fdiag psy1 using "$clean/ICD10_F_R" if regexm(icd10_code, "F2") | regexm(icd10_code, "R44.[0-3]"), y mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') label("Psychotic disorder") censor(end)
	fdiag anx1 using "$clean/ICD10_F" if regexm(icd10_code, "F4") & !regexm(icd10_code, "F43.1"), y mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') label("Anxiety disorder") censor(end) 
	fdiag dep1 using "$clean/ICD10_F" if regexm(icd10_code, "F3[2-3]") | regexm(icd10_code, "F34.1"), y mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') label("Depression") censor(end)
	fdiag ptsd1 using "$clean/ICD10_F" if regexm(icd10_code, "F43.1"), n y list(2) mindate(`=d(01/01/2011)') maxdate(`=d(01/07/2020)') label("PTSD") censor(end)

* Add recoded depression variable for descriptive tables: depression==1, no depression==2
	gen dep = 2-dep1_y 
	lab define dep 1 "Depression" 2 "No depression", replace
	lab val dep dep
	tab dep dep1_y
	
* Add recoded depression variable for descriptive tables: PTSD==1, no PTSD==2
	gen ptsd = 2-ptsd1_y 
	lab define ptsd 1 "PTSD" 2 "No PTSD", replace
	lab val ptsd ptsd
	tab ptsd ptsd1_y
		
* Label
	lab var su1_d "Date of first substance use diagnosis"
	lab var su1_y "Binary indicator for substance use disorder"
	lab var psy1_d "Date of first psychotic disorder diagnosis"
	lab var psy1_y "Binary indicator for psychotic disorder"
	lab var anx1_d "Date of first anxiety disorder diagnosis"
	lab var anx1_y "Binary indicator for anxiety disorder"
	lab var dep1_d "Date of first depression diagnosis"
	lab var dep1_y "Binary indicator for depression"
	lab var dep "Indicator for depression at end of follow-up: depression==1, no depression==2"
	lab var ptsd1_d "Date of first PTSD diagnosis"
	lab var ptsd1_y "Binary indicator for PTSD"
	lab var ptsd "Indicator for depression at end of follow-up: PTSD==1, no PTSD==2"