*** Prepare wide table for causal inference analysis: outcomes, exposures and mediators are assessed every # days after baseline (start18)

	* Define spacing of time pionts (interval: i)
		global i = 182
		
	* Maximum number of time points over 6 years follow-up
		global iMax = 12

	* Analyse wide t
		use "$clean/analyseWide", clear
		sort patient
		*keep if rn<=0.1
	
	* Baseline date 
		assert start18 !=.
		assertunique pat
	
	* Define time points 
		rename start18 t0
		forvalues j = 1/$iMax {
			qui gen t`j' = t0 + `j' * $i 
			format t`j' %tdD_m_CY
		}
		replace t12 = maxFup 
		order t0, before(t1)
		
	
	
	* Define last completed time point under follow-up 
		gen tMax = floor((end-t0)/$i)

	
	* List 
		listif patient t0 t1 t2 t3 t4 t5 t10 t11 t12 fup end tMax maxFup if fup < 1, id(patient) sort(patient) sepby(patient) n(5) 
		listif patient t0 t1 t2 t3 t4 t5 t10 t11 t12 fup end tMax if fup >= 4, id(patient) sort(patient) sepby(patient) n(5) 
		
	* Time points 
		// T1 = [T0-T1) 
		// T2 = [T1-T2)
		// ...
		// T12 = [T11-T12]
	
						
	* Outcome: MACE 3
		*Exclude patients with MACE 3 date before or equal to t0: 86
			drop if mac3e1_d <= t0
		* Format of mac3e1_d
			format mac3e1_d %tdD_m_CY
		* T0
			assert mac3e1_d > t0 
			
		* T1 
			gen mac3e1_t1 = inrange(mac3e1_d, t0, t1-1)
			listif patient t0 t1 t2 t3 t4 t5 end tMax mac3e1_d mac3e1_y mac3e1_t1 if mac3e1_t1 ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1)
			
		* T2-T11 
			forvalues j = 2/ $iMax {
				local s = `j' - 1 
				if `j' < $iMax gen mac3e1_t`j' = inrange(mac3e1_d, t`s', t`j'-1)
				else if `j' == $iMax gen mac3e1_t`j' = inrange(mac3e1_d, t`s', t`j')
				di in red " --- t`j' ---"
				*listif patient t0 t1 t2 t3 t4 t5 t6 t7 end tMax mac3e1_d mac3e1_y mac3e1_t`s' mac3e1_t`j' if mac3e1_t`j' ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
				assert mac3e1_t`j' == 0 if mac3e1_d ==.
			}
		
		* List 		
			listif patient t0 t1 t2 t3 t4 t5 end tMax mac3e1_d mac3e1_y mac3e1_t4 mac3e1_t5 mac3e1_t6 maxFup if mac3e1_d == t5, id(patient) sort(patient) sepby(patient) n(5) seed(1) 
			listif patient t0 t7 t8 t9 t10 t11 t12 end tMax mac3e1_d mac3e1_y mac3e1_t11 mac3e1_t12 maxFup if mac3e1_t12 ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			listif patient t0 t1 t2 t3 t4 t5 end tMax mac3e1_d mac3e1_y mac3e1_t4 mac3e1_t11 mac3e1_t12  if patient =="B000000595", id(patient) sort(patient) sepby(patient) n(5) seed(1) 
			
		* Censor after end of follow-up
			forvalues j = 1/ $iMax{
			    local s = `j' - 1 
				replace mac3e1_t`j' = . if tMax < `j'-1 & mac3e1_y==0
				di in red " --- t`j' ---"
				listif patient t0 t1 t2 t3 t4 t5 t6 end mac3e1_t`j' tMax if mac3e1_t`j' ==1 , id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			}
		
		* Set MACE to 1 if person has an event
			forvalues j = 2/ $iMax{
			    local s = `j' - 1 
				replace mac3e1_t`j' = 1 if mac3e1_t`s' ==1 
				di in red " --- t`j' ---"
				listif patient t0 t1 t2 t3 t4 t5 t6 end mac3e1_t`j' tMax if mac3e1_t`j' ==1 , id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			}
				
		* List 
			*listif patient t0 t7 t8 t9 t10 t11 t12 end tMax mac3e1_d mac3e1_y mac3e1_t10 mac3e1_t11 mac3e1_t12 maxFup if mac3e1_t11 ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			*listif patient t0 t1 t2 end tMax mac3e1_d mac3e1_y mac3e1_t1 mac3e1_t2 mac3e1_t3 maxFup if death_t1 ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			*listif patient t0 t1 t2 end tMax mac3e1_d mac3e1_y mac3e1_t1 mac3e1_t2 mac3e1_t3 maxFup if death_t1 ==., id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			*listif patient t0 t1 t2 end tMax mac3e1_d mac3e1_y mac3e1_t1 mac3e1_t2 mac3e1_t3 maxFup if tMax==0, id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
		 
	* Exclude if insurance ends within first time interval - MACE 3 unobserved 
		assert end < t1 if tMax==0
		drop if tMax==0 & mac3e1_t1!=1 //93,949 
		assert mac3e1_t1 !=.
		
	*Exposure: PTSD moderate certainty; CRISTINA: PTSD
		*Exclude patients with MACE 3 date before or equal to t0: 180
			drop if ptsd2_d <= t0
		
		*T0
			assert ptsd2_d > t0 
			
		* T1 
			gen ptsd_t1 = inrange(ptsd2_d, t0, t1-1)
			listif patient t0 t1 t2 t3 t4 t5 end tMax ptsd2_d ptsd ptsd_t1 if ptsd_t1 ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1)
			
		* T2-T11 
			forvalues j = 2/ $iMax {
				local s = `j' - 1 
				if `j' < $iMax gen ptsd_t`j' = inrange(ptsd2_d, t`s', t`j'-1)
				else if `j' == $iMax gen ptsd_t`j' = inrange(ptsd2_d, t`s', t`j')
				assert ptsd_t`j' == 0 if ptsd2_d ==.
				replace ptsd_t`j' = 1 if ptsd_t`s' == 1  //*Define depression as chronic condition 
				replace ptsd_t`j' = . if mac3e1_t`j' ==. //*Censor after end of follow-up 
				replace ptsd_t`j' = . if mac3e1_t`s' ==1 //*Censor after death - censored in subsequent time intervals
				di in red " --- t`j' ---"
				listif patient t`s' t`j' end ptsd2_d ptsd ptsd_t`s' ptsd_t`j' if ptsd_t`s' ==1 , id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
				listif patient t`s' t`j' end tMax mac3e1_t`s' mac3e1_t`j' mac3e1_d ptsd2_d ptsd ptsd_t`s' ptsd_t`j' if ptsd_t`s' ==1 & mac3e1_t`s'==1 , id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			}
			
		
		* List 		
			*listif patient t0 t1 t2 t3 t4 t5 end tMax ptsd2_d ptsd ptsd_t4 ptsd_t5 ptsd_t6 ptsd_t7 ptsd_t8 maxFup if ptsd2_d == t5, id(patient) sort(patient) sepby(patient) n(5) seed(1) 
			*listif patient t0 t1 t2 t3 t4 t5 end tMax ptsd2_d ptsd ptsd_t1 ptsd_t2 ptsd_t3 ptsd_t4 maxFup if ptsd_t2 ==1 & ptsd_t1==0 , id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
			*listif patient t0 t1 t2 t3 t4 t5 end tMax ptsd2_d ptsd ptsd_t4 ptsd_t11 ptsd_t12  if patient =="B000000595", id(patient) sort(patient) sepby(patient) n(5) seed(1) 
		

	*Mediators	(Only relevant for Cristina if there are any time-dependent confounders of the exposure and the outcome)  
	* HIV: moderate certainty
		
		* T0
			*assert hiv2_d > t0 if hiv2_d!=. // not true
			preserve
			keep if hiv2_d <= t0 & hiv2_d!=.
			list in 1/3     //   under 18 at 01. Jan 2011
			count if hiv2_d==t0 // 
			restore
		* T1 
			gen hiv2_t1 = inrange(hiv2_d, t0, t1-1)
			assert hiv2_d >= t0 if inrange(hiv2_d, t0, t1-1)
			listif patient t0 t1 t2 t3 t4 t5 end tMax hiv2_d hiv2_y hiv2_t1 if hiv2_t1 ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1)
			listif patient t0 t1 t2 t3 t4 t5 end tMax hiv2_d hiv2_y hiv2_t1 if hiv2_t1 ==1 & hiv2_d==t0, id(patient) sort(patient) sepby(patient) n(5) seed(1)
		* T2-T11 
			forvalues j = 2/ $iMax {
				local s = `j' - 1 
				if `j' < $iMax gen hiv2_t`j' = inrange(hiv2_d, t`s', t`j'-1)
				else if `j' == $iMax gen hiv2_t`j' = inrange(hiv2_d, t`s', t`j')
				assert hiv2_t`j' == 0 if hiv2_d ==.
				replace hiv2_t`j' = 1 if hiv2_t`s' == 1 //*Define HIV as chronic condition 
				replace hiv2_t`j' = . if mac3e1_t`j' ==. //*Censor after end of follow-up 
				replace hiv2_t`j' = . if mac3e1_t`s' ==1 //*Censor after death
				di in red " --- t`j' ---"
				listif patient t0 t1 t2 t3 t4 t5 t6 t7 end tMax hiv2_d hiv2_y hiv2_t`s' hiv2_t`j' if hiv2_t`j' ==1, id(patient) sort(patient) sepby(patient) n(5) seed(1) nolab
				listif patient t`s' t`j' end tMax hiv2_d hiv2_y hiv2_t`s' hiv2_t`j' mac3e1_t`s' mac3e1_t`j' mac3e1_d if hiv2_t`s' ==1 & mac3e1_t`j'==1, id(patient) sort(patient) sepby(patient) ///
				n(5) seed(1) nolab
			}
			
	
	
	* Save dataset in wide format  
		save "$clean/analyseWide_t", replace
	
	*Save small dataset for first analyses
		use "$clean/analyseWide_t", clear
		*keep patient rn sex popgrp age_start age_start_cat birth_d mac3e1_t1_t1 mac3e1_t2 mac3e1_t3 mac3e1_t4 ptsd_t1 ptsd_t2 ptsd_t3 ptsd_t4 hiv2_t1 hiv2_t2 hiv2_t3 hiv2_t4  
		keep patient rn sex popgrp age_start age_start_cat birth_d mac3e1_t* ptsd_t* hiv2_t* 
		
	*Reorder data frame
		forvalues i=1/12{
			order ptsd_t`i' hiv2_t`i' mac3e1_t`i', last
		}
		keep if rn <=0.1
		drop patient rn age_start_cat birth_d 
		save "$clean/analyseShort_causal", replace
		


		

