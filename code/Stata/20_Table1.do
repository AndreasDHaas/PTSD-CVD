***  Patient characteristics of by depression at the end of follow-up 

	* AnalyseWide table 
		use "$clean/analyseWide", clear	
		
	* Sociodemographic characteristics
		header dep, saving("$temp/chrPAT") percentformat(%3.1fc) freqlab("N=") clean freqf(%9.0fc) 
		percentages age_end_cat dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Age, years") clean 
		sumstats age_end dep, append("$temp/chrPAT") format(%3.1fc) clean
		percentages sex dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Sex") clean 
		percentages popgrp dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Population group") clean 
		
	* Follow-up time
		sumstats fup dep, append("$temp/chrPAT") format(%3.1fc) median heading("Follow-up time, years") clean 
		
	* CVD risk factors 
		percentages dm1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("CVD risk factors") clean drop("0")
		percentages ht1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0")
		percentages dl1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0")
		
	* HIV 
		percentages hiv1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(0)
		
	* Psychiatric comorbidity 
		percentages su1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Psychiatric comorbidity") clean drop("0")		
		percentages psy1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		percentages anx1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		
	* MVE - version 2 - excluding stroke mimicks 
		percentages mve2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(0)		
		percentages ua1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 	
		percentages stemi1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 			
		percentages nstemi1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 
		percentages umi1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 
		percentages revasc1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 		  
		percentages bs2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 	
		percentages is2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		percentages us2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		percentages death_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(0)		
		percentages cod2 dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop(".") 				
			
	* Load and prepare table for export 
		tblout using "$temp/chrPAT", clear merge align format("%25s")
							   
	* Create word table 
		capture putdocx clear
		putdocx begin, font("Arial", 8)
		putdocx paragraph, spacing(after, 0)
		putdocx text ("Table 1: Characteristics of beneficiaries with and without depression diagnoses at the end of follow-up"), font("Arial", 9, black) bold 
		putdocx table tbl1 = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent) 
		putdocx table tbl1(., .), halign(right)  font("Arial", 8)
		putdocx table tbl1(., 1), halign(left)  
		putdocx table tbl1(1, .), halign(center) bold 
		putdocx table tbl1(2, .), halign(center)  border(bottom, single)
		putdocx pagebreak
		putdocx save "$tables/Table1.docx", replaceatient characteristics of by depression at the end of follow-up 

	* AnalyseWide table 
		use "$clean/analyseWide", clear	
		
	* Sociodemographic characteristics
		header dep, saving("$temp/chrPAT") percentformat(%3.1fc) freqlab("N=") clean freqf(%9.0fc) 
		percentages age_end_cat dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Age, years") clean 
		sumstats age_end dep, append("$temp/chrPAT") format(%3.1fc) clean
		percentages sex dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Sex") clean 
		percentages popgrp dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Population group") clean 
		
	* Follow-up time
		sumstats fup dep, append("$temp/chrPAT") format(%3.1fc) median heading("Follow-up time, years") clean 
		
	* CVD risk factors 
		percentages dm1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("CVD risk factors") clean drop("0")
		percentages ht1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0")
		percentages dl1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0")
		
	* HIV 
		percentages hiv1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(0)
		
	* Psychiatric comorbidity 
		percentages su1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Psychiatric comorbidity") clean drop("0")		
		percentages psy1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		percentages anx1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		percentages ptsd1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		
	* MVE - version 2 - excluding stroke mimicks 
		percentages mve2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(0)		
		percentages ua1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 	
		percentages stemi1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 			
		percentages nstemi1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 
		percentages umi1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 
		percentages revasc1_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 		  
		percentages bs2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") 	
		percentages is2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		percentages us2_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0")
		percentages death_y dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(0)		
		percentages cod2 dep, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop(".") 				
			
	* Load and prepare table for export 
		tblout using "$temp/chrPAT", clear merge align format("%25s")
							   
	* Create word table 
		capture putdocx clear
		putdocx begin, font("Arial", 8)
		putdocx paragraph, spacing(after, 0)
		putdocx text ("Table 1: Characteristics of beneficiaries with and without PTSD diagnoses at the end of follow-up"), font("Arial", 9, black) bold 
		putdocx table tbl1 = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent) 
		putdocx table tbl1(., .), halign(right)  font("Arial", 8)
		putdocx table tbl1(., 1), halign(left)  
		putdocx table tbl1(1, .), halign(center) bold 
		putdocx table tbl1(2, .), halign(center)  border(bottom, single)
		putdocx pagebreak
		putdocx save "$tables/Table1.docx", replace