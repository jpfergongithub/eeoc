libname mylib '/myPathHere/';
proc export data = mylib.e1stat02.sas7bdat
outfile = '/myPathHere/e1stat02.csv'
dbms = csv
replace
;
run;
