*******************************************************************************
*                                                                             *
* BUILD SOME GLOBAL VARIABLES                                                 *
*                                                                             *
*******************************************************************************

global unitids "unit_nbr u_status unit_nm hdq_nbr year addr zip1 city_cd city_nm cnty_nm fip5 state sic2 p_name"
global demographics "blkm1 blkm2 blkm3 blkm4 blkm5 blkm6 blkm7 blkm8 blkm9 blkf1 blkf2 blkf3 blkf4 blkf5 blkf6 blkf7 blkf8 blkf9 aapim1 aapim2 aapim3 aapim4 aapim5 aapim6 aapim7 aapim8 aapim9 aapif1 aapif2 aapif3 aapif4 aapif5 aapif6 aapif7 aapif8 aapif9 aianm1 aianm2 aianm3 aianm4 aianm5 aianm6 aianm7 aianm8 aianm9 aianf1 aianf2 aianf3 aianf4 aianf5 aianf6 aianf7 aianf8 aianf9 hispm1 hispm2 hispm3 hispm4 hispm5 hispm6 hispm7 hispm8 hispm9 hispf1 hispf2 hispf3 hispf4 hispf5 hispf6 hispf7 hispf8 hispf9 whm1 whm2 whm3 whm4 whm5 whm6 whm7 whm8 whm9 whf1 whf2 whf3 whf4 whf5 whf6 whf7 whf8 whf9"
global after1983 "eeo_area eeo_off"
global after1986 "dunnsnbr"
global allyears "1971 1972 1973 1975 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014"
global fipyears "1975 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014"

*******************************************************************************
*                                                                             *
* READ IN CSV, REFORMAT, DROP UNNEEDED VARIABLES                              *
*                                                                             *
*******************************************************************************
/* The idea here is to read in each year's csv file, put variables in the same
   format where needed, and save the variables that we actually need. (The EEO-1
   surveys record a lot of redundant information, which makes these files really
   big. We can about halve their size by being smart about what we save, and 
   generate it again later.) */
