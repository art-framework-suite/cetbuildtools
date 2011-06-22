# This macro is used by the FindUps modules

#internal macro
macro(_parse_version version )
   # standard case
   # convert vx_y_z to x.y.z
   # special cases
   # convert va_b_c_d to a.b.c.d
   # convert vx_y to x.y
   
   # replace all underscores with dots
   STRING( REGEX REPLACE "_" "." dotver1 "${version}" )
   STRING( REGEX REPLACE "v(.*)" "\\1" dotver "${dotver1}" )
   ##message( STATUS "_parse_version: ${version} becomes ${dotver}" )
   string(REGEX MATCHALL "_" nfound ${version} )
   ##message( STATUS "_parse_version: matchall returns ${nfound}" )
   list(LENGTH nfound nfound)
   ##message( STATUS "_parse_version: nfound is now ${nfound} " )
   if( ${nfound} EQUAL 3 )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\1" major "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\2" minor "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\3" patch "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\4" micro "${version}" )
   elseif( ${nfound} EQUAL 2 )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)" "\\1" major "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)" "\\2" minor "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)" "\\3" patch "${version}" )
      set( micro "0")
   elseif( ${nfound} EQUAL 1 )
      STRING( REGEX REPLACE "v(.*)_(.*)" "\\1" major "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)" "\\2" minor "${version}" )
      set( patch "0")
      set( micro "0")
   elseif( ${nfound} EQUAL 0 )
      STRING( REGEX REPLACE "v(.*)" "\\1" major "${version}" )
      set( minor "0")
      set( patch "0")
      set( micro "0")
   else()
      message( STATUS "_parse_version found extra underscores in ${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\1" major "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\2" minor "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\3" patch "${version}" )
      STRING( REGEX REPLACE "v(.*)_(.*)_(.*)_(.*)" "\\4" micro "${version}" )
   endif()
   ##message( STATUS "_parse_version: major ${major} " )
   ##message( STATUS "_parse_version: minor ${minor} " )
   ##message( STATUS "_parse_version: patch ${patch} " )
   ##message( STATUS "_parse_version: micro ${micro}" )
   string(TOUPPER  ${patch} PATCH_UC )
   STRING(REGEX MATCH [A-Z] has_alpha ${PATCH_UC})
   if( has_alpha )
      #message( STATUS "deal with alphabetical character in patch version ${patch}" )
      STRING(REGEX REPLACE "(.*)([A-Z])" "\\1" patch  ${PATCH_UC})
      STRING(REGEX REPLACE "(.*)([A-Z])" "\\2" patchchar  ${PATCH_UC})
   else( has_alpha )
      set( patchchar " ")
   endif( has_alpha )
endmacro(_parse_version)

macro( _check_version product version minimum )

  _check_if_version_greater( ${product} ${version} ${minimum} )
  if( ${product_version_less} MATCHES "TRUE" )
    message( FATAL_ERROR "Bad Version: ${product} ${THISVER} is less than minimum required version ${MINVER}")
  endif()

  message( STATUS "${product} ${THISVER} meets minimum required version ${MINVER}")
endmacro( _check_version product version minimum )
 
macro( _compare_root_micro microversion micromin )
   # root release old numbering:
   # 5.28.00.rc1 (release candidate)
   # 5.28.00 (release)
   # 5.28.00.p01 (fermi patch release)
   # 5.28.00a (patch release)
   # root release new numbering:
   # 5.30.00.rc1 (release candidate)
   # 5.30.00 (release)
   # 5.30.00.p01 (fermi patch release)
   # 5.30.01 (patch release)
   # 5.30.01.p01 (fermi patch release)
   ##message(STATUS "_compare_root_micro: check ${microversion} against ${micromin}")   
   string(TOUPPER  ${microversion} VERUC )
   STRING(REGEX MATCH [R][C] rcver ${VERUC})
   if( rcver )
      STRING(REGEX REPLACE "[R][C](.*)" "\\1" rcvnum  ${VERUC})
      ##message(STATUS "_compare_root_micro: version is release candidate ${microversion} ${rcvnum}")
   endif( rcver )
   STRING(REGEX MATCH [P] fermipatch ${VERUC})
   if( fermipatch )
      STRING(REGEX REPLACE "[P](.*)" "\\1" pvnum  ${VERUC})
      ##message(STATUS "_compare_root_micro: version is fermi patch ${microversion} ${pvnum}")
   endif( fermipatch )
   string(TOUPPER  ${micromin} MINUC )
   STRING(REGEX MATCH [R][C] rcmin ${MINUC})
   if( rcmin )
      STRING(REGEX REPLACE "[R][C](.*)" "\\1" rcminnum  ${MINUC})
   endif( rcmin )
   STRING(REGEX MATCH [P] fermipatchmin ${MINUC})
   if( fermipatchmin )
      STRING(REGEX REPLACE "[P](.*)" "\\1" pminnum  ${MINUC})
   endif( fermipatchmin )
   
   # is the minimum microversion a fermi patch?
   # when comparing microversions, a fermi patch should trump everything else
   if( fermipatchmin )
      ##message(STATUS "_compare_root_micro: minimum is fermi patch ${micromin} ${pminnum}")
      if( fermipatch )
         if(  ${pvnum} LESS ${pminnum} )
            set( product_version_less TRUE )
	 endif()
      else()
        set( product_version_less TRUE )
      endif()
   endif( fermipatchmin )
   # is the minimum microversion a release candidate?
   # when comparing microversions, everything else is better than a release candidate
   if( rcmin )
      ##message(STATUS "_compare_root_micro: minimum is release candidate ${micromin} ${rcminnum}")
      if( rcver )
         if(  ${rcvnum} LESS ${rcminnum} )
            set( product_version_less TRUE )
	 endif()
      endif()
   endif( rcmin )
