# ROOT is a special case
#
# find_ups_root(  minimum )
#  minimum - minimum version required

include(CheckUpsVersion)

# since variables are passed, this is implemented as a macro
macro( find_ups_root minimum )

# require ROOTSYS
set( ROOTSYS $ENV{ROOTSYS} )
if ( NOT ROOTSYS )
  message(FATAL_ERROR "root has not been setup")
endif ()

# only execute if this macro has not already been called
if( NOT ROOT_VERSION )
  ##message( STATUS "find_ups_root debug: ROOT_VERSION is NOT defined" )

SET ( ROOT_STRING $ENV{SETUP_ROOT} )
set( ROOT_VERSION $ENV{ROOT_VERSION} )
if ( NOT ROOT_VERSION )
   #message( STATUS "find_ups_root: calculating root version" )
   STRING( REGEX REPLACE "^[r][o][o][t][ ]+([^ ]+).*" "\\1" ROOT_VERSION "${ROOT_STRING}" )
endif ()

#message( STATUS "find_ups_root: checking root ${ROOT_VERSION} against ${minimum}" )
_check_version( ROOT ${ROOT_VERSION} ${minimum} )
set( ROOT_DOT_VERSION ${dotver} )
# compare for recursion
list(FIND cet_product_list root found_product_match)
if( ${found_product_match} LESS 0 )
  # add to product list
  set(CONFIG_FIND_UPS_COMMANDS "${CONFIG_FIND_UPS_COMMANDS}
  find_ups_root( ${minimum} )")
  set(cet_product_list root ${cet_product_list} )
endif()

STRING( REGEX MATCH "[-][q]" has_qual  "${ROOT_STRING}" )
STRING( REGEX MATCH "[-][j]" has_j  "${ROOT_STRING}" )
if( has_qual )
  if( has_j )
     STRING( REGEX REPLACE ".*([-][q]+ )(.*)[ *]([-][-j])" "\\2" ROOT_QUAL "${ROOT_STRING}" )
  else( )
     STRING( REGEX REPLACE ".*([-][q]+ )(.*)" "\\2" ROOT_QUAL "${ROOT_STRING}" )
  endif( )
  STRING( REGEX REPLACE ":" ";" ROOT_QUAL_LIST "${ROOT_QUAL}" )
  list(REMOVE_ITEM ROOT_QUAL_LIST debug opt prof)
  STRING( REGEX REPLACE ";" ":" ROOT_BASE_QUAL "${ROOT_QUAL_LIST}" )
else( )
  message(STATUS "ROOT has no qualifier")
endif( )
if( ${found_product_match} LESS 0 )
  _cet_debug_message("find_ups_root: ROOT version and qualifier are ${ROOT_VERSION} ${ROOT_QUAL}" )
endif()
#message(STATUS "ROOT base qualifier is ${ROOT_BASE_QUAL}" )

# add include directory to include path if it exists
include_directories ( $ENV{ROOT_INC} )

# define ROOT libraries
find_library(ROOT_ASIMAGE NAMES ASImage PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_ASIMAGEGUI NAMES ASImageGui PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_CINT NAMES Cint PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_CINTEX NAMES Cintex PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_CORE NAMES Core PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_EG NAMES EG PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_EGPYTHIA6 NAMES EGPythia6 PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_EVE NAMES Eve PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_FFTW NAMES FFTW PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_FITPANEL NAMES FitPanel PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_FOAM NAMES Foam PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_FTGL NAMES FTGL PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_FUMILI NAMES Fumili PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GDML NAMES Gdml PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GED NAMES Ged PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GENETIC NAMES Genetic PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GENVECTOR NAMES GenVector PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GEOM NAMES Geom PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GEOMBUILDER NAMES GeomBuilder PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GEOMPAINTER NAMES GeomPainter PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GLEW NAMES GLEW PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GPAD NAMES Gpad PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GRAF NAMES Graf PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GRAF3D NAMES Graf3d PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GUI NAMES Gui PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GUIBLD NAMES GuiBld PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GUIHTML NAMES GuiHtml PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GVIZ3D NAMES Gviz3d PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GX11 NAMES GX11 PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_GX11TTF NAMES GX11TTF PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_HBOOK NAMES Hbook PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_HIST NAMES Hist PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_HISTPAINTER NAMES HistPainter PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_HTML NAMES Html PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_KRB5AUTH NAMES Krb5Auth PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_MATHCORE NAMES MathCore PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_MATRIX NAMES Matrix PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_MEMSTAT NAMES MemStat PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_MINICERN NAMES minicern PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_MINUIT NAMES Minuit PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_MINUIT2 NAMES Minuit2 PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_MLP NAMES MLP PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_NET NAMES Net PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_NEW NAMES New PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_PHYSICS NAMES Physics PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_POSTSCRIPT NAMES Postscript PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_PROOF NAMES Proof PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_PROOFBENCH NAMES ProofBench PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_PROOFDRAW NAMES ProofDraw PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_PROOFPLAYER NAMES ProofPlayer PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_PYROOT NAMES PyROOT PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_QUADP NAMES Quadp PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_RECORDER NAMES Recorder PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_REFLEX NAMES Reflex PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_RGL NAMES RGL PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_RINT NAMES Rint PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_RIO NAMES RIO PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_ROOTAUTH NAMES RootAuth PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_SESSIONVIEWER NAMES SessionViewer PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_SMATRIX NAMES Smatrix PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_SPECTRUM NAMES Spectrum PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_SPECTRUMPAINTER NAMES SpectrumPainter PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_SPLOT NAMES SPlot PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_SQLIO NAMES SQLIO PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_SRVAUTH NAMES SrvAuth PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_THREAD NAMES Thread PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_TMVA NAMES TMVA PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_TREE NAMES Tree PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_TREEPLAYER NAMES TreePlayer PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_TREEVIEWER NAMES TreeViewer PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_VMC NAMES VMC PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_X3D NAMES X3d PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_XMLIO NAMES XMLIO PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)
find_library(ROOT_XMLPARSER NAMES XMLParser PATHS ${ROOTSYS}/lib NO_DEFAULT_PATH)

include_directories ( ${ROOTSYS}/include )
# define genreflex executable
find_program( ROOT_GENREFLEX NAMES genreflex PATHS $ENV{ROOTSYS}/bin NO_DEFAULT_PATH)
# check for the need to cleanup after genreflex
_check_if_version_greater( ROOT ${ROOT_VERSION} v5_28_00d )
   if ( ${product_version_less} MATCHES "TRUE" )
      set ( GENREFLEX_CLEANUP TRUE )
   else()
      set ( GENREFLEX_CLEANUP FALSE )
   endif()
   #message(STATUS "genreflex cleanup status: ${GENREFLEX_CLEANUP}")

# define rootcint executable
find_program( ROOTCINT NAMES rootcint PATHS ${ROOTSYS}/bin )

# define some useful library lists
set(ROOT_BASIC_LIB_LIST ${ROOT_CORE}
                        ${ROOT_CINT} 
                        ${ROOT_RIO}
                        ${ROOT_NET}
                        ${ROOT_HIST} 
                        ${ROOT_GRAF}
                        ${ROOT_GRAF3D}
                        ${ROOT_GPAD}
                        ${ROOT_TREE}
                        ${ROOT_RINT}
                        ${ROOT_POSTSCRIPT}
                        ${ROOT_MATRIX}
                        ${ROOT_PHYSICS}
                        ${ROOT_MATHCORE}
                        ${ROOT_THREAD}
)
set(ROOT_GUI_LIB_LIST   ${ROOT_GUI} ${ROOT_BASIC_LIB_LIST} )
set(ROOT_EVE_LIB_LIST   ${ROOT_EVE}
                        ${ROOT_EG}
                        ${ROOT_TREEPLAYER}
                        ${ROOT_GEOM}
                        ${ROOT_GED}
                        ${ROOT_RGL}
                        ${ROOT_GUI_LIB_LIST}
)
endif( NOT ROOT_VERSION )

endmacro( find_ups_root )