foreach t of numlist $allyears {
	clear
	!unzip -d "." "sasConvert/e1stat`t'.csv.zip"
	insheet using e1stat`t'.csv, c n
	* A few files have the year as a string variable, or mis-read data such that
	* there is other info in that field. We drop those.
	capture destring year, replace force
	drop if year != `t'
	* Next are several blocks, dealing with idiosyncratic data-type errors in
	* specific years. Most of these are string variables that should be numeric,
	* like year above.
	if year == 2006 {
		rename cbsa_code city_cd
	}
	if year == 2010 {
		destring blkf6, replace force
		destring hispf6, replace force
		destring total1, replace force
		destring whm1, replace force
		destring asianf6, replace force
	}
	if year == 2011 {
		destring whm1, replace force
		destring asianf6, replace force
		destring asianm6, replace force
	}
	if year > 2010 {
		destring hispf6, replace force
		destring hispm6, replace force
	}
	* After 2006, they stopped using AAPI (Asian and Pacific Islander) as a
	* category, splitting it into ASIAN and NHOPI (Native Hawaiian and Other
	* Pacific Islander). For comparability, we want to put them back together.
	* Also after 2006 they they started breaking management into two groups,
	* occupation 1 and occupation 1_2. Since, again, our focus isn't on progress
	* into management and since we want to maintain comparability, we'll put
	* them together as well.
	if year > 2006 {
		forvalues i = 1/9 {
			generate aapim`i' = asianm`i' + nhopim`i'
			generate aapif`i' = asianf`i' + nhopif`i'
		}
		generate aapim1_2 = asianm1_2 + nhopim1_2
		generate aapif1_2 = asianf1_2 + nhopif1_2
		rename cbsa_code city_cd
		foreach race in blkm blkf aapim aapif aianm aianf hispm hispf whm whf {
			replace `race'1 = `race'1 + `race'1_2
		}
	}
	* In some of the old files, we have missing values or numerics where we 
	* should have strings. Note that in 1966, county name is just missing.
	* We can build it from the FIPS, though. The others, the strings are numeric.
	* I turn them into strings, then add leading zeros for comparison to later 
	* records.
	if year == 1966 {
		tostring cnty_nm, replace
		replace cnty_nm = ""
	}
	if year < 1978 {
		tostring hdq_nbr, replace
		replace hdq_nbr = "" if hdq_nbr == "."
	}
	if year > 1966 & year < 1978 {
		tostring unit_nbr, replace
		replace unit_nbr = "" if unit_nbr == "."
	}
	foreach var of varlist unit_nbr hdq_nbr {
		replace `var' = "0" + `var' if length(`var') == 5
		replace `var' = "00" + `var' if length(`var') == 4
		replace `var' = "000" + `var' if length(`var') == 3
		replace `var' = "" if length(`var') != 6
	}
	* Clean some of the state names
	replace fip2nm = "NE" if fip2nm == "NB"
	replace fip2nm = "NC" if fip2nm == "C2"
	replace fip2nm = "TX" if fip2nm == "36"
	replace fip2nm = "CA" if fip2nm == "90"	
	replace fip2nm = "AL" if fip2nm == "A"
	replace fip2nm = "CA" if fip2nm == "C9"
	replace fip2nm = "CO" if fip2nm == "CP"
	replace fip2nm = "KY" if fip2nm == "DY"
	replace fip2nm = "SD" if fip2nm == "KN"
	replace fip2nm = "NJ" if fip2nm == "NK"
	replace fip2nm = "NH" if fip2nm == "NN"
	replace fip2nm = "NC" if fip2nm == "NX"
	replace cnty_nm = "SCHUYKILL" if fip2nm == "OJ"
	replace fip2nm = "PA" if fip2nm == "OJ"
	replace fip2nm = "TX" if fip2nm == "TZ"
	drop if fip2nm == "TS"	
	replace fip2nm = "IL" if fip2nm == "26"
	replace fip2nm = "PA" if fip2nm == "A1"
	replace fip2nm = "IL" if fip2nm == "60"
	replace cnty_nm = "GLYNN" if fip2nm == "GE"
	replace fip2nm = "GA" if fip2nm == "GE"
	replace fip2nm = "IA" if fip2nm == "IO"
	replace fip2nm = "MO" if fip2nm == "M0"
	replace fip2nm = "WI" if fip2nm == "WQ"
	replace fip2nm = "NY" if fip2nm == "NU"
	replace fip2nm = "FL" if fip2nm == "GL"
	replace fip2nm = "WI" if fip2nm == "WO"
	replace fip2nm = "KS" if fip2nm == "KA"
	drop if fip2nm == "AE"
	drop if fip2nm == "AP"
	rename fip2nm state
	* Finally we keep the variables we want, save out, and remove the unzipped
	* csv files.
	if year < 1983 {
		keep $unitids $demographics
	}
	if year >= 1983 & year < 1986 {
		keep $unitids $demographics $after1983
	}
	if year >= 1986 {
		keep $unitids $demographics $after1983 $after1986
	}
	drop if u_status == 7 | u_status == 8
	save e1stat`t'.dta, replace
	erase e1stat`t'.csv
}

*******************************************************************************
*                                                                             *
* ENCODE COUNTY IDENTIFIERS                                                   *
*                                                                             *
*******************************************************************************
/* Now is when things get exciting. We want to code up all of the counties. This
   mostly works for most years, but we've been losing about 10 percent of the
   observations in a given year because of missing or improper county data. I
   want to chase down that 10 percent. The logic of the following is as follows:
   
   1. Create some geographic crosswalk files
   2. Merge the data on 5-digit county FIPS codes
      2a. Save the records where the merge worked in one file
	  2b. Save those where it didn't work in another file; proceed on that one
   3. Erase whatever numeric county FIPS code was present. Fill in the county
      name where there's one missing but another record with it (but not many
	  records with different counties!). Then merge on the two-letter state plus
	  the county names
	  3a. Save the records where that merge worked in one file
	  3b. Save those where it didn't work in another file; proceed on that one
   4. Merge on the two-letter state plus the city names, using a different 
      crosswalk file. Where that merge fails, we'll just treat those as typos to
	  (maybe) come back to later
   5. Now we merge these three files together.
   
   I'm skipping some of the actual file manipulation--whether we're working on a
   subset of the main file that just has geographic identifiers and merging that
   back in, for example. But I also describe the process below.
   */

/* Clean up the county data first. Save in the project's data directory. */
use crosswalkFiles/county_cbsa_state_crosswalk.dta
sort fipscounty
save temp_fipscounty.dta, replace
sort county
save temp_county.dta, replace

