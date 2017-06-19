libname mylib '/myPathHere/';
proc export data = mylib.e1stat93.sas7bdat
outfile = '/myPathHere/e1stat93.csv'
dbms = csv
replace
;
run;
