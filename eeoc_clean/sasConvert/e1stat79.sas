libname mylib '/myPathHere/';
proc export data = mylib.e1stat79.sas7bdat
outfile = '/myPathHere/e1stat79.csv'
dbms = csv
replace
;
run;
