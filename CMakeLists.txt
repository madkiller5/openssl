# Based on original work by David Manura
# Copyright (C) 2007-2012 LuaDist.
# Copyright (C) 2013 Brian Sidebotham

# Redistribution and use of this file is allowed according to the terms of the
# MIT license.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#set(CMAKE_VERBOSE_MAKEFILE ON)
INCLUDE(biicode/cmake/tools)
INCLUDE(configure.cmake)

# Initializes block variables
INIT_BIICODE_BLOCK()

# Only interface lib, manual libraries
SET(BII_LIB_SRC )

ADD_BIICODE_TARGETS()


################### ssl lib target ##################################
if( BUILD_SHARED_LIBS )
    add_definitions ( -DOPENSSL_BUILD_SHLIBSSL )
endif()

set (SSL_LIB_SOURCES  ssl/bio_ssl.c ssl/d1_lib.c ssl/d1_srvr.c ssl/s23_lib.c ssl/s2_clnt.c ssl/s2_pkt.c ssl/s3_clnt.c ssl/s3_pkt.c ssl/ssl_cert.c ssl/ssl_lib.c ssl/t1_clnt.c ssl/t1_reneg.c ssl/d1_both.c ssl/d1_meth.c ssl/heartbeat_test.c ssl/s23_meth.c ssl/s2_enc.c ssl/s2_srvr.c ssl/s3_enc.c ssl/s3_srvr.c ssl/ssl_ciph.c ssl/ssl_rsa.c ssl/ssltest.c ssl/t1_enc.c ssl/t1_srvr.c ssl/d1_clnt.c ssl/d1_pkt.c ssl/kssl.c ssl/s23_pkt.c ssl/s2_lib.c ssl/s3_both.c ssl/s3_lib.c ssl/ssl_algs.c ssl/ssl_err2.c ssl/ssl_sess.c ssl/ssl_txt.c ssl/t1_lib.c ssl/tls_srp.c ssl/d1_enc.c ssl/d1_srtp.c ssl/s23_clnt.c ssl/s23_srvr.c ssl/s2_meth.c ssl/s3_cbc.c ssl/s3_meth.c ssl/ssl_asn1.c ssl/ssl_err.c ssl/ssl_stat.c ssl/ssl_utst.c ssl/t1_meth.c )

add_library(ssl_lib ${SSL_LIB_SOURCES})
SET_TARGET_PROPERTIES(ssl_lib PROPERTIES COMPILE_DEFINITIONS "OPENSSL_NO_ASM")

##################### crypto lib #####################################
ADD_SUBDIRECTORY(crypto)
TARGET_LINK_LIBRARIES(ssl_lib PUBLIC crypto_lib)
SET_TARGET_PROPERTIES(crypto_lib PROPERTIES COMPILE_DEFINITIONS "OPENSSL_NO_ASM")

############# APPS OPEN SSL  ####################################

# Actually create targets: EXEcutables and libraries.
#set (BII_apps_openssl_SRC main.cpp) #)apps/s_cb.c apps/openssl.c apps/verify.c apps/asn1pars.c apps/req.c apps/dgst.c apps/dh.c apps/dhparam.c apps/enc.c apps/passwd.c apps/gendh.c apps/errstr.c apps/ca.c apps/pkcs7.c apps/crl2p7.c apps/crl.c apps/rsa.c apps/rsautl.c apps/dsa.c apps/dsaparam.c apps/ec.c apps/ecparam.c apps/x509.c  apps/genrsa.c apps/gendsa.c apps/genpkey.c apps/speed.c apps/s_time.c apps/apps.c apps/s_socket.c apps/app_rand.c apps/version.c apps/sess_id.c apps/ciphers.c apps/nseq.c apps/pkcs12.c apps/pkcs8.c apps/pkey.c apps/pkeyparam.c apps/pkeyutl.c apps/spkac.c apps/smime.c apps/cms.c apps/rand.c apps/engine.c apps/ocsp.c apps/prime.c apps/ts.c apps/srp.c)
set (apps_openssl_src # 
  apps/openssl.c apps/verify.c apps/asn1pars.c apps/req.c apps/dgst.c apps/dh.c apps/dhparam.c apps/enc.c apps/passwd.c apps/gendh.c apps/errstr.c
  apps/ca.c apps/pkcs7.c apps/crl2p7.c apps/crl.c apps/rsa.c apps/rsautl.c apps/dsa.c apps/dsaparam.c apps/ec.c apps/ecparam.c apps/x509.c
  apps/genrsa.c apps/gendsa.c apps/genpkey.c apps/s_server.c apps/s_client.c apps/speed.c apps/s_time.c apps/apps.c apps/s_cb.c
  apps/s_socket.c apps/app_rand.c apps/version.c apps/sess_id.c apps/ciphers.c apps/nseq.c apps/pkcs12.c apps/pkcs8.c apps/pkey.c
  apps/pkeyparam.c apps/pkeyutl.c apps/spkac.c apps/smime.c apps/cms.c apps/rand.c apps/engine.c apps/ocsp.c apps/prime.c apps/ts.c
  apps/srp.c )

ADD_EXECUTABLE(openssl ${apps_openssl_src} )
TARGET_LINK_LIBRARIES(openssl crypto_lib ssl_lib )

TARGET_INCLUDE_DIRECTORIES(openssl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/openssl)
TARGET_INCLUDE_DIRECTORIES(openssl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
TARGET_INCLUDE_DIRECTORIES(openssl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

IF(LINUX) #64
  MESSAGE(">>>>>>>>>>>>> Linux compilation <<<<<<<<<<<<<<<<<<<<<<<")
  #my @type=("char","short","int","long");
  SET_TARGET_PROPERTIES(openssl PROPERTIES COMPILE_DEFINITIONS "OPENSSL_NO_ASM;RC4_INT=unsigned char;RC4_CHUNK=unsigned long;DES_LONG=unsigned int;DES_UNROLL;TERMIO;L_ENDIAN;_REENTRANT;MONOLITH" COMPILE_FLAGS "-Wall -m64 -O3")
ENDIF()


if( WIN32 AND NOT CYGWIN )
  SET_TARGET_PROPERTIES(openssl PROPERTIES COMPILE_DEFINITIONS "OPENSSL_SYSNAME_WIN32;WIN32_LEAN_AND_MEAN;_WINDLL")
endif()


if( MINGW )
  set( CMAKE_SHARED_LINKER_FLAGS "-Wl,--export-all" )
endif()

TARGET_LINK_LIBRARIES(${BII_BLOCK_TARGET} INTERFACE ssl_lib)
TARGET_LINK_LIBRARIES(${BII_BLOCK_TARGET} INTERFACE crypto_lib)