/* Build a file called temp_citiesCounties from the GNIS data file I have
   elsewhere. This file is for looking up county names when we only have city
   names. This will be important when cleaning up establishment records that
   don't have county names listed, down below. I do it at the top here so that
   I don't have to bury some janky preserve/restore code in a complicated
   routine. */
!unzip -d . crosswalkFiles/POP_PLACES_20130811.zip
clear
insheet using POP_PLACES_20130811.txt, delim("|")
generate city_nm = upper(feature_name) 
generate county = state_alpha + " " + upper(county_name)
keep state_alpha city_nm county
sort state_alpha city_nm
by state_alpha city_nm: keep if _n == 1
save temp_citiesCounties.dta, replace
erase POP_PLACES_20130811.txt
   
*** ENCODE COUNTY IDENTIFIERS (1975-2014) ***
   
/* Note that these loops work for 1975 and later. There is a big difference in 
   the FIPS codes before then, that will be handled separately */
foreach t of numlist $fipyears {
	display "Year is `t'"
	use e1stat`t'.dta
	/* Change a few of the FIP5s to reflect name or boundary changes. */
	replace fip5 = 12086 if fip5 == 12025 // FL Dade to FL Miami-Dade
	replace fip5 = 13215 if fip5 == 13510 // GA Columbus to GA Muscogee
	replace fip5 = 29186 if fip5 == 29193 // ERR to MO Ste. Genevieve
	replace fip5 = 51005 if fip5 == 51560 // VA Clifton Forge to VA Alleghany
	replace fip5 = 51083 if fip5 == 51780 // VA South Boston to VA Halifax
	replace fip5 = 51800 if fip5 == 51695 // VA Nansemond to VA Suffolk (city)
	/* Merge in our county codes--we'll keep FIPS county for use later. */
	rename fip5 fipscounty
	sort fipscounty
	merge m:1 fipscounty using temp_fipscounty.dta, keepusing(county_code)
	drop if _merge == 2
	preserve
		keep if _merge == 3
		drop _merge
		save e1stat`t'mergeWorked.dta, replace
	restore
	keep if _merge == 1
	drop _merge
	save e1stat`t'mergeFailed.dta, replace

	/* Now we turn to just the mergeFailed files. We only want to focus on the
       unique combinations of state, county, and city in those files; so I 
	   create some trimmed files to work on in the next step. */
	keep year city_nm cnty_nm fipscounty state
	duplicates drop state cnty_nm city_nm, force
	save e1stat`t'mergeFailedTrimmed.dta, replace
	/* I don't use Alaska here. I admit, this reflects weakness on my part. But 
       there are few records there to start with, and geographically it's a 
	   nightmare. */
	drop if state == "AK"
    /* We're going to create a different variable called county for doing a lot of
       the modifications, because we need the original values of city_nm and cnty_nm
       to merge things back in. */
	clonevar county = cnty_nm
    /* The logic for this next block is to find all of the county/city/year tuples
       where we have missing county names, or ONE other name (almost certainly the
       right one). */
	sort state city_nm cnty_nm
	by state city_nm: generate singleCntyNm = mi(cnty_nm) | ///
		cnty_nm == cnty_nm[_N]
	by state city_nm: generate numRecords = _N
	by state city_nm: egen moreCntyNm = total(singleCntyNm)
	by state city_nm: generate trouble = moreCntyNm != numRecords
	gsort state city_nm - cnty_nm
	by state city_nm: replace county = county[_n-1] if mi(county) & trouble == 0
   /* Having done this, I next generate a "county-name" variable that has the 
      two-digit state followed by the county name. This matches the format of 
	  "county" in the crosswalk file. Waaaaaay up at the top, I created a 
	  version of that crosswalk sorted by county, so now we can merge on it. */
	replace county = state + " " + county
	sort county
	drop fipscounty
	merge m:1 county using temp_county.dta, keepusing(county_code fipscounty)
	drop if _merge == 2
   /* Okay, that fixes a very large number of the "broken" records! We save that
      out as fixedMerges1, and then focus on the next group... */
	preserve
		keep if _merge == 3
		keep city_nm cnty_nm year state county_code fipscounty
		sort state cnty_nm city_nm
		save e1stat`t'fixedMerges1.dta, replace
	restore
	keep if _merge == 1
	drop _merge
	gsort state city_nm - cnty_nm
	drop singleCntyNm numRecords moreCntyNm trouble county_code fipscounty
    /* The plan here is to sort these based on their two-digit state and city 
	   name, then match that to the temp_citiesCounties.dta file that I created 
	   up at the top from the GNIS data. Once we have a county name, we can do a
	   second merge based on county name with our crosswalk. */
	drop county
	rename state state_alpha
	sort state_alpha city_nm
	merge m:1 state_alpha city_nm using temp_citiesCounties.dta
	drop if _merge == 2
	rename _merge firstMerge
	sort county
	merge m:1 county using temp_county.dta, keepusing(county_code fipscounty)
	drop if _merge == 2
    /* Boom. That fixes about 40K of the remaining 48K problem children. We're 
	   left with about 7K records, from over 180K. Resolving 96 percent of these 
	   this way seems pretty good to me. If we want to go back and hit up the 7K 
	   that are left later (though I'll accept those as just data errors!), we 
	   can. For now I'll save out as fixedMerges2. */
	*keep if _merge == 3
	keep city_nm cnty_nm year state county_code fipscounty
	sort year state cnty_nm city_nm
	rename state_alpha state
	append using e1stat`t'fixedMerges1.dta
	sort state cnty_nm city_nm
	save e1stat`t'fixedMerges.dta, replace
    /* Now I take each of the mergeFailed files, merge in the county information
       using the fixedMerges file, and then append the mergeWorked file to it.
       The end result is e1stat`t'countyCoded, one for each year. */
	use e1stat`t'mergeFailed.dta
	replace fipscounty = .
	sort state cnty_nm city_nm
	merge m:1 year state cnty_nm city_nm using e1stat`t'fixedMerges.dta, update
	drop if _merge == 2
	* Belt-and-suspenders: make sure there're no conflicts.
	assert _merge != 5
	drop _merge
	append using e1stat`t'mergeWorked.dta
	compress
	save e1stat`t'countyCoded.dta, replace
}

