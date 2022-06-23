***  Survival analysis 

	* Table 2: Unadjusted and adjusted hazards ratios for factors associated with major cardiovascular events: low certainty - men & women 

		* AnalyseSurv table 
			foreach var in dm1_y_tvc dl1_y_tvc ht1_y_tvc {
			use "$clean/analyseSurv", clear	
	
		* Sample
			*set seed 1
			*sample 5 if sm1_y !=1 & ob1_y !=1
				
		* Labels
		    lab var age "Age, years"
			lab var year "Year"
			lab var ptsd1_y_tvc "Mental disorders"
			lab var dm1_y_tvc "Cardiovascular risk factors"
			lab var ow1_y "Lifestyle factors"
			<lab define sm1_y 1 "Smoking", modify
			
			if "`var'" == "dm1_y_tvc" local label "Diabetes"
			if "`var'" == "dl1_y_tvc" local label "Dyslipidemia"
			if "`var'" == "ht1_y_tvc" local label "Hypertension"
			
			* Stset
			stset end, failure(`var') origin(time start18) id(patient) scale(365.25)  
			
		* Univariable analysis 
			stcox i.ptsd1_y_tvc 
			regtable ptsd1_y_tvc, heading number(0) save("$temp/hrMACE") varsuffix(0) estlab("HR (95% CI)") keep(var est label id number) dropcoef(0b.ptsd1_y_tvc)	
			stcox i.othanx1_y_tvc
			regtable othanx1_y_tvc, number(1) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.othanx1_y_tvc)		
			stcox i.org1_y_tvc
			regtable org1_y_tvc, number(2) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.org1_y_tvc)		
			stcox i.su1_y_tvc
			regtable su1_y_tvc, number(3) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.su1_y_tvc)	
			stcox i.psy1_y_tvc
			regtable psy1_y_tvc, number(4) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.psy1_y_tvc)				
			stcox i.mood1_y_tvc
			regtable mood1_y_tvc, number(5) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mood1_y_tvc)
			stcox i.sleep1_y_tvc
			regtable sleep1_y_tvc, number(6) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.sleep1_y_tvc)
			stcox i.omd1_y_tvc
			regtable omd1_y_tvc, number(7) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.omd1_y_tvc)					
			stcox i.mac2e1_y_tvc
			regtable mac2e1_y_tvc, number(8) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mac2e1_y_tvc) heading				
			stcox i.mac3e1_y_tvc
			regtable mac3e1_y_tvc, number(9) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mac3e1_y_tvc)			
			stcox i.mac4e1_y_tvc
			regtable mac4e1_y_tvc, number(10) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mac4e1_y_tvc)	
			stcox i.hiv1_y_tvc 
			regtable hiv1_y_tvc, number(11) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.hiv1_y_tvc ) indent(0)
			stcox ib3.age
			regtable age, number(12) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox ib2.sex
			regtable sex, number(13) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.popgrp
			regtable popgrp, number(14) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.year
			regtable year, number(15) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.ow1_y
			regtable ow1_y, number(16) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.ow1_y) heading	
			stcox i.ob1_y
			regtable ob1_y, number(17) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.ob1_y)	
			stcox i.sm1_y
			regtable sm1_y, number(18) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.sm1_y)
			
		* Model 1: adjusted for PTSD, sociodemographic characteristics and year 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp
			regtable ptsd1_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("aHR (95% CI)") keep(var est label) dropcoef(0b.ptsd1_y_tvc) sort(number0 id0)	
				
							
		* Export table 
			use label est* using "$temp/hrMACE", clear 
			list, sep(`=_N')
			capture putdocx clear
			putdocx begin, font("Arial", 8) landscape
			putdocx paragraph, spacing(after, 0) 
			putdocx text ("Table 4: Unadjusted and adjusted hazard ratios for variables associated with `label'"), font("Arial", 9, black) bold
			putdocx table tbl = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent)
			putdocx table tbl(., .), halign(right) font("Arial", 8)
			putdocx table tbl(., 1), halign(left)
			putdocx table tbl(1, .), halign(center) border(bottom, single) bold
			putdocx save "$tables/Table 4_`label'.docx", replace		
			}
			
			
			
	* Table 2: Adjusted hazards ratios for factors associated with major cardiovascular events: low certainty - men & women 

		* AnalyseSurv table 
			*use "$clean/analyseSurv", clear	
	
		* Sample
			*set seed 1
			*sample 5 if sm1_y !=1 & ob1_y !=1
					   
			* Stset
			*stset end, failure(dm1_y_tvc) origin(time start18) id(patient) scale(365.25)  
			
			* Model 1: Diabetes adjusted for PTSD, sociodemographic characteristics and year 
			*stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp
			*regtable ptsd1_y_tvc age sex year popgrp, heading number(0) save("$temp/hrMACE") varsuffix(1) estlab("Diabetes") keep(var est label) dropcoef(0b.ptsd1_y_tvc) 
			
			* Stset
			*stset end, failure(dl1_y_tvc) origin(time start18) id(patient) scale(365.25) 
				
			* Model 2: Dyslipidemia adjusted for PTSD, sociodemographic characteristics and year 
			*stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp
			*regtable ptsd1_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("Dyslipidemia") keep(var est label) dropcoef(0b.ptsd1_y_tvc)
				
			* Stset
			*stset end, failure(ht1_y_tvc) origin(time start18) id(patient) scale(365.25) 
				
			* Model 3: Hypertension adjusted for PTSD, sociodemographic characteristics and year 
			*stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp
			*regtable ptsd1_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("Hypertension") keep(var est label) dropcoef(0b.ptsd1_y_tvc) 
				
	        *Export table
			*use label est* using "$temp/hrMACE", clear 
			*list, sep(`=_N')
			*capture putdocx clear
			*putdocx begin, font("Arial", 8) landscape
			*putdocx paragraph, spacing(after, 0) 
			*putdocx text ("Table 4: Adjusted hazard ratios for variables associated with cardiovascular risk factors"), font("Arial", 9, black) bold
			*putdocx table tbl = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent)
			*putdocx table tbl(., .), halign(right) font("Arial", 8)
			*putdocx table tbl(., 1), halign(left)
			*putdocx table tbl(1, .), halign(center) border(bottom, single) bold
			*putdocx save "$tables/Table 4.docx", replace
	