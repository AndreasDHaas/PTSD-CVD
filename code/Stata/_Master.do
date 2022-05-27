*** Project setup 

	* Initials of analyst 
		global ID = "CM"
	
	* Define global macros with file paths 
		do "$do/00_DoFirst_$ID"		
	
*** Descriptive analysis 

	* Data preparation for descriptive analysis: $clean/analyseWide.dta
		
		* Prepare case definitions tables 
			do "$do/01_CaseDefTables"

		* Eligibility 
			do "$do/02_Eligibility.do"
			
		* Case definitions
			do "$do/10_Diabetes.do"		
			do "$do/11_Dyslipidemia.do"		
			do "$do/12_HIV.do"		
			do "$do/13_Hypertension.do"		
			do "$do/14_MentalDisorders.do"		
			do "$do/15_MVE.do"	
			
		* Save 
			save "$clean/analyseWide", replace 
		
	* Table 1: Characteristics of beneficiaries with and without depression diagnoses at the end of follow-up
		do "$do/20_Table1.do"			
		
*** Survival analysis 
		
	* Prepare dataset for survival analysis: $clean/analyseSurv.dta 
		do "$do/30_AnalyseSurv.do"	