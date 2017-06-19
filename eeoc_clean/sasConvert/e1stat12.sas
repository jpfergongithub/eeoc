libname mylib '/myPathHere/';
proc export data = mylib.e1stat12.sas7bdat
outfile = '/myPathHere/e1stat12.csv'
dbms = csv
replace
;
run;
