libname mylib '/myPathHere/';
proc export data = mylib.e1stat98.sas7bdat
outfile = '/myPathHere/e1stat98.csv'
dbms = csv
replace
;
run;
