INCLUDE(biicode/cmake/tools)

# CONFIGURE

include( CMakeParseArguments )

file( READ crypto/opensslconf.h.in CONF )
string( REPLACE "#undef OPENSSL_EXPORT_VAR_AS_FUNCTION" "#cmakedefine OPENSSL_EXPORT_VAR_AS_FUNCTION"
    CONF "${CONF}" )

set( CONF "
#define OPENSSL_NO_GMP
#define OPENSSL_NO_JPAKE
#define OPENSSL_NO_KRB5
#define OPENSSL_NO_MD2
#define OPENSSL_NO_RC5
#define OPENSSL_NO_RFC3779
#define OPENSSL_NO_STORE
#define OPENSSL_NO_DYNAMIC_ENGINE
#define OPENSSL_NO_SCTP
#define OPENSSL_NO_EC_NISTP_64_GCC_128
${CONF}" )
file( WRITE ${CMAKE_CURRENT_BINARY_DIR}/opensslconf.h.cmake "${CONF}" )

configure_file ( ${CMAKE_CURRENT_SOURCE_DIR}/crypto/buildinf.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/buildinf.h )

if( WIN32 AND MINGW AND NOT CYGWIN )
  set( OPENSSL_EXPORT_VAR_AS_FUNCTION true )
endif()

configure_file( ${CMAKE_CURRENT_BINARY_DIR}/opensslconf.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/openssl/opensslconf.h )

# Initializes block variables
INIT_BIICODE_BLOCK()

ADD_SUBDIRECTORY(crypto)
ADD_SUBDIRECTORY(ssl)
ADD_SUBDIRECTORY(apps)

## REMOVE SOURCES 
#IF(NOT APPLE)
#	REMOVE_IF_MATCHES(BII_LIB_SRC "MacOS/(.*)")
#	REMOVE_IF_MATCHES(BII_LIB_SRC "bugs/(.*)")
	# TODO! Develop a configure to maybe detect ARM (see include detection in arm_arch.h)
#	REMOVE_IF_MATCHES(BII_LIB_SRC "crypto/arm(.*)")
#	REMOVE_IF_MATCHES(BII_LIB_SRC "crypto/bf/bf_opts.c")
#	REMOVE_IF_MATCHES(BII_LIB_SRC "crypto/bf/bfs.c")
#ENDIF()

#REMOVE_IF_MATCHES(BII_LIB_SRC "crypto/LPdir(.*)")

if( WIN32 AND MINGW AND NOT CYGWIN )
  set( OPENSSL_EXPORT_VAR_AS_FUNCTION true )
endif()

# Actually create targets: EXEcutables and libraries.
ADD_BIICODE_TARGETS()


# ADD CONFIGURED FILED TO TARGET
TARGET_INCLUDE_DIRECTORIES(${BII_BLOCK_TARGET} INTERFACE ${CMAKE_CURRENT_BINARY_DIR})


# REMOVE TARGETS
IF(NOT APPLE)
	LIST(REMOVE_ITEM BII_BLOCK_EXES MacOS_GetHTTPS.src_GetHTTPS)
	REMOVE_IF_MATCHES(BII_LIB_SRC "(.*)MacOS(.*)")
ENDIF()


