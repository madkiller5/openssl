#!/bin/bash - 
rm -rf ./include/openssl
mkdir -p include/openssl
for crypto_module in ./crypto/*/ ; do
    echo "Copying headers from $crypto_module"
    cp $crypto_module/*.h ./include/openssl
done
cp ./ssl/*.h ./include/openssl
cp ./crypto/*.h ./include/openssl
cp e_os2.h ./include/openssl
