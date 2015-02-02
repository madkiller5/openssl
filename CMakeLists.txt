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

################### ssl lib target ##################################
if( BUILD_SHARED_LIBS )
  add_definitions ( -DOPENSSL_BUILD_SHLIBSSL )
endif()

#MESSAGE(LIBSRC=${BII_LIB_SRC})

set (ALL_SSL_LIB_SOURCES ssl/bio_ssl.c ssl/d1_lib.c ssl/d1_srvr.c ssl/s23_lib.c ssl/s2_clnt.c ssl/s2_pkt.c ssl/s3_clnt.c ssl/s3_pkt.c ssl/ssl_cert.c ssl/ssl_lib.c ssl/t1_clnt.c ssl/t1_reneg.c ssl/d1_both.c ssl/d1_meth.c ssl/heartbeat_test.c ssl/s23_meth.c ssl/s2_enc.c ssl/s2_srvr.c ssl/s3_enc.c ssl/s3_srvr.c ssl/ssl_ciph.c ssl/ssl_rsa.c ssl/ssltest.c ssl/t1_enc.c ssl/t1_srvr.c ssl/d1_clnt.c ssl/d1_pkt.c ssl/kssl.c ssl/s23_pkt.c ssl/s2_lib.c ssl/s3_both.c ssl/s3_lib.c ssl/ssl_algs.c ssl/ssl_err2.c ssl/ssl_sess.c ssl/ssl_txt.c ssl/t1_lib.c ssl/tls_srp.c ssl/d1_enc.c ssl/d1_srtp.c ssl/s23_clnt.c ssl/s23_srvr.c ssl/s2_meth.c ssl/s3_cbc.c ssl/s3_meth.c ssl/ssl_asn1.c ssl/ssl_err.c ssl/ssl_stat.c ssl/ssl_utst.c ssl/t1_meth.c )
IF(BII_LIB_SRC)
	INTERSECTION(SSL_LIB_SOURCES "${ALL_SSL_LIB_SOURCES}" "${BII_LIB_SRC}")
ELSE()
	SET(SSL_LIB_SOURCES ${ALL_SSL_LIB_SOURCES})
ENDIF()

add_library(ssl_lib ${SSL_LIB_SOURCES})
TARGET_COMPILE_OPTIONS(ssl_lib PUBLIC -DOPENSSL_NO_ASM)
IF(WIN32)
	IF(MINGW)
		TARGET_COMPILE_OPTIONS(ssl_lib PRIVATE -DOPENSSL_NO_SOCK)
	ENDIF()
ENDIF()

