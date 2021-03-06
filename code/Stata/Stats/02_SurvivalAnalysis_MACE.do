***  Survival analysis 

	* Table 2: Unadjusted and adjusted hazards ratios for factors associated with major cardiovascular events: low certainty - men & women 

		* AnalyseSurv table 
			foreach var in mac2e1_y_tvc mac3e1_y_tvc mac4e1_y_tvc {
			use "$clean/analyseSurv", clear	
	
		* Sample
			*set seed 1
			*sample 5 if sm1_y !=1 & ob1_y !=1
				
		* Labels
		    lab var age "Age, years"
			lab var year "Year"
			lab var ptsd1_y_tvc "Mental disorders"
			lab var dm1_y_tvc "Cardiovascular risk factors"
		
			
			if "`var'" == "mac2e1_y_tvc" local label "MACE 2"
			if "`var'" == "mac3e1_y_tvc" local label "MACE 3"
			if "`var'" == "mac4e1_y_tvc" local label "MACE 4"
			
			* Stset
			stset end, failure(`var') origin(time start18) id(patient) scale(365.25)  
			
			
			listif patient start18 end ptsd1_d ptsd1_y_tvc mac3e1_y_tvc mac3e1_d _t0 _t _d _st sm1_y ob1_y ow1_y if mac3e1_y_tvc ==1 & ptsd1_d!=. & sm1_y ==1 & ob1_y ==1, sepby(patient) id(patient) sort(patient start18) n(10) nolab
			listif patient start18 end ptsd1_d ptsd1_y_tvc mac2e1_y_tvc mac2e1_d _t0 _t _d _st sm1_y ob1_y ow1_y if mac2e1_y_tvc ==1 & ptsd1_d!=. & sm1_y ==1 & ob1_y ==1, sepby(patient) id(patient) sort(patient start18) n(10) nolab
			listif patient start18 end ptsd1_d ptsd1_y_tvc mac4e1_y_tvc mac4e1_d _t0 _t _d _st sm1_y ob1_y ow1_y if mac4e1_y_tvc ==1 & ptsd1_d!=. & sm1_y ==1 & ob1_y ==1, sepby(patient) id(patient) sort(patient start18) n(10) nolab
					
	
										
		* Univariable analysis 
			stcox i.ptsd1_y_tvc 
			regtable ptsd1_y_tvc, heading number(0) save("$temp/hrMACE") varsuffix(0) estlab("HR (95% CI)") keep(var est label id number) dropcoef(0b.ptsd1_y_tvc)	
			stcox i.su1_y_tvc
			regtable su1_y_tvc, number(1) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.su1_y_tvc)	
			stcox i.psy1_y_tvc
			regtable psy1_y_tvc, number(2) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.psy1_y_tvc)				
			stcox i.mdd1_y_tvc
			regtable mdd1_y_tvc, number(3) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mdd1_y_tvc)
			stcox i.anx1_y_tvc
			regtable anx1_y_tvc, number(4) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.anx1_y_tvc)
			stcox i.sleep1_y_tvc
			regtable sleep1_y_tvc, number(5) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.sleep1_y_tvc)				
			stcox i.dm1_y_tvc
			regtable dm1_y_tvc, number(6) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.dm1_y_tvc) heading				
			stcox i.dl1_y_tvc
			regtable dl1_y_tvc, number(7) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.dl1_y_tvc)			
			stcox i.ht1_y_tvc
			regtable ht1_y_tvc, number(8) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.ht1_y_tvc)	
			stcox i.hiv1_y_tvc 
			regtable hiv1_y_tvc, number(9) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.hiv1_y_tvc ) indent(0)
			stcox ib3.age
			regtable age, number(10) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox ib2.sex
			regtable sex, number(11) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.popgrp
			regtable popgrp, number(12) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.year
			regtable year, number(13) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			
			
		* Model 1: adjusted for PTSD, sociodemographic characteristics and year 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp
			regtable ptsd1_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("aHR (95% CI)") keep(var est label) dropcoef(0b.ptsd1_y_tvc) sort(number0 id0)	
			
		* Model 2: adjusted for PTSD, sociodemographic characteristics, year and psychiatric comorbidity 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp i.su1_y_tvc i.psy1_y_tvc i.mdd1_y_tvc i.anx1_y_tvc i.sleep1_y_tvc 
			regtable ptsd1_y_tvc age sex year popgrp su1_y_tvc psy1_y_tvc mdd1_y_tvc anx1_y_tvc sleep1_y_tvc, heading number(0) merge("$temp/hrMACE") varsuffix(2) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd1_y_tvc 0b.su1_y_tvc 0b.psy1_y_tvc 0b.anx1_y_tvc 0b.mdd1_y_tvc 0b.sleep1_y_tvc ///
			h.su1_y_tvc h.psy1_y_tvc h.mdd1_y_tvc h.anx1_y_tvc h.sleep1_y_tvc) sort(number0 id0)		
			
		* Model 3: adjusted for PTSD, sociodemographic characteristics, year and CVD risk factors and HIV 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp i.dm1_y_tvc i.dl1_y_tvc i.ht1_y_tvc i.hiv1_y_tvc  
			regtable ptsd1_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(3) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd1_y_tvc 0b.dm1_y_tvc 0b.dl1_y_tvc 0b.ht1_y_tvc 0b.hiv1_y_tvc ///
			h.dm1_y_tvc h.dl1_y_tvc h.ht1_y_tvc h.hiv1_y_tvc ) sort(number0 id0)		
            
		* Model 4: adjusted for PTSD, sociodemographic characteristics, year, psychiatric comorbidity, CVD risk factors and HIV 
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp i.su1_y_tvc i.psy1_y_tvc i.mdd1_y_tvc i.anx1_y_tvc i.sleep1_y_tvc i.dm1_y_tvc i.dl1_y_tvc i.ht1_y_tvc i.hiv1_y_tvc  
			regtable ptsd1_y_tvc age sex year popgrp su1_y_tvc psy1_y_tvc mdd1_y_tvc anx1_y_tvc sleep1_y_tvc dm1_y_tvc dl1_y_tvc ht1_y_tvc hiv1_y_tvc, ///
			heading number(0) merge("$temp/hrMACE") varsuffix(4) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd1_y_tvc 0b.su1_y_tvc 0b.psy1_y_tvc 0b.mdd1_y_tvc 0b.anx1_y_tvc 0b.sleep1_y_tvc 0b.dm1_y_tvc 0b.dl1_y_tvc 0b.ht1_y_tvc 0b.hiv1_y_tvc ///
		    h.su1_y_tvc h.psy1_y_tvc h.mdd1_y_tvc h.anx1_y_tvc h.sleep1_y_tvc h.dm1_y_tvc h.dl1_y_tvc h.ht1_y_tvc h.hiv1_y_tvc ) sort(number0 id0)		
			
			
		/* Model 5: adjusted for PTSD, sociodemographic characteristics, year, psychiatric comorbidity, CVD risk factors, HIV and lifestyle factors
			stcox i.ptsd1_y_tvc ib3.age ib2.sex i.year i.popgrp i.othanx1_y_tvc i.org1_y_tvc i.su1_y_tvc i.psy1_y_tvc i.mood1_y_tvc i.sleep1_y_tvc i.omd1_y_tvc i.dm1_y_tvc i.dl1_y_tvc i.ht1_y_tvc i.ow1_y i.ob1_y i.sm1_y i.hiv1_y_tvc  
			regtable ptsd1_y_tvc age sex year popgrp othanx1_y_tvc org1_y_tvc su1_y_tvc psy1_y_tvc mood1_y_tvc sleep1_y_tvc omd1_y_tvc dm1_y_tvc dl1_y_tvc ht1_y_tvc hiv1_y_tvc, ///
			heading number(0) merge("$temp/hrMACE") varsuffix(5) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd1_y_tvc 0b.othanx1_y_tvc 0b.org1_y_tvc 0b.su1_y_tvc 0b.psy1_y_tvc 0b.mood1_y_tvc 0b.sleep1_y_tvc 0b.omd1_y_tvc 0b.dm1_y_tvc 0b.dl1_y_tvc 0b.ht1_y_tvc 0b.ow1_y 0b.ob1_y 0b.sm1_y 0b.hiv1_y_tvc ///
			h.othanx1_y_tvc h.org1_y_tvc h.su1_y_tvc h.psy1_y_tvc h.mood1_y_tvc h.sleep1_y_tvc h.omd1_y_tvc h.dm1_y_tvc h.dl1_y_tvc h.ht1_y_tvc h.ow1_y h.ob1_y h.sm1_y h.hiv1_y_tvc ) sort(number0 id0)	*/
							
		* Export table 
			use label est* using "$temp/hrMACE", clear 
			list, sep(`=_N')
			capture putdocx clear
			putdocx begin, font("Arial", 8) landscape
			putdocx paragraph, spacing(after, 0) 
			putdocx text ("Table 2: Unadjusted and adjusted hazard ratios for factors associated with `label'"), font("Arial", 9, black) bold
			putdocx table tbl = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent)
			putdocx table tbl(., .), halign(right) font("Arial", 8)
			putdocx table tbl(., 1), halign(left)
			putdocx table tbl(1, .), halign(center) border(bottom, single) bold
			putdocx save "$tables/Table 2_`label'.docx", replace
			}	
			
	* Table 2: Unadjusted and adjusted hazards ratios for factors associated with major cardiovascular events: low certainty - men only   
		
		* Loop over sex 
			foreach s in 1 2 {
			
				* Label 
					if "`s'" == "1" local label = "men"
					else if "`s'" == "2" local label = "women"
			
				* AnalyseSurv table 
					use if sex == `s' using "$clean/analyseSurv", clear	
					assert sex == `s'
					
				* Sample
					*sample 10
					
				* Stset 
					stset end, failure(mac3e1_y_tvc) origin(time start18) id(patient) scale(365.25)  
					*listif patient start18 end ptsd1_d ptsd1_y_tvc mac3e1_y_tvc mac3e1_d _t0 _t _d _st if mac3e1_y_tvc ==1 & ptsd1_d!=., sepby(patient) id(patient) sort(patient start18) n(10) nolab
							
				* Labels 
					lab var age "Age, years"
					lab var year "Year"
					lab var ptsd1_y_tvc "Mental disorders"
					lab var dm1_y_tvc "Cardiovascular risk factors"
										
				* Univariable analysis 
					stcox i.ptsd1_y_tvc 
					regtable ptsd1_y_tvc, heading number(0) save("$temp/hrMACE") varsuffix(0) estlab("HR (95% CI)") keep(var est label id number) dropcoef(0b.ptsd1_y_tvc)	
					stcox i.su1_y_tvc
					regtable su1_y_tvc, number(1) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.su1_y_tvc)	
					stcox i.psy1_y_tvc
					regtable psy1_y_tvc, number(2) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.psy1_y_tvc)				
					stcox i.mdd1_y_tvc
					regtable mdd1_y_tvc, number(3) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mdd1_y_tvc)	
					stcox i.anx1_y_tvc
					regtable anx1_y_tvc, number(4) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.anx1_y_tvc)
					stcox i.sleep1_y_tvc
					regtable sleep1_y_tvc, number(5) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.sleep1_y_tvc)				
					stcox i.dm1_y_tvc
					regtable dm1_y_tvc, number(6) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.dm1_y_tvc) heading				
					stcox i.dl1_y_tvc
					regtable dl1_y_tvc, number(7) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.dl1_y_tvc)			
					stcox i.ht1_y_tvc
					regtable ht1_y_tvc, number(8) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.ht1_y_tvc)	
					stcox i.hiv1_y_tvc 
					regtable hiv1_y_tvc, number(9) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.hiv1_y_tvc ) indent(0)
					stcox ib3.age
					regtable age, number(10) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
					stcox i.popgrp
					regtable popgrp, number(11) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
					stcox i.year
					regtable year, number(12) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
					
			* Model 1: adjusted for PTSD, sociodemographic characteristics and year 
				stcox i.ptsd1_y_tvc ib3.age i.year i.popgrp
				regtable ptsd1_y_tvc age year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("aHR (95% CI)") keep(var est label) dropcoef(0b.ptsd1_y_tvc) sort(number0 id0)	
				
			* Model 2: adjusted for PTSD, sociodemographic characteristics, year and psychiatric comorbidity 
				stcox i.ptsd1_y_tvc ib3.age i.year i.popgrp i.su1_y_tvc i.psy1_y_tvc i.mdd1_y_tvc i.anx1_y_tvc i.sleep1_y_tvc  
				regtable ptsd1_y_tvc age year popgrp su1_y_tvc psy1_y_tvc mdd1_y_tvc anx1_y_tvc sleep1_y_tvc, heading number(0) merge("$temp/hrMACE") varsuffix(2) estlab("aHR (95% CI)") keep(var est label) ///
				dropcoef(0b.ptsd1_y_tvc 0b.su1_y_tvc 0b.psy1_y_tvc 0b.mdd1_y_tvc 0b.anx1_y_tvc 0b.sleep1_y_tvc ///
				h.su1_y_tvc h.psy1_y_tvc h.mdd1_y_tvc h.anx1_y_tvc h.sleep1_y_tvc) sort(number0 id0)		
				
			* Model 3: adjusted for PTSD, sociodemographic characteristics, year and CVD risk factors and HIV 
				stcox i.ptsd1_y_tvc ib3.age i.year i.popgrp i.dm1_y_tvc i.dl1_y_tvc i.ht1_y_tvc i.hiv1_y_tvc  
				regtable ptsd1_y_tvc age year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(3) estlab("aHR (95% CI)") keep(var est label) ///
				dropcoef(0b.ptsd1_y_tvc 0b.dm1_y_tvc 0b.dl1_y_tvc 0b.ht1_y_tvc 0b.hiv1_y_tvc ///
				h.dm1_y_tvc h.dl1_y_tvc h.ht1_y_tvc h.hiv1_y_tvc ) sort(number0 id0)		

			* Model 4: adjusted for PTSD, sociodemographic characteristics, year, psychiatric comorbidity, CVD risk factors and HIV 
				stcox i.ptsd1_y_tvc ib3.age i.year i.popgrp i.su1_y_tvc i.psy1_y_tvc i.mdd1_y_tvc i.anx1_y_tvc i.sleep1_y_tvc i.dm1_y_tvc i.dl1_y_tvc i.ht1_y_tvc i.hiv1_y_tvc  
				regtable ptsd1_y_tvc age year popgrp su1_y_tvc psy1_y_tvc mdd1_y_tvc anx1_y_tvc sleep1_y_tvc dm1_y_tvc dl1_y_tvc ht1_y_tvc hiv1_y_tvc, ///
				heading number(0) merge("$temp/hrMACE") varsuffix(4) estlab("aHR (95% CI)") keep(var est label) ///
				dropcoef(0b.ptsd1_y_tvc 0b.su1_y_tvc 0b.psy1_y_tvc 0b.mdd1_y_tvc 0b.anx1_y_tvc 0b.sleep1_y_tvc  0b.dm1_y_tvc 0b.dl1_y_tvc 0b.ht1_y_tvc 0b.hiv1_y_tvc ///
			    h.su1_y_tvc h.psy1_y_tvc h.mdd1_y_tvc h.anx1_y_tvc h.sleep1_y_tvc h.dm1_y_tvc h.dl1_y_tvc h.ht1_y_tvc h.hiv1_y_tvc ) sort(number0 id0)	
						
				* Export table 
					use label est* using "$temp/hrMACE", clear 
					list, sep(`=_N')
					capture putdocx clear
					putdocx begin, font("Arial", 8) landscape
					putdocx paragraph, spacing(after, 0) 
					putdocx text ("Table 2: Unadjusted and adjusted hazard ratios for factors associated with major vascular events in `label'"), font("Arial", 9, black) bold
					putdocx table tbl = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent)
					putdocx table tbl(., .), halign(right) font("Arial", 8)
					putdocx table tbl(., 1), halign(left)
					putdocx table tbl(1, .), halign(center) border(bottom, single) bold
					putdocx save "$tables/Table 2_`label'.docx", replace		
				
			}
			
				
	/* Table 3: Unadjusted and adjusted hazards ratios for factors associated with major cardiovascular events: moderate certainty 

		* AnalyseSurv table 
			use "$clean/analyseSurv", clear	
			
		* Sampel 
			*sample 5
				
		* Stset 
			stset end, failure(mac3e1_y_tvc) origin(time start18) id(patient) scale(365.25)  
			listif patient start18 end ptsd1_d ptsd1_y_tvc mac3e1_y_tvc mac3e1_d _t0 _t _d _st if mac3e1_y_tvc ==1 & ptsd1_d!=., sepby(patient) id(patient) sort(patient start18) n(1) nolab
					
		* Labels 
			lab var age "Age, years"
			lab var year "Year"
			lab var ptsd2_y_tvc "Mental disorders"
			lab var dm2_y_tvc "Cardiovascular risk factors"
								
		* Univariable analysis 
			stcox i.ptsd2_y_tvc 
			regtable ptsd2_y_tvc, heading number(0) save("$temp/hrMACE") varsuffix(0) estlab("HR (95% CI)") keep(var est label id number) dropcoef(0b.ptsd2_y_tvc)	
			stcox i.othanx2_y_tvc
			regtable othanx2_y_tvc, number(1) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.othanx2_y_tvc)		
			stcox i.org2_y_tvc
			regtable org2_y_tvc, number(2) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.org2_y_tvc)		
			stcox i.su2_y_tvc
			regtable su2_y_tvc, number(3) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.su2_y_tvc)	
			stcox i.psy2_y_tvc
			regtable psy2_y_tvc, number(4) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.psy2_y_tvc)				
			stcox i.mood2_y_tvc
			regtable mood2_y_tvc, number(5) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.mood2_y_tvc)
			stcox i.sleep2_y_tvc
			regtable sleep2_y_tvc, number(6) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.sleep2_y_tvc)
			stcox i.omd2_y_tvc
			regtable omd2_y_tvc, number(7) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.omd2_y_tvc)					
			stcox i.dm2_y_tvc
			regtable dm2_y_tvc, number(8) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.dm2_y_tvc) heading				
			stcox i.dl2_y_tvc
			regtable dl2_y_tvc, number(9) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.dl2_y_tvc)			
			stcox i.ht2_y_tvc
			regtable ht2_y_tvc, number(10) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.ht2_y_tvc)	
			stcox i.hiv2_y_tvc 
			regtable hiv2_y_tvc, number(11) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) dropcoef(0b.hiv2_y_tvc ) indent(0)
			stcox ib3.age
			regtable age, number(12) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox ib2.sex
			regtable sex, number(13) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.popgrp
			regtable popgrp, number(14) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			stcox i.year
			regtable year, number(15) append("$temp/hrMACE") varsuffix(0) keep(var est label id number) heading		
			
		* Model 1: adjusted for PTSD, sociodemographic characteristics and year 
			stcox i.ptsd2_y_tvc ib3.age ib2.sex i.year i.popgrp
			regtable ptsd2_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(1) estlab("aHR (95% CI)") keep(var est label) dropcoef(0b.ptsd2_y_tvc) sort(number0 id0)	
			
		* Model 2: adjusted for PTSD, sociodemographic characteristics, year and psychiatric comorbidity 
			stcox i.ptsd2_y_tvc ib3.age ib2.sex i.year i.popgrp i.othanx2_y_tvc i.org2_y_tvc i.su2_y_tvc i.psy2_y_tvc i.mood2_y_tvc i.sleep2_y_tvc i.omd2_y_tvc  
			regtable ptsd2_y_tvc age sex year popgrp othanx2_y_tvc org2_y_tvc su2_y_tvc psy2_y_tvc mood2_y_tvc sleep2_y_tvc omd2_y_tvc, heading number(0) merge("$temp/hrMACE") varsuffix(2) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd2_y_tvc 0b.othanx2_y_tvc 0b.org2_y_tvc 0b.su2_y_tvc 0b.psy2_y_tvc 0b.mood2_y_tvc 0b.sleep2_y_tvc 0b.omd2_y_tvc ///
			h.othanx2_y_tvc h.org2_y_tvc h.su2_y_tvc h.psy2_y_tvc h.mood2_y_tvc h.sleep2_y_tvc h.omd2_y_tvc) sort(number0 id0)		
			
		* Model 3: adjusted for PTSD, sociodemographic characteristics, year and CVD risk factors and HIV 
			stcox i.ptsd2_y_tvc ib3.age ib2.sex i.year i.popgrp i.dm2_y_tvc i.dl2_y_tvc i.ht2_y_tvc i.hiv2_y_tvc  
			regtable ptsd2_y_tvc age sex year popgrp, heading number(0) merge("$temp/hrMACE") varsuffix(3) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd2_y_tvc 0b.dm2_y_tvc 0b.dl2_y_tvc 0b.ht2_y_tvc 0b.hiv2_y_tvc ///
			h.dm2_y_tvc h.dl2_y_tvc h.ht2_y_tvc h.hiv2_y_tvc ) sort(number0 id0)		

		* Model 4: adjusted for PTSD, sociodemographic characteristics, year, psychiatric comorbidity, CVD risk factors and HIV 
			stcox i.ptsd2_y_tvc ib3.age ib2.sex i.year i.popgrp i.othanx2_y_tvc i.org2_y_tvc i.su2_y_tvc i.psy2_y_tvc i.mood2_y_tvc i.sleep2_y_tvc i.omd2_y_tvc i.dm2_y_tvc i.dl2_y_tvc i.ht2_y_tvc i.hiv2_y_tvc  
			regtable ptsd2_y_tvc age sex year popgrp othanx2_y_tvc org2_y_tvc su2_y_tvc psy2_y_tvc mood2_y_tvc sleep2_y_tvc omd2_y_tvc dm2_y_tvc dl2_y_tvc ht2_y_tvc hiv2_y_tvc, ///
			heading number(0) merge("$temp/hrMACE") varsuffix(4) estlab("aHR (95% CI)") keep(var est label) ///
			dropcoef(0b.ptsd2_y_tvc 0b.othanx2_y_tvc 0b.org2_y_tvc 0b.su2_y_tvc 0b.psy2_y_tvc 0b.mood2_y_tvc 0b.sleep2_y_tvc 0b.omd2_y_tvc 0b.dm2_y_tvc 0b.dl2_y_tvc 0b.ht2_y_tvc 0b.hiv2_y_tvc ///
			h.othanx2_y_tvc h.org2_y_tvc h.su2_y_tvc h.psy2_y_tvc h.mood2_y_tvc h.sleep2_y_tvc h.omd2_y_tvc h.dm2_y_tvc h.dl2_y_tvc h.ht2_y_tvc h.hiv2_y_tvc ) sort(number0 id0)				
			
		* Export table 
			use label est* using "$temp/hrMACE", clear 
			list, sep(`=_N')
			capture putdocx clear
			putdocx begin, font("Arial", 8) landscape
			putdocx paragraph, spacing(after, 0) 
			putdocx text ("Table 3: Unadjusted and adjusted hazard ratios for factors associated with major vascular events: moderate certainty"), font("Arial", 9, black) bold
			putdocx table tbl = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent)
			putdocx table tbl(., .), halign(right) font("Arial", 8)
			putdocx table tbl(., 1), halign(left)
			putdocx table tbl(1, .), halign(center) border(bottom, single) bold
			putdocx save "$tables/Table 3.docx", replace		
				
	/***Create dummies 
	
		*Clinical monitoring
		gen CM = 0
		replace CM =1 if mon ==0
		
		*CD4
		gen CD4 =0 
		replace CD4 =1 if mon ==1
		
		*TVL
		gen TVL =0
		replace TVL =1 if mon ==2
		
		*VL
		gen VL = 0
		replace VL =1 if mon ==3
			


	* -stcox- to get stratum-specific KM curves *
			
			*dummy for regression
			gen dummy=1
			
			*Loop over dummy variables for mon
			foreach var in CM CD4 TVL VL dummy { 
			
				stcox dummy, strata(`var')
				predict surv_`var', basesurv
				separate surv_`var', by(`var')
			}
	
	* get stratum sepcific failure functions
		foreach var in CM CD4 TVL VL dummy { 
			gen fail_`var'1 = 1 - surv_`var'1 
		}
		
	*Survival plot 
		twoway 	line surv_CM1 _t, sort  || ///
				line surv_CD41 _t, sort  || ///
				line surv_TVL1 _t, sort  || ///
				line surv_VL1 _t , sort 
	
	*Failure plot 
		twoway 	line fail_CM1 _t, sort lwidth(0.4) lcolor(green) || ///
				line fail_CD41 _t, sort lwidth(0.4) lcolor(blue) || ///
				line fail_TVL1 _t, sort lwidth(0.4) lcolor(orange) || ///
				line fail_VL1 _t , sort lwidth(0.4) lcolor(red) ///
				ylab(0.05 0.1 0.15) xlab(1 2 3 4 5)  ///
				legend(label(1 "Clinical monitoring")) legend(label(2 "CD4 monitoring")) ///
				legend(label(3 "Targeted viral load monitoring")) legend(label(4 "Viral load monitoring")) legend(order(1 2 3 4)) ///
				ytitle("Proportion of patients") xtitle("Time from ART start (in years)") legend(cols(2))  ///
				scheme(s1color)
	