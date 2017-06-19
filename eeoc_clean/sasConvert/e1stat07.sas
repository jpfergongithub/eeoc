libname mylib '/myPathHere/';
proc export data = mylib.e1stat07.sas7bdat
outfile = '/myPathHere/e1stat07.csv'
dbms = csv
replace
;
run;
