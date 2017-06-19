libname mylib '/myPathHere/';
proc export data = mylib.e1stat85.sas7bdat
outfile = '/myPathHere/e1stat85.csv'
dbms = csv
replace
;
run;
