libname mylib '/myPathHere/';
proc export data = mylib.e1stat10.sas7bdat
outfile = '/myPathHere/e1stat10.csv'
dbms = csv
replace
;
run;
