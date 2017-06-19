libname mylib '/myPathHere/';
proc export data = mylib.e1stat73.sas7bdat
outfile = '/myPathHere/e1stat73.csv'
dbms = csv
replace
;
run;
