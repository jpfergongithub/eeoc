libname mylib '/myPathHere/';
proc export data = mylib.e1stat77.sas7bdat
outfile = '/myPathHere/e1stat77.csv'
dbms = csv
replace
;
run;
