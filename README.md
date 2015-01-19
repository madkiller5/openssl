## OpenSSL 1.0.1-stable

The source code if this block (entirely) is on this github fork of openssl (on branch **OpenSSL_1_0_1-stable**)

[https://github.com/lasote/openssl.git ](https://github.com/lasote/openssl.git )


Tested on:


Visual Studio 2012: [![Build status](https://ci.appveyor.com/api/projects/status/ascl63fq0dpjv7c8?svg=true)](https://ci.appveyor.com/project/lasote/openssl)
Linux GCC: [![Build Status](https://travis-ci.org/lasote/openssl.svg?branch=OpenSSL_1_0_1-stable)](https://travis-ci.org/lasote/openssl)

## How to use it?

New with biicode? Check the [getting started guide](http://docs.biicode.com/c++/gettingstarted.html).

Create new biicode project and create an empty block:
    
    > bii init myproject
    > bii new myuser/myblock


Include the header you need **uv.h** from this block in your source code:

    #include "lasote/openssl/include/openssl/md5.h"


You can also keep your **#includes** as *<openssl/md5.h>* using include mapping:

    [includes]
    openssl/md5.h: lasote/openssl/include


Open **biicode.conf** file and put a requirement to this block:

    [requirements]
    # This file contains your block external dependencies references
    lasote/openssl: 1


Program your code and build it: 

    > bii cpp:build # This command will build your project and the openssl dependency


You can check an [the example](http://www.biicode.com/examples/openssl) with some examples using OpenSSL with biicode.
