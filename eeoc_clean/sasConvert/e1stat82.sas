libname mylib '/myPathHere/';
proc export data = mylib.e1stat82.sas7bdat
outfile = '/myPathHere/e1stat82.csv'
dbms = csv
replace
;
run;
