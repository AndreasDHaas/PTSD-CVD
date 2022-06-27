*Survival analysis 

	* Table 2: Unadjusted and adjusted hazards ratios for factors associated with diabetes mellitus: low certainty - men & women 

		* AnalyseSurv table 
			use "$clean/analyseSurv", clear	
			
		*Update time-varing variable for diabetes
			listif patient start18 end dm1_y dm1_y_tvc dm1_d if dm1_y_tvc==1, id(patient) sort(patient start18) n(3) seed(3) nolab
			replace dm1_y_tvc = 1 if end == dm1_d & dm1_y ==1
			listif patient start18 end dm1_d dm1_y dm1_y_tvc if dm1_y ==1, id(patient) sort(patient start18) nolab seed(1) n(3) sepby(dm1_y_tvc)
			assert dm1_y_tvc ==1 if end == dm1_d
			bysort patient dm1_y_tvc (start18): gen n = _n
			listif patient start18 end dm1_d dm1_y dm1_y_tvc n if dm1_y ==1, id(patient) sort(patient start18) nolab seed(1) n(3) sepby(patient dm1_y_tvc)
			count if end != dm1_d & n ==1 & dm1_y ==1 & dm1_y_tvc ==1
			replace dm1_y_tvc = 0 if end != dm1_d & n ==1 & dm1_y ==1 & dm1_y_tvc ==1
			assert end == dm1_d if n ==1 & dm1_y_tvc ==1 
			assert dm1_y_tvc ==1 if end == dm1_d
			drop n
		
		* Sample
			set seed 1
			sample 5 if sm1_y !=1 & ob1_y !=1
			
		* Stset
			stset end, failure(dm1_y_tvc) origin(time start18) id(patient) scale(365.25)
					
		* Labels
		    lab var age "Age, years"
			lab var year "Year"
			lab var ptsd1_y_tvc "Mental disorders"
			lab var dl1_y_tvc "Cardiovascular risk factors"	
			
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
			stcox i.dl1_y_tvc
			regtable dl1_y_tvc, number(8) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.dl1_y_tvc) heading	
			stcox i.ht1_y_tvc
			regtable ht1_y_tvc, number(9) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.ht1_y_tvc)	
			stcox i.hiv1_y_tvc 
			regtable hiv1_y_tvc, number(10) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.hiv1_y_tvc ) indent(0)
			stcox ib3.age
			regtable age, number(11) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox ib2.sex
			regtable sex, number(12) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.popgrp
			regtable popgrp, number(13) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.year
			regtable year, number(14) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
						
		* Model 1: adjusted for PTSD, sociodemographic characteristics and year 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp
			regtable ptsd1_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("aHR (95% CI)") keep(var est label) dropcoef(0b.ptsd1_y_tvc) sort(number0 id0)	
			
			* Model 2: adjusted for PTSD, sociodemographic characteristics, year and psychiatric comorbidity 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp i.othanx1_y_tvc i.org1_y_tvc i.su1_y_tvc i.psy1_y_tvc i.mood1_y_tvc i.sleep1_y_tvc i.omd1_y_tvc  
			regtable ptsd1_y_tvc age sex year popgrp othanx1_y_tvc org1_y_tvc su1_y_tvc psy1_y_tvc mood1_y_tvc sleep1_y_tvc omd1_y_tvc, heading number(0) merge("$temp/hrMACE") varsuffix(2) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd1_y_tvc 0b.othanx1_y_tvc 0b.org1_y_tvc 0b.su1_y_tvc 0b.psy1_y_tvc 0b.mood1_y_tvc 0b.sleep1_y_tvc 0b.omd1_y_tvc ///
			h.othanx1_y_tvc h.org1_y_tvc h.su1_y_tvc h.psy1_y_tvc h.mood1_y_tvc h.sleep1_y_tvc h.omd1_y_tvc) sort(number0 id0)		
			
			* Model 3: adjusted for PTSD, sociodemographic characteristics, year and CVD risk factors and HIV 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp i.dl1_y_tvc i.ht1_y_tvc i.hiv1_y_tvc  
			regtable ptsd1_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(3) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd1_y_tvc 0b.dl1_y_tvc 0b.ht1_y_tvc 0b.hiv1_y_tvc ///
			h.dl1_y_tvc h.ht1_y_tvc h.hiv1_y_tvc ) sort(number0 id0)	
			
			* Model 4: adjusted for PTSD, sociodemographic characteristics, year, psychiatric comorbidity, CVD risk factors and HIV 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp i.othanx1_y_tvc i.org1_y_tvc i.su1_y_tvc i.psy1_y_tvc i.mood1_y_tvc i.sleep1_y_tvc i.omd1_y_tvc i.dl1_y_tvc i.ht1_y_tvc i.hiv1_y_tvc  
			regtable ptsd1_y_tvc age sex year popgrp othanx1_y_tvc org1_y_tvc su1_y_tvc psy1_y_tvc mood1_y_tvc sleep1_y_tvc omd1_y_tvc dl1_y_tvc ht1_y_tvc hiv1_y_tvc, ///
			heading number(0) merge("$temp/hrMACE") varsuffix(4) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd1_y_tvc 0b.othanx1_y_tvc 0b.org1_y_tvc 0b.su1_y_tvc 0b.psy1_y_tvc 0b.mood1_y_tvc 0b.sleep1_y_tvc 0b.omd1_y_tvc 0b.dl1_y_tvc 0b.ht1_y_tvc 0b.hiv1_y_tvc ///
			h.othanx1_y_tvc h.org1_y_tvc h.su1_y_tvc h.psy1_y_tvc h.mood1_y_tvc h.sleep1_y_tvc h.omd1_y_tvc h.dl1_y_tvc h.ht1_y_tvc h.hiv1_y_tvc ) sort(number0 id0)		
            
				
							
		* Export table 
			use label est* using "$temp/hrMACE", clear 
			list, sep(`=_N')
			capture putdocx clear
			putdocx begin, font("Arial", 8) landscape
			putdocx paragraph, spacing(after, 0) 
			putdocx text ("Table 4: Unadjusted and adjusted hazard ratios for variables associated with diabetes mellitus"), font("Arial", 9, black) bold
			putdocx table tbl = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent)
			putdocx table tbl(., .), halign(right) font("Arial", 8)
			putdocx table tbl(., 1), halign(left)
			putdocx table tbl(1, .), halign(center) border(bottom, single) bold
			putdocx save "$tables/Table 4_Diabetes.docx", replace	