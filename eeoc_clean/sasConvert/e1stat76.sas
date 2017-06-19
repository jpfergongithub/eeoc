libname mylib '/myPathHere/';
proc export data = mylib.e1stat76.sas7bdat
outfile = '/myPathHere/e1stat76.csv'
dbms = csv
replace
;
run;