*** ENCODE COUNTY IDENTIFIERS (1973) ***
/* The 1973 data have some screwed-up FIPS codes but the county names are there.
   With the issue that a lot of them have typos, truncations and the like. So
   there's a lot of substitutions, but then the merge is pretty straightforward.
   */
use e1stat1973.dta
generate county = state + " " + cnty_nm
replace county = "FL MIAMI-DADE" if county == "FL DADE"
replace county = "GA MUSCOGEE" if county == "GA COLUMBUS"
replace county = "VA ALLEGHANY" if county == "VA CLIFTON FORGE"
replace county = "VA HALIFAX" if county == "VA SOUTH BOSTON"
replace county = "VA SUFFOLK (CITY)" if county == "VA NANSEMOND"
replace county = "AL DEKALB" if county == "AL DE KALB"
replace county = "AL ESCAMBIA" if county == "AL EMCAMBIA"
replace county = "AZ SANTA CRUZ" if county == "AZ SANTA CRUS"
replace county = "CA SAN BERNARDINO" if county == "CA SAN BERNARDIN"
replace county = "CA SAN LUIS OBISPO" if county == "CA SAN LUIS OBIS"
replace county = "DC DISTRICT OF COLUMBIA" if county == "DC WASHINGTON D."
replace county = "FL DESOTO" if county == "FL DE SOTO"
replace county = "FL ORANGE" if county == "FL ORANGE (ORLAN"
replace county = "GA DEKALB" if county == "GA DE KALB"
replace county = "GA MCDUFFIE" if county == "GA MC DUFFIE"
replace county = "GA MCINTOSH" if county == "GA MC INTOSH"
replace county = "IA O'BRIEN" if county == "IA O BRIEN"
replace county = "IA POLK" if county == "IA POLK (DES MOI"
replace county = "IL COOK" if county == "IL COOK EVERGREE"
replace county = "IL DEKALB" if county == "IL DE KALB"
replace county = "IL DUPAGE" if county == "IL DU PAGE"
replace county = "IL LASALLE" if county == "IL LA SALLE"
replace county = "IL MCDONOUGH" if county == "IL MC DONOUGH"
replace county = "IL MCHENRY" if county == "IL MC HENRY"
replace county = "IL MCLEAN" if county == "IL MC LEAN"
replace county = "IN DEKALB" if county == "IN DE KALB"
replace county = "IN LAPORTE" if county == "IN LA PORTE"
replace county = "KS MCPHERSON" if county == "KS MC PHERSON"
replace county = "KY BOURBON" if county == "KY BOURTON"
replace county = "KY MCCRACKEN" if county == "KY MC CRACKEN"
replace county = "KY MCCREARY" if county == "KY MC CREARY"
replace county = "KY MCLEAN" if county == "KY MC LEAN"
replace county = "LA EAST BATON ROUGE" if county == "LA EAST BATON RO"
replace county = "LA EAST FELICIANA" if county == "LA EAST FELICIAN"
replace county = "LA JEFFERSON DAVIS" if county == "LA JEFFERSON DAV"
replace county = "LA ST. JOHN THE BAPTIST" if county == "LA ST.JOHN THE B"
replace county = "LA VERMILION" if county == "LA VERMILLION"
replace county = "LA WEST BATON ROUGE" if county == "LA WEST BATON RO"
replace county = "LA WEST FELICIANA" if county == "LA WEST FELICIAN"
replace county = "MD PRINCE GEORGE'S" if county == "MD PRINCE GEORGE"
replace county = "MD QUEEN ANNE'S" if county == "MD QUEEN ANNES"
replace county = "MD ST. MARY'S" if county == "MD ST. MARYS"
replace county = "MI GRAND TRAVERSE" if county == "MI GRAND TRAVERS"
replace county = "MI ISABELLA" if county == "MI ISABELLE"
replace county = "MN MCLEOD" if county == "MN MC LEOD"
replace county = "MN YELLOW MEDICINE" if county == "MN YELLOW MEDICI"
replace county = "MO CAPE GIRARDEAU" if county == "MO CAPE GIRARDEA"
replace county = "MO DEKALB" if county == "MO DE KALB"
replace county = "MO MCDONALD" if county == "MO MC DONALD"
replace county = "MO STE. GENEVIEVE" if county == "MO ST. GENEVIEVE"
replace county = "MS DESOTO" if county == "MS DE SOTO"
replace county = "MS JEFFERSON DAVIS" if county == "MS JEFFERSON DAV"
replace county = "MT LEWIS AND CLARK" if county == "MT LEWIS AND CLA"
replace county = "NC MCDOWELL" if county == "NC MC DOWELL"
replace county = "ND LAMOURE" if county == "ND LA MOURE"
replace county = "ND MCKENZIE" if county == "ND MCKENSIE"
replace county = "NM MCKINLEY" if county == "NM MC KINLEY"
replace county = "NY GREENE" if county == "NY GREEN"
replace county = "OK HARMON" if county == "OK HAMMON"
replace county = "OK PONTOTOC" if county == "OK PONTOTOO"
replace county = "OR MALHEUR" if county == "OR MELHEUR"
replace county = "PA NORTHUMBERLAND" if county == "PA NORTHUMBERLAN"
replace county = "TN DEKALB" if county == "TN DE KALB"
replace county = "TX DEWITT" if county == "TX DE WITT"
replace county = "UT UINTAH" if county == "UT UNITAH"
replace county = "VA ALEXANDRIA (CITY)" if county == "VA ALEXANDRIA"
replace county = "VA BRISTOL (CITY)" if county == "VA BRISTOL"
replace county = "VA BUENA VISTA (CITY)" if county == "VA BUENA VISTA"
replace county = "VA GALAX (CITY)" if county == "VA CALAX"
replace county = "VA CHARLOTTESVILLE (CITY)" if county == "VA CHARLOTTESVIL"
replace county = "VA CHESAPEAKE (CITY)" if county == "VA CHESAPEAKE"
replace county = "VA COLONIAL HEIGHTS (CITY)" if county == "VA COLONIAL HEIG"
replace county = "VA COVINGTON (CITY)" if county == "VA COVINGTON"
replace county = "VA DANVILLE (CITY)" if county == "VA DANVILLE"
replace county = "VA FALLS CHURCH (CITY)" if county == "VA FALLS CHURCH"
replace county = "VA FREDERICKSBURG (CITY)" if county == "VA FREDRICKSBURG"
replace county = "VA HAMPTON (CITY)" if county == "VA HAMPTON"
replace county = "VA HARRISONBURG (CITY)" if county == "VA HARRISONBURG"
replace county = "VA HOPEWELL (CITY)" if county == "VA HOPEWELL"
replace county = "VA KING AND QUEEN" if county == "VA KING AND QUEE"
replace county = "VA LEXINGTON (CITY)" if county == "VA LEXINGTON"
replace county = "VA LYNCHBURG (CITY)" if county == "VA LYNCHBURG"
replace county = "VA MARTINSVILLE (CITY)" if county == "VA MARTINSVILLE"
replace county = "VA NEWPORT NEWS (CITY)" if county == "VA NEWPORT NEWS"
replace county = "VA NORFOLK (CITY)" if county == "VA NORFOLK"
replace county = "VA NORTHUMBERLAND" if county == "VA NORTHUMBERLAN"
replace county = "VA NORTON (CITY)" if county == "VA NORTON"
replace county = "VA PETERSBURG (CITY)" if county == "VA PETERSBURG"
replace county = "VA PORTSMOUTH (CITY)" if county == "VA PORTSMOUTH"
replace county = "VA PRINCE WILLIAM" if county == "VA PRINCE WILLIA"
replace county = "VA RADFORD (CITY)" if county == "VA RADFORD"
replace county = "VA SALEM (CITY)" if county == "VA SALEM"
replace county = "VA STAUNTON (CITY)" if county == "VA STAUNTON"
replace county = "VA SUFFOLK (CITY)" if county == "VA SUFFOLK"
replace county = "VA VIRGINIA BEACH (CITY)" if county == "VA VIRGINIA BEAC"
replace county = "VA WAYNESBORO (CITY)" if county == "VA WAYNESBORO"
replace county = "VA WILLIAMSBURG (CITY)" if county == "VA WILLIAMSBURG"
replace county = "VA WINCHESTER (CITY)" if county == "VA WINCHESTER"
sort county
merge m:1 county using temp_county.dta, keepusing(fipscounty county_code)
drop if _merge == 2
drop _merge
compress
save e1stat1973countyCoded.dta, replace

