***  Patient characteristics by PTSD at the end of follow-up 

	* AnalyseWide table 
		use "$clean/analyseWide", clear	
		
	* Table header 
		header ptsd, saving("$temp/chrPAT") percentformat(%3.1fc) freqlab("N=") clean freqf(%9.0fc) 
	
	* Baseline characteristics
		percentages age_start_cat ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Characteristics at baseline") clean drop("0 1 2 3 4 5 6") 
		
		* Sociodemographic 
			percentages age_start_cat ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Age, years") clean indent(5)
			sumstats age_start ptsd, append("$temp/chrPAT") format(%3.1fc) clean indent(5)
			percentages sex ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("  Sex") clean indent(5)
			percentages popgrp ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Population group") clean indent(5) 
			
	* Characteristics at the end of follow-up 
		percentages age_start_cat ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Characteristics at the end of follow-up") clean drop("0 1 2 3 4 5 6") 
				
		* CVD risk factors 
			percentages dm1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   CVD risk factors") clean drop("0") indent(5) 
			percentages ht1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			percentages dl1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			percentages ob1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			percentages ow1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			percentages sm1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
		
		* HIV 
			percentages hiv1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(3) 
			
		* Psychiatric comorbidity: simple - low certainty
			percentages su1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity: low certainty") clean drop("0")	indent(5) 	
			percentages psy1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages anx1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages ptsd1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages othanx1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages sleep1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* Psychiatric comorbidity: simple - moderate certainty
			percentages su2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity: moderate certainty") clean drop("0") indent(5) 		
			percentages psy2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages anx2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages ptsd2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages othanx2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages sleep2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* Psychiatric comorbidity: detailed - low certainty
			percentages su1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity: low certainty") clean drop("0")	indent(5) 			
			percentages alc1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages drug1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages tobacco1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages psy1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages bp1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages dep1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages omood1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages anx1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	 
			percentages panic1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)			
			percentages gad1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ad1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages uad1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages asr1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ptsd1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages adj1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages oad1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages sleep1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* Psychiatric comorbidity: detailed - low certainty
			percentages su2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity: detailed - moderate certainty") clean drop("0")	indent(5) 	
			percentages alc2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages drug2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages tobacco2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages psy2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages bp2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages dep2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages omood2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages anx2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	 
			percentages panic2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)			
			percentages gad2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ad2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages uad2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages asr2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ptsd2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages adj2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages oad2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages sleep2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd2_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* MACE  
			percentages mac2e1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(3)	
			percentages mac3e1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(3)
			percentages mac4e1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(3)
			
			percentages stemi1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages nstemi1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages umi1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
			percentages bs1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages is1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages us1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
			percentages ua1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			
			percentages revasc1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)		  
	
			percentages hf1_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
						
		* Mortality 
			percentages death_y ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(3)	
			percentages cod2 ptsd, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop(".") indent(5)				

	* Follow-up time
		sumstats fup ptsd, append("$temp/chrPAT") format(%3.1fc) median heading("   Follow-up time, years") clean indent(5)
		
	* Load and prepare table for export 
		tblout using "$temp/chrPAT", clear merge align format("%25s")
							   
	* Create word table 
		capture putdocx clear
		putdocx begin, font("Arial", 8)
		putdocx paragraph, spacing(after, 0)
		putdocx text ("Table 1: Characteristics of beneficiaries with and without PTSD diagnosis at the end of follow-up"), font("Arial", 9, black) bold 
		putdocx table tbl1 = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent) 
		putdocx table tbl1(., .), halign(right)  font("Arial", 8)
		putdocx table tbl1(., 1), halign(left)  
		putdocx table tbl1(1, .), halign(center) bold 
		putdocx table tbl1(2, .), halign(center)  border(bottom, single)
		putdocx pagebreak
		putdocx save "$tables/Table 1_PTSD.docx", replace
		
