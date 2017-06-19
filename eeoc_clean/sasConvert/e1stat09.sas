libname mylib '/myPathHere/';
proc export data = mylib.e1stat09.sas7bdat
outfile = '/myPathHere/e1stat09.csv'
dbms = csv
replace
;
run;
