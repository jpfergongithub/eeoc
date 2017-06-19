libname mylib '/myPathHere/';
proc export data = mylib.e1stat72.sas7bdat
outfile = '/myPathHere/e1stat72.csv'
dbms = csv
replace
;
run;
