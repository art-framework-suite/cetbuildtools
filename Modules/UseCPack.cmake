# define the environment for cpack
# 
include(FindCompilerVersion)

# note that parse_ups_version is used to define VERSION_MAJOR, etc.
set( CPACK_PACKAGE_VERSION_MAJOR ${VERSION_MAJOR} )
set( CPACK_PACKAGE_VERSION_MINOR ${VERSION_MINOR} )
set( CPACK_PACKAGE_VERSION_PATCH ${VERSION_PATCH} )

set( CPACK_INCLUDE_TOPLEVEL_DIRECTORY 0 )
set( CPACK_GENERATOR TGZ )
   
find_compiler()

if ( ${SLTYPE} MATCHES "noarch" )
  set( PACKAGE_BASENAME ${SLTYPE} )
else ()
  if ( NOT Using_COMPILER )
    set( PACKAGE_BASENAME ${SLTYPE}-${CMAKE_SYSTEM_PROCESSOR} )
  else ()
    set( PACKAGE_BASENAME ${SLTYPE}-${CMAKE_SYSTEM_PROCESSOR}${Using_COMPILER} )
  endif ()
endif ()
if ( NOT qualifier )
  set( CPACK_SYSTEM_NAME ${PACKAGE_BASENAME} )
else ()
  set( CPACK_SYSTEM_NAME ${PACKAGE_BASENAME}-${qualifier} )
endif ()
message(STATUS "CPACK_SYSTEM_NAME = ${CPACK_SYSTEM_NAME}" )


include(CPack)
