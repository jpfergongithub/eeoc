libname mylib '/myPathHere/';
proc export data = mylib.e1stat99.sas7bdat
outfile = '/myPathHere/e1stat99.csv'
dbms = csv
replace
;
run;