/***  Patient characteristics of by anxiety at the end of follow-up 

	* AnalyseWide table 
		use "$clean/analyseWide", clear	
		
	* Table header 
		header anx, saving("$temp/chrPAT") percentformat(%3.1fc) freqlab("N=") clean freqf(%9.0fc) 
	
	* Baseline characteristics
		percentages age_start_cat anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Characteristics at baseline") clean drop("0 1 2 3 4 5 6") 
		
		* Sociodemographic 
			percentages age_start_cat anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Age, years") clean indent(5)
			sumstats age_start anx, append("$temp/chrPAT") format(%3.1fc) clean indent(5)
			percentages sex anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("  Sex") clean indent(5)
			percentages popgrp anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Population group") clean indent(5) 
			
	* Characteristics at the end of follow-up 
		percentages age_start_cat anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("Characteristics at the end of follow-up") clean drop("0 1 2 3 4 5 6") 
				
		* CVD risk factors 
			percentages dm1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   CVD risk factors") clean drop("0") indent(5) 
			percentages ht1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			percentages dl1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			percentages ow1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			percentages sm1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(5) 
			
		* HIV 
			percentages hiv1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) clean noheading drop("0") indent(3) 
			
		* Psychiatric comorbidity: simple - low certainty
			percentages su1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity: low certainty") clean drop("0")	indent(5) 	
			percentages psy1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages anx1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages ptsd1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages othanx1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages sleep1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* Psychiatric comorbidity: simple - moderate certainty
			percentages su2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity: moderate certainty") clean drop("0") indent(5) 		
			percentages psy2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages anx2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages ptsd2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages othanx2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages sleep1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* Psychiatric comorbidity: detailed - low certainty
			percentages su1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity (detailed): low certainty") clean drop("0")	indent(5) 			
			percentages alc1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages drug1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages tobacco1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages psy1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages bp1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages dep1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages omood1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages anx1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	 
			percentages panic1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)			
			percentages gad1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ad1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages uad1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages asr1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ptsd1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages adj1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages oad1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages sleep1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* Psychiatric comorbidity: detailed - low certainty
			percentages su2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) heading("   Psychiatric comorbidity (detailed): moderate certainty") clean drop("0")	indent(5) 	
			percentages alc2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages drug2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages tobacco2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages psy2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages mood2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages bp2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages dep2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages omood2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages anx2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	 
			percentages panic2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)			
			percentages gad2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ad2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages uad2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)		
			percentages asr2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages ptsd2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages adj2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)	
			percentages oad2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(7)
			percentages sleep2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages omd2_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			
		* MVE - version 2 - excluding stroke mimicks 
			percentages mve1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(3)		
			percentages ua0_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages stemi0_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)			
			percentages nstemi0_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages umi0_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages revasc0_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)		  
			percentages bs1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)	
			percentages is1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
			percentages us1_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(5)
						
		* Mortality 
			percentages death_y anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop("0") indent(3)	
			percentages cod2 anx, append("$temp/chrPAT") percentformat(%3.1fc) freqf(%9.0fc) noheading clean drop(".") indent(5)				

	* Follow-up time
		sumstats fup anx, append("$temp/chrPAT") format(%3.1fc) median heading("   Follow-up time, years") clean indent(5)
		
	* Load and prepare table for export 
		tblout using "$temp/chrPAT", clear merge align format("%25s")
							   	
			
	* Load and prepare table for export 
		tblout using "$temp/chrPAT", clear merge align format("%25s")
							   
	* Create word table 
		capture putdocx clear
		putdocx begin, font("Arial", 8)
		putdocx paragraph, spacing(after, 0)
		putdocx text ("Table 1: Characteristics of beneficiaries with and without anxiety diagnosis at the end of follow-up"), font("Arial", 9, black) bold 
		putdocx table tbl1 = data(*), border(all, nil) border(top, single) border(bottom, single) layout(autofitcontent) 
		putdocx table tbl1(., .), halign(right)  font("Arial", 8)
		putdocx table tbl1(., 1), halign(left)  
		putdocx table tbl1(1, .), halign(center) bold 
		putdocx table tbl1(2, .), halign(center)  border(bottom, single)
		putdocx pagebreak
		putdocx save "$tables/Table 1_Anxiety.docx", replace