##  OpenSSL 1.0.2 22 Jan 2015

[![Build Status](https://webapi.biicode.com/v1/badges/lasote/lasote/openssl/master)](https://www.biicode.com/lasote/openssl) 

The source code if this block (entirely) is on this github fork of openssl (on branch **OpenSSL_1_0_2_biicode**)

[https://github.com/lasote/openssl.git ](https://github.com/lasote/openssl.git )


Tested on:


Windows Visual Studio 2012: [![Build status](https://ci.appveyor.com/api/projects/status/ascl63fq0dpjv7c8/branch/OpenSSL_1_0_2_biicode?svg=true)](https://ci.appveyor.com/project/lasote/openssl/branch/OpenSSL_1_0_2_biicode)(https://ci.appveyor.com/project/lasote/openssl)

Windows MinGW

Linux GCC: [![Build Status](https://travis-ci.org/lasote/openssl.svg?branch=OpenSSL_1_0_2_biicode)](https://travis-ci.org/lasote/openssl)

Clang on OSX


## How to use it?

New with biicode? Check the [getting started guide](http://docs.biicode.com/c++/gettingstarted.html).

Create new biicode project and create an empty block:
    
    > bii init myproject
    > bii new myuser/myblock


Include the header you need from this block in your source code:

    #include "lasote/openssl/include/openssl/md5.h"


You can also keep your **#includes** as *"openssl/md5.h"* using include mapping:

    [includes]
    openssl/md5.h: lasote/openssl/include


Open **biicode.conf** file and put a requirement to this block:

    [requirements]
    lasote/openssl(v1.0.2): 0 # Check last version in website


Program your code and build it: 

    > bii cpp:build # This command will build your project and the openssl dependency


You can check an [the example](http://www.biicode.com/examples/examples/openssl/v1.0.2) with some examples using OpenSSL with biicode.


------------------------------------------------------------------------------------

