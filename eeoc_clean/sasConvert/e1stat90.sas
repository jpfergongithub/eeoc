libname mylib '/myPathHere/';
proc export data = mylib.e1stat90.sas7bdat
outfile = '/myPathHere/e1stat90.csv'
dbms = csv
replace
;
run;
