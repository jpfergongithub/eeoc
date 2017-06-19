libname mylib '/myPathHere/';
proc export data = mylib.e1stat08.sas7bdat
outfile = '/myPathHere/e1stat08.csv'
dbms = csv
replace
;
run;
