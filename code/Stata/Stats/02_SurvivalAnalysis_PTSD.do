*Survival analysis 

	* Table 2: Unadjusted and adjusted hazards ratios for factors associated with diabetes mellitus: low certainty

		* AnalyseSurv table 
			use "$clean/analyseSurv", clear	
			
		*Update time-varing variable for diabetes
			listif patient start18 end ptsd1_y ptsd1_y_tvc ptsd1_d if ptsd1_y_tvc==1, id(patient) sort(patient start18) n(3) seed(3) nolab
			replace ptsd1_y_tvc = 1 if end == ptsd1_d & ptsd1_y ==1
			listif patient start18 end ptsd1_d ptsd1_y ptsd1_y_tvc if ptsd1_y ==1, id(patient) sort(patient start18) nolab seed(5) n(3) sepby(ptsd1_y_tvc)
			assert ptsd1_y_tvc ==1 if end == ptsd1_d
			bysort patient ptsd1_y_tvc (start18): gen n = _n
			listif patient start18 end ptsd1_d ptsd1_y ptsd1_y_tvc n if ptsd1_y ==1, id(patient) sort(patient start18) nolab seed(1) n(3) sepby(patient ptsd1_y_tvc)
			count if end != ptsd1_d & n ==1 & ptsd1_y ==1 & ptsd1_y_tvc ==1
			replace ptsd1_y_tvc = 0 if end != ptsd1_d & n ==1 & ptsd1_y ==1 & ptsd1_y_tvc ==1
			assert end == ptsd1_d if n ==1 & ptsd1_y_tvc ==1 
			assert ptsd1_y_tvc ==1 if end == ptsd1_d
			drop n
		
		* Sample
			*set seed 1
			*sample 5 if sm1_y !=1 & ob1_y !=1
			
		* Stset
			stset end, failure(ptsd1_y_tvc) origin(time start18) id(patient) scale(365.25)
					
		* Labels
		    lab var age "Age, years"
			lab var year "Year"
			lab var su1_y_tvc "Mental disorders"
	
			
		* Univariable analysis 	
			stcox i.su1_y_tvc
			regtable su1_y_tvc, heading number(0) save("$temp/hrMACE") varsuffix(0) estlab("HR (95% CI)") keep(var est label id number) dropcoef(0b.su1_y_tvc)
			stcox i.psy1_y_tvc
			regtable psy1_y_tvc, number(1) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.psy1_y_tvc)				
			stcox i.mdd1_y_tvc
			regtable mdd1_y_tvc, number(2) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mdd1_y_tvc)
			stcox i.anx1_y_tvc
			regtable anx1_y_tvc, number(3) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.anx1_y_tvc)
			stcox i.sleep1_y_tvc
			regtable sleep1_y_tvc, number(4) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.sleep1_y_tvc)	
			stcox ib3.age
			regtable age, number(5) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox ib2.sex
			regtable sex, number(6) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.popgrp
			regtable popgrp, number(7) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.year
			regtable year, number(8) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
						
		* Model 1: adjusted for PTSD, sociodemographic characteristics and year 
			stcox ib3.age ib2.sex i.year i.popgrp
			regtable age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("aHR (95% CI)") keep(var est label) sort(number0 id0)	
			
			* Model 2: adjusted for PTSD, sociodemographic characteristics, year and psychiatric comorbidity 
			stcox ib3.age ib2.sex i.year i.popgrp i.su1_y_tvc i.psy1_y_tvc i.mdd1_y_tvc i.anx1_y_tvc i.sleep1_y_tvc  
			regtable age sex year popgrp su1_y_tvc psy1_y_tvc mdd1_y_tvc anx1_y_tvc sleep1_y_tvc, heading number(0) merge("$temp/hrMACE") varsuffix(2) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.su1_y_tvc 0b.psy1_y_tvc 0b.mdd1_y_tvc 0b.anx1_y_tvc 0b.sleep1_y_tvc ///
			h.su1_y_tvc h.psy1_y_tvc h.mdd1_y_tvc h.anx1_y_tvc h.sleep1_y_tvc ) sort(number0 id0)		
				
            
							
		* Export table 
			use label est* using "$temp/hrMACE", clear 
			list, sep(`=_N')
			capture putdocx clear
			putdocx begin, font("Arial", 8) landscape
			putdocx paragraph, spacing(after, 0) 
			putdocx text ("Table 5: Unadjusted and adjusted hazard ratios for variables associated with PTSD"), font("Arial", 9, black) bold
			putdocx table tbl = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent)
			putdocx table tbl(., .), halign(right) font("Arial", 8)
			putdocx table tbl(., 1), halign(left)
			putdocx table tbl(1, .), halign(center) border(bottom, single) bold
			putdocx save "$tables/Table 5_PTSD.docx", replace	