*** ENCODE COUNTY IDENTIFIERS (1971-1972) ***
/* The 1971 and 1972 data are mostly missing county names, but they have the 
   city names most often. So we're going to merge them much like we did with the
   second set of merge fixes above. */
foreach t of numlist 1971 1972 {
	use e1stat`t'.dta
	rename state state_alpha
	sort state_alpha city_nm
	merge m:1 state_alpha city_nm using temp_citiesCounties.dta
	drop if _merge == 2
	rename _merge firstMerge
	sort county
	merge m:1 county using temp_county.dta, ///
		keepusing(county_code fipscounty)
	drop if _merge == 2
	drop _merge firstMerge
	rename state_alpha state
	compress
	save e1stat`t'countyCoded.dta, replace
}

*** WHAT ABOUT COUNTIES IN 1966? ***
/* The 1966 file is missing almost all county names, and the city names are 
   often truncated. That's a much larger amount of work than I'm willing to do 
   right now to clean up--especially since we have a five-year gap between it
   and the next year of the data. That would be the length of time we have sort
   of thought of following establishments, which would defeat the purpose. So,
   we'll use a "mere" 44 years of data for now. */

*** CLEANUP FROM CSV IMPORT ***
*foreach t of numlist 1971 1972 1973 $fipyears {
*	!zip "e1stat`t'countyCoded.dta.zip" "e1stat`t'countyCoded.dta"
*}
foreach t of numlist $fipyears {
	erase e1stat`t'fixedMerges.dta
	erase e1stat`t'fixedMerges1.dta
	erase e1stat`t'mergeWorked.dta
	erase e1stat`t'mergeFailed.dta
	erase e1stat`t'mergeFailedTrimmed.dta
	erase e1stat`t'.dta
}

