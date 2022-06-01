
///////////////////////////////////////////////////////////////////////////////
***DO FIRST 
///////////////////////////////////////////////////////////////////////////////

* GitHub repository path 
	global repo "C:/Repositories/PTSD-CVD"
	
* Do files path 
	global do "$repo/code/Stata/"
	
* Ado files path 
	sysdir set PERSONAL "C:/Repositories/ado"

* Data file path 
	global data "C:/Data/IeDEA/PTSD-CVD" 
		
* Database version 
	global v "v2.2"   
	
* Generate data folder & sub-folders
	capture mkdir "$data"
	capture mkdir "$data/$v"
	
* Generate data sub-folders & define macros with file paths 
	foreach f in clean map source temp {
		capture mkdir "$data/$v/`f'"
		global `f' "$data/$v/`f'"
	}
		
* Generate repository sub-folders & define macros with file paths 
	foreach f in docs figures tables {
		capture mkdir "$repo/`f'"
		global `f' "$repo/`f'"
	}
		
* Working directory 
	cd "$temp"

* Define closing date 
	global close_d = d(01/07/2020)
		
* Colors 
	global blue "0 155 196"
	global green "112 177 68"
	global purple "161 130 188"
	global red "185 23 70"
		
* Current date 
	global cymd : di %tdCYND date("$S_DATE" , "DMY")
	di $cymd
	global cdate = date("$S_DATE" , "DMY")
	di $cdate
