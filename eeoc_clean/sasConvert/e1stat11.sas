libname mylib '/myPathHere/';
proc export data = mylib.e1stat11.sas7bdat
outfile = '/myPathHere/e1stat11.csv'
dbms = csv
replace
;
run;
