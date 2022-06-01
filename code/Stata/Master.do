* Data preparation 
		
	* Prepare case definitions tables 
		do "$do/DataPrep/01_CaseDefTables"

	* Eligibility 
		do "$do/DataPrep/02_Eligibility.do"
		
	* Case definitions
		do "$do/DataPrep/10_Diabetes.do"		
		do "$do/DataPrep/11_Dyslipidemia.do"		
		do "$do/DataPrep/12_HIV.do"		
		do "$do/DataPrep/13_Hypertension.do"		
		do "$do/DataPrep/14_MentalDisorders.do"		
		do "$do/DataPrep/15_MVE.do"	
			
	* Save dataset in wide format: $clean/analyseWide.dta 
		save "$clean/analyseWide", replace 
			
	* Prepare dataset for survival analysis: $clean/analyseSurv.dta 
		do "$do/30_AnalyseSurv.do"	
		
* Statistical analysis
		
	* Table 1: Characteristics of beneficiaries with and without depression diagnoses at the end of follow-up
		do "$do/Stats/01_PatientCharacteristiccs.do"			
		