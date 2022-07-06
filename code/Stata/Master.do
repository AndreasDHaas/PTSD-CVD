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
		do "$do/DataPrep/15_MACE.do"	
		do "$do/DataPrep/16_Obesity.do"	
		do "$do/DataPrep/17_Smoking.do"	
			
	* Save dataset in wide format: $clean/analyseWide.dta 
		save "$clean/analyseWide", replace 
			
	* Prepare dataset for survival analysis: $clean/analyseSurv.dta 
		do "$do/DataPrep/30_AnalyseSurv.do"	
		
* Statistical analysis

	* Table 1: Characteristics of beneficiaries with and without depression diagnoses at the end of follow-up
		do "$do/Stats/01_PatientCharacteristics.do"		
		
	*Table 2: Unadjusted and adjusted hazards ratios for factors associated with major cardiovascular events (2-, 3-, and 4-point MACE): low certainty, and 3-point MACE in men & women 
		do "$do/Stats/02_SurvivalAnalysis_MACE.do"
	
	* Table 4: Unadjusted and adjusted hazards ratios for factors associated with diabetes mellitus: low certainty
		do "$do/Stats/02_SurvivalAnalysis_Diabetes.do"
		
	* Table 4: Unadjusted and adjusted hazards ratios for factors associated with dyslipidemia: low certainty
		do "$do/Stats/02_SurvivalAnalysis_Dyslipidemia.do"
		
	* Table 4: Unadjusted and adjusted hazards ratios for factors associated with hypertension: low certainty 
		do "$do/Stats/02_SurvivalAnalysis_Hypertension.do"
		
	* Table 5: Unadjusted and adjusted hazards ratios for factors associated with PTSD: low certainty 
		do "$do/Stats/02_SurvivalAnalysis_PTSD.do"