endmacro( _compare_root_micro microversion micromin )

macro( _check_if_version_greater product version minimum )
   _parse_version( ${minimum}  )
   set( MINVER ${dotver} )
   set( MINMAJOR ${major} )
   set( MINMINOR ${minor} )
   set( MINPATCH ${patch} )
   set( MINCHAR ${patchchar} )
   set( MINMICRO ${micro} )
   _parse_version( ${version}  )
   set( THISVER ${dotver} )
   set( THISMAJOR ${major} )
   set( THISMINOR ${minor} )
   set( THISPATCH ${patch} )
   set( THISCHAR ${patchchar} )
   set( THISMICRO ${micro} )
   #message(STATUS "_check_if_version_greater: ${product} minimum version is ${MINVER} ${MINMAJOR} ${MINMINOR} ${MINPATCH} ${MINCHAR} ${MINMICRO} from ${minimum} " )
   #message(STATUS "_check_if_version_greater: ${product} version is ${THISVER} ${THISMAJOR} ${THISMINOR} ${THISPATCH} ${THISCHAR} ${THISMICRO} from ${version} " )
  # initialize product_version_less
  set( product_version_less FALSE )
  if( ${product} MATCHES "ROOT" )
     if( ${THISMAJOR} LESS ${MINMAJOR} )
       set( product_version_less TRUE )
     elseif( ${THISMAJOR} EQUAL ${MINMAJOR}
	 AND ${THISMINOR} LESS ${MINMINOR} )
       set( product_version_less TRUE )
     elseif( ${THISMAJOR} EQUAL ${MINMAJOR}
	 AND ${THISMINOR} EQUAL ${MINMINOR}
	 AND ${THISPATCH} LESS ${MINPATCH} )
       set( product_version_less TRUE )
     elseif( ${THISMAJOR} EQUAL ${MINMAJOR}
	 AND ${THISMINOR} EQUAL ${MINMINOR}
	 AND ${THISPATCH} EQUAL ${MINPATCH}
	 AND ${THISCHAR} STRLESS ${MINCHAR} )
       set( product_version_less TRUE )
     endif()
     # root micro versions require special handling
     if( NOT  product_version_less )
        _compare_root_micro( ${THISMICRO} ${MINMICRO} )
     endif( NOT  product_version_less )
  else()
     if( ${THISMAJOR} LESS ${MINMAJOR} )
       set( product_version_less TRUE )
     elseif( ${THISMAJOR} EQUAL ${MINMAJOR}
	 AND ${THISMINOR} LESS ${MINMINOR} )
       set( product_version_less TRUE )
     elseif( ${THISMAJOR} EQUAL ${MINMAJOR}
	 AND ${THISMINOR} EQUAL ${MINMINOR}
	 AND ${THISPATCH} LESS ${MINPATCH} )
       set( product_version_less TRUE )
     elseif( ${THISMAJOR} EQUAL ${MINMAJOR}
	 AND ${THISMINOR} EQUAL ${MINMINOR}
	 AND ${THISPATCH} EQUAL ${MINPATCH}
	 AND ${THISCHAR} STRLESS ${MINCHAR} )
       set( product_version_less TRUE )
     elseif( ${THISMAJOR} EQUAL ${MINMAJOR}
	 AND ${THISMINOR} EQUAL ${MINMINOR}
	 AND ${THISPATCH} EQUAL ${MINPATCH}
	 AND ${THISCHAR} STREQUAL ${MINCHAR} 
	 AND ${THISMICRO} LESS ${MINMICRO} )
       set( product_version_less TRUE )
     endif()
  endif()
  #message( STATUS "_check_if_version_greater: ${product} ${THISVER} check if greater returns ${product_version_less}")
endmacro( _check_if_version_greater product version minimum )
