libname mylib '/myPathHere/';
proc export data = mylib.e1stat86.sas7bdat
outfile = '/myPathHere/e1stat86.csv'
dbms = csv
replace
;
run;
