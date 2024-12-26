

########################################################################
# Project setup
########################################################################

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
PROJECT(ardop1ofdm C)

INCLUDE(GNUInstallDirs)

# CMP0075 Include file check macros honor CMAKE_REQUIRED_LIBRARIES
IF (POLICY CMP0075)
	CMAKE_POLICY(SET CMP0075 NEW)
ENDIF ()

# select the "Release" build type by default to get optimization flags
IF (NOT CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE "Release")
	MESSAGE(STATUS "Build type not specified: defaulting to Release.")
ENDIF (NOT CMAKE_BUILD_TYPE)
SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "")

LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

IF (NOT LIB_INSTALL_DIR)
	SET(LIB_INSTALL_DIR lib)
ENDIF ()

# Set the version information here
SET(VERSION_INFO_MAJOR_VERSION 0) # increment major on api compatibility changes
SET(VERSION_INFO_MINOR_VERSION 1) # increment minor on feature-level changes
SET(VERSION_INFO_PATCH_VERSION git) # increment patch for bug fixes and docs
INCLUDE(Version) # setup version info


# Set our own version info here...
# "1.0.4.1s-OFDMBPQ"

SET(VER_MAJOR 1)
SET(VER_MINOR 0)
SET(VER_PATCH 4)
SET(VER_SUBPATCH 1s)
SET(VER_SUFFIX OFDMBPQ)

SET(VER_STRING "${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}.${VER_SUBPATCH}-${VER_SUFFIX}")

SET(ARDOP_TCP_PORT 8515)
SET(ARDOP_CAT_TTY_DEVICE /dev/ttyUSB0)


########################################################################
# Compiler specific setup
########################################################################

IF (CMAKE_COMPILER_IS_GNUCC AND NOT WIN32)
	ADD_DEFINITIONS(-Wall)
	ADD_DEFINITIONS(-Wextra)
	ADD_DEFINITIONS(-Wno-unused-parameter)
	ADD_DEFINITIONS(-Wno-unused)
	ADD_DEFINITIONS(-Wsign-compare)
	ADD_DEFINITIONS(-Wdeclaration-after-statement)
	# http://gcc.gnu.org/wiki/Visibility
	ADD_DEFINITIONS(-fvisibility=hidden)
ENDIF ()

ADD_COMPILE_DEFINITIONS(-DVERSION_FROM_BUILD_SYSTEM)



########################################################################
# Find build dependencies
########################################################################

FIND_PACKAGE(PkgConfig)
FIND_PACKAGE(Threads)
FIND_PACKAGE(ALSA REQUIRED)


IF (NOT THREADS_FOUND)
	MESSAGE(FATAL_ERROR "pthreads required to compile ardop1ofdm")
ENDIF ()


########################################################################
# Setup the include and linker paths
########################################################################

INCLUDE_DIRECTORIES(
		${CMAKE_SOURCE_DIR}/include
		${THREADS_PTHREADS_INCLUDE_DIR}
		${ALSA_INCLUDE_DIRS}
		${CMAKE_CURRENT_BINARY_DIR}
)

#link_directories(
#    ...
#)

# Set component parameters
#set(INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/include CACHE INTERNAL "" FORCE)


########################################################################
# Create uninstall target
########################################################################

CONFIGURE_FILE(
		${CMAKE_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in
		${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
		@ONLY)

ADD_CUSTOM_TARGET(uninstall
		${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake
)



########################################################################
# Add subdirectories
########################################################################

ADD_SUBDIRECTORY(include)
ADD_SUBDIRECTORY(src)


###
# Create other files
###

CONFIGURE_FILE(
		${CMAKE_SOURCE_DIR}/include/Version.h.in
		${CMAKE_CURRENT_BINARY_DIR}/Version.h
		@ONLY
)

CONFIGURE_FILE(
		${CMAKE_SOURCE_DIR}/cmake/ardop.service.in
		${CMAKE_CURRENT_BINARY_DIR}/ardop.service
		@ONLY
)


########################################################################
# Create Pkg Config File
########################################################################

#FOREACH (inc ${LIBUSB_INCLUDE_DIR})
#	LIST(APPEND FL2K_PC_CFLAGS "-I${inc}")
#ENDFOREACH (inc)
#
#FOREACH (lib ${LIBUSB_LIBRARY_DIRS})
#	LIST(APPEND FL2K_PC_LIBS "-L${lib}")
#ENDFOREACH (lib)
#
## use space-separation format for the pc file
#STRING(REPLACE ";" " " FL2K_PC_CFLAGS "${FL2K_PC_CFLAGS}")
#STRING(REPLACE ";" " " FL2K_PC_LIBS "${FL2K_PC_LIBS}")
#
## unset these vars to avoid hard-coded paths to cross environment
#IF (CMAKE_CROSSCOMPILING)
#	UNSET(FL2K_PC_CFLAGS)
#	UNSET(FL2K_PC_LIBS)
#ENDIF (CMAKE_CROSSCOMPILING)

SET(prefix ${CMAKE_INSTALL_PREFIX})
SET(exec_prefix \${prefix})
SET(libdir \${exec_prefix}/${LIB_INSTALL_DIR})
SET(includedir \${prefix}/include)





########################################################################
# Print Summary
########################################################################

#MESSAGE(STATUS "Building for version: ${VERSION} / ${LIBVER}")
MESSAGE(STATUS "Building version: ${VER_STRING}")
MESSAGE(STATUS "Using install prefix: ${CMAKE_INSTALL_PREFIX}")
