libname mylib '/myPathHere/';
proc export data = mylib.e1stat83.sas7bdat
outfile = '/myPathHere/e1stat83.csv'
dbms = csv
replace
;
run;
