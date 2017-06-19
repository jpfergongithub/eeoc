libname mylib '/myPathHere/';
proc export data = mylib.e1stat04.sas7bdat
outfile = '/myPathHere/e1stat04.csv'
dbms = csv
replace
;
run;