erase e1stat1971.dta
erase e1stat1972.dta
erase e1stat1973.dta

erase temp_fipscounty.dta
erase temp_county.dta
erase temp_citiesCounties.dta


*******************************************************************************
*                                                                             *
* POST-COUNTY-CODING CLEANING                                                 *
*                                                                             *
*******************************************************************************

foreach t of numlist $allyears {
	*!unzip -d . e1stat`t'countyCoded.dta.zip
	use e1stat`t'countyCoded.dta
	do crosswalkFiles/states2.do
	encode state, generate(state2) label(states2)
	move state2 state
	drop state
	rename state2 state
	* I give up. I'm going to drop Hawai'i, too. It's going to create so many
	* problems with geospatial analysis, otherwise.
	drop if state == "AK":states2 | state == "HI":states2
	sort fipscounty
	merge m:1 fipscounty using ///
		crosswalkFiles/county_cbsa_state_crosswalk.dta, keepusing(cbsa_code)
	drop if _merge == 2
	drop _merge
	drop if mi(unit_nbr)
	duplicates drop unit_nbr u_status, force
	do crosswalkFiles/fipscounty.do
	label val fipscounty fipscounty
	rename county_code ngiscounty
	rename cbsa_code cbsa
	drop cnty_nm
	rename zip1 zip
	capture confirm variable dunnsnbr
	if _rc {
		generate dunnsnbr = .
	}
	capture replace dunnsnbr = subinstr(dunnsnbr,"-","",.)
	capture destring dunnsnbr, replace force
	replace dunnsnbr = . if dunnsnbr == 0
	replace sic2 = . if sic2 == 0
	keep hdq_nbr p_name unit_nbr unit_nm u_status dunnsnbr addr city_nm ///
		fipscounty ngiscounty state cbsa zip sic2 year ///
		aapim1 aapim2 aapim3 aapim4 aapim5 aapim6 aapim7 aapim8 aapim9 ///
		aapif1 aapif2 aapif3 aapif4 aapif5 aapif6 aapif7 aapif8 aapif9 ///
		aianm1 aianm2 aianm3 aianm4 aianm5 aianm6 aianm7 aianm8 aianm9 ///
		aianf1 aianf2 aianf3 aianf4 aianf5 aianf6 aianf7 aianf8 aianf9 ///		
		blkm1 blkm2 blkm3 blkm4 blkm5 blkm6 blkm7 blkm8 blkm9 ///
		blkf1 blkf2 blkf3 blkf4 blkf5 blkf6 blkf7 blkf8 blkf9 ///
		hispm1 hispm2 hispm3 hispm4 hispm5 hispm6 hispm7 hispm8 hispm9 ///
		hispf1 hispf2 hispf3 hispf4 hispf5 hispf6 hispf7 hispf8 hispf9 ///
		whm1 whm2 whm3 whm4 whm5 whm6 whm7 whm8 whm9 ///
		whf1 whf2 whf3 whf4 whf5 whf6 whf7 whf8 whf9
	order hdq_nbr p_name unit_nbr unit_nm u_status dunnsnbr addr city_nm ///
		fipscounty ngiscounty state cbsa zip sic2 year ///
		aapim1 aapim2 aapim3 aapim4 aapim5 aapim6 aapim7 aapim8 aapim9 ///
		aapif1 aapif2 aapif3 aapif4 aapif5 aapif6 aapif7 aapif8 aapif9 ///
		aianm1 aianm2 aianm3 aianm4 aianm5 aianm6 aianm7 aianm8 aianm9 ///
		aianf1 aianf2 aianf3 aianf4 aianf5 aianf6 aianf7 aianf8 aianf9 ///		
		blkm1 blkm2 blkm3 blkm4 blkm5 blkm6 blkm7 blkm8 blkm9 ///
		blkf1 blkf2 blkf3 blkf4 blkf5 blkf6 blkf7 blkf8 blkf9 ///
		hispm1 hispm2 hispm3 hispm4 hispm5 hispm6 hispm7 hispm8 hispm9 ///
		hispf1 hispf2 hispf3 hispf4 hispf5 hispf6 hispf7 hispf8 hispf9 ///
		whm1 whm2 whm3 whm4 whm5 whm6 whm7 whm8 whm9 ///
		whf1 whf2 whf3 whf4 whf5 whf6 whf7 whf8 whf9 
	compress
	save e1stat`t'readyToMerge.dta, replace
}

foreach t of numlist $allyears {
	erase e1stat`t'countyCoded.dta
}

*******************************************************************************
*                                                                             *
* FINALLY, CREATE GIANT FILE FOR ANALYSES                                     *
*                                                                             *
*******************************************************************************
use e1stat1971readyToMerge.dta
foreach t of numlist 1972 1973 1975 1978 1979 1980 1981 1982 1983 1984 ///
	1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 ///
	1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 ///
	2013 2014 {
	append using e1stat`t'readyToMerge.dta, force
}
order hdq_nbr unit_nbr
rename hdq_nbr hq_id
rename unit_nbr unit_id
rename p_name parent_name
rename unit_nm unit_name
label define u_status 1 "Single Establishment" 2 "Consolidated Multi Est" ///
	3 "HQ for Multi Est" 4 "Part of Multi Est" 5 "Special Report"
label val u_status u_status
rename u_status report_type
rename dunnsnbr dbnum
rename addr address
rename city_nm city

save EEO1_1971_2014.dta, replace

foreach t of numlist $allyears {
	erase e1stat`t'readyToMerge.dta
}
