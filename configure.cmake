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

include( CMakeParseArguments )

file( READ crypto/opensslconf.h.in CONF )
string( REPLACE "#undef OPENSSL_EXPORT_VAR_AS_FUNCTION" "#cmakedefine OPENSSL_EXPORT_VAR_AS_FUNCTION"
    CONF "${CONF}" )

set( CONF "
#define OPENSSL_NO_GMP
#define OPENSSL_NO_JPAKE
#define OPENSSL_NO_KRB5
#define OPENSSL_NO_MD2
#define OPENSSL_NO_RFC3779
#define OPENSSL_NO_STORE
#define OPENSSL_NO_DYNAMIC_ENGINE
#define OPENSSL_NO_SCTP
#define OPENSSL_NO_EC_NISTP_64_GCC_128
#define OPENSSL_NO_GOST
${CONF}" )
file( WRITE ${CMAKE_CURRENT_BINARY_DIR}/opensslconf.h.cmake "${CONF}" )

configure_file ( ${CMAKE_CURRENT_SOURCE_DIR}/crypto/buildinf.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/buildinf.h )

if( WIN32 AND MINGW AND NOT CYGWIN )
  set( OPENSSL_EXPORT_VAR_AS_FUNCTION true )
endif()

configure_file( ${CMAKE_CURRENT_BINARY_DIR}/opensslconf.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/openssl/opensslconf.h )