TARGET_INCLUDE_DIRECTORIES(ssl_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/crypto)
TARGET_INCLUDE_DIRECTORIES(ssl_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/openssl)
TARGET_INCLUDE_DIRECTORIES(ssl_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
TARGET_INCLUDE_DIRECTORIES(ssl_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

##################### crypto lib #####################################
ADD_SUBDIRECTORY(crypto)

TARGET_LINK_LIBRARIES(ssl_lib PUBLIC crypto_lib)
############# APPS OPEN SSL  ####################################

# Actually create targets: EXEcutables and libraries.
set (ALL_APPS_OPENSSL_SRC # 
  apps/openssl.c apps/verify.c apps/asn1pars.c apps/req.c apps/dgst.c apps/dh.c apps/dhparam.c apps/enc.c apps/passwd.c apps/gendh.c apps/errstr.c
  apps/ca.c apps/pkcs7.c apps/crl2p7.c apps/crl.c apps/rsa.c apps/rsautl.c apps/dsa.c apps/dsaparam.c apps/ec.c apps/ecparam.c apps/x509.c
  apps/genrsa.c apps/gendsa.c apps/genpkey.c apps/s_server.c apps/s_client.c apps/speed.c apps/s_time.c apps/apps.c apps/s_cb.c
  apps/s_socket.c apps/app_rand.c apps/version.c apps/sess_id.c apps/ciphers.c apps/nseq.c apps/pkcs12.c apps/pkcs8.c apps/pkey.c
  apps/pkeyparam.c apps/pkeyutl.c apps/spkac.c apps/smime.c apps/cms.c apps/rand.c apps/engine.c apps/ocsp.c apps/prime.c apps/ts.c
  apps/srp.c )

IF(BII_LIB_SRC)
	INTERSECTION(APPS_OPENSSL_SRC "${ALL_APPS_OPENSSL_SRC}" "${BII_LIB_SRC}")
	#MESSAGE(INTERSECTION OF APP SOURCES: ${APPS_OPENSSL_SRC})
ELSE()
	SET(APPS_OPENSSL_SRC ${ALL_APPS_OPENSSL_SRC})
ENDIF()

IF(APPS_OPENSSL_SRC)

	ADD_EXECUTABLE(openssl ${APPS_OPENSSL_SRC} )
	TARGET_LINK_LIBRARIES(openssl PUBLIC crypto_lib ssl_lib )
	TARGET_INCLUDE_DIRECTORIES(openssl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/openssl)
	TARGET_INCLUDE_DIRECTORIES(openssl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
	TARGET_INCLUDE_DIRECTORIES(openssl PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

	#target_compile_options
	TARGET_COMPILE_OPTIONS(openssl PUBLIC -DMONOLITH)

	IF(LINUX) #64 
	  MESSAGE(">>>>>>>>>>>>> Linux system <<<<<<<<<<<<<<<<<<<<<<<")
	  #my @type=("char","short","int","long");
	  SET(COMPILE_OPTIONS -DOPENSSL_NO_ASM "-DRC4_INT=unsigned char" "-DRC4_CHUNK=unsigned long" "-DDES_LONG=unsigned int" -DDES_UNROLL -DTERMIO -DL_ENDIAN -D_REENTRANT)
	  TARGET_COMPILE_OPTIONS(openssl PUBLIC ${COMPILE_OPTIONS})
	  SET_TARGET_PROPERTIES(openssl PROPERTIES COMPILE_FLAGS "-Wall -m64 -O3")
	ENDIF()

	IF(WIN32) # Windows
	    MESSAGE(">>>>>>>>>>> WINDOWS <<<<<<<<<<<<<")
		if(MINGW)
	      #"mingw", "gcc:-mno-cygwin -DL_ENDIAN -DWIN32_LEAN_AND_MEAN -fomit-frame-pointer -O3 -march=i486 -Wall::-D_MT:MINGW32:-lws2_32 -lgdi32 -lcrypt32:BN_LLONG ${x86_gcc_des} ${x86_gcc_opts} EXPORT_VAR_AS_FN:${x86_asm}:coff:win32:cygwin-shared:-D_WINDLL -DOPENSSL_USE_APPLINK:-mno-cygwin:.dll.a",
		  MESSAGE(">>>>>>>>>>>>> MINGW <<<<<<<<<<<<<<<<<<<<<<<")
		  set( CMAKE_SHARED_LINKER_FLAGS "-Wl,--export-all" )
		  TARGET_COMPILE_OPTIONS(openssl PUBLIC -DL_ENDIAN -DWIN32_LEAN_AND_MEAN -D_WINDLL -DOPENSSL_USE_APPLINK)
		  SET_TARGET_PROPERTIES(openssl PROPERTIES COMPILE_FLAGS "-fomit-frame-pointer -O3 -Wall -march=i486")
		  TARGET_LINK_LIBRARIES(openssl PUBLIC ws2_32 gdi32 crypt32)
		  
		ELSEIF(NOT CYGWIN)
		  MESSAGE(">>>>>>>>>>>>> Windows Visual <<<<<<<<<<<<<<<<<<<<<<<")
		  TARGET_COMPILE_OPTIONS(openssl PUBLIC -DOPENSSL_SYSNAME_WIN32 -DWIN32_LEAN_AND_MEAN -D_WINDLL)
		endif()
	ENDIF()
ENDIF()

# Only interface lib, manual libraries
SET(BII_LIB_SRC )

ADD_BIICODE_TARGETS()

TARGET_INCLUDE_DIRECTORIES(${BII_LIB_TARGET} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/include/openssl)
TARGET_INCLUDE_DIRECTORIES(${BII_LIB_TARGET} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/include)
TARGET_INCLUDE_DIRECTORIES(${BII_LIB_TARGET} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
TARGET_INCLUDE_DIRECTORIES(${BII_LIB_TARGET} INTERFACE ${CMAKE_CURRENT_BINARY_DIR})

IF(SSL_LIB_SOURCES)
	TARGET_LINK_LIBRARIES(ssl_lib PUBLIC ${BII_BLOCK_TARGET})
	TARGET_LINK_LIBRARIES(${BII_LIB_TARGET} INTERFACE ssl_lib)
ENDIF()

IF(CRYPTO_LIBSRC)
	TARGET_LINK_LIBRARIES(crypto_lib PUBLIC ${BII_BLOCK_TARGET})
	TARGET_LINK_LIBRARIES(${BII_LIB_TARGET} INTERFACE crypto_lib)
ENDIF()

