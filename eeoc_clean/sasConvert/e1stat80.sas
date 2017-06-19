libname mylib '/myPathHere/';
proc export data = mylib.e1stat80.sas7bdat
outfile = '/myPathHere/e1stat80.csv'
dbms = csv
replace
;
run;
