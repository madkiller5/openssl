@ECHO OFF
rmdir /Q /S include\openssl
mkdir include\openssl
for  /F "DELIMS==" %%d in ('DIR /b /a:d "crypto\*"') do copy crypto\%%d\*.h include\openssl
copy ssl\*.h include\openssl
copy crypto\*.h include\openssl
copy e_os2.h include\openssl