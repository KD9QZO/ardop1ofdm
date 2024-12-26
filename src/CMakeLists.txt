
INCLUDE(GNUInstallDirs)

MACRO(ARDOP1OFDM_APPEND_SRCS)
	LIST(APPEND ardop1ofdm_srcs ${ARGV})
ENDMACRO(ARDOP1OFDM_APPEND_SRCS)


# OBJS := ofdm.o \
#		LinSerial.o \
#		KISSModule.o \
#		pktARDOP.o \
#		pktSession.o \
#		BusyDetect.o \
#		i2cDisplay.o \
#		ALSASound.o \
#		ARDOPC.o \
#		ardopSampleArrays.o \
#		ARQ.o \
#		FFT.o \
#		FEC.o \
#		HostInterface.o \
#		Modulate.o \
#		rs.o \
#		berlekamp.o \
#		galois.o \
#		SoundInput.o \
#		TCPHostInterface.o \
#		SCSHostInterface.o

ARDOP1OFDM_APPEND_SRCS(
		ofdm.c
		LinSerial.c
		KISSModule.c
		pktARDOP.c
		pktSession.c
		BusyDetect.c
		i2cDisplay.c
		ALSASound.c
		ARDOPC.c
		ardopSampleArrays.c
		ARQ.c
		FFT.c
		FEC.c
		HostInterface.c
		Modulate.c
		rs.c
		berlekamp.c
		galois.c
		SoundInput.c
		TCPHostInterface.c
		SCSHostInterface.c
)


########################################################################
# Set up Windows DLL resource files
########################################################################

#IF (MSVC)
#	INCLUDE(${CMAKE_SOURCE_DIR}/cmake/Modules/Version.cmake)
#
#	CONFIGURE_FILE(
#			${CMAKE_CURRENT_SOURCE_DIR}/libosmo-fl2k.rc.in
#			${CMAKE_CURRENT_BINARY_DIR}/libosmo-fl2k.rc
#			@ONLY)
#
#	LIBFL2K_APPEND_SRCS(${CMAKE_CURRENT_BINARY_DIR}/libosmo-fl2k.rc)
#ENDIF (MSVC)


########################################################################
# Setup shared library variant
########################################################################

#ADD_LIBRARY(libosmo-fl2k_shared SHARED ${libosmo-fl2k_srcs})
#TARGET_LINK_LIBRARIES(libosmo-fl2k_shared ${LIBUSB_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
#SET_TARGET_PROPERTIES(libosmo-fl2k_shared PROPERTIES DEFINE_SYMBOL "libosmofl2k_EXPORTS")
#SET_TARGET_PROPERTIES(libosmo-fl2k_shared PROPERTIES OUTPUT_NAME osmo-fl2k)
#SET_TARGET_PROPERTIES(libosmo-fl2k_shared PROPERTIES SOVERSION ${MAJOR_VERSION})
#SET_TARGET_PROPERTIES(libosmo-fl2k_shared PROPERTIES VERSION ${LIBVER})


########################################################################
# Setup static library variant
########################################################################

#ADD_LIBRARY(libosmo-fl2k_static STATIC ${libosmo-fl2k_srcs})
#TARGET_LINK_LIBRARIES(libosmo-fl2k_static ${LIBUSB_LIBRARIES})
#SET_PROPERTY(TARGET libosmo-fl2k_static APPEND PROPERTY COMPILE_DEFINITIONS "libosmofl2k_STATIC")
#IF (NOT WIN32)
#	# Force same library filename for static and shared variants of the library
#	SET_TARGET_PROPERTIES(libosmo-fl2k_static PROPERTIES OUTPUT_NAME osmo-fl2k)
#ENDIF ()


########################################################################
# Setup libraries used in executables
########################################################################

#IF (WIN32 AND NOT MINGW)
#	ADD_LIBRARY(libgetopt_static STATIC
#			getopt/getopt.c
#	)
#	TARGET_LINK_LIBRARIES(
#			libosmo-fl2k_shared
#	)
#ENDIF ()


########################################################################
# Build utility
########################################################################

#ADD_EXECUTABLE(fl2k_file fl2k_file.c)
#ADD_EXECUTABLE(fl2k_tcp fl2k_tcp.c)
#ADD_EXECUTABLE(fl2k_test fl2k_test.c)
#ADD_EXECUTABLE(fl2k_fm fl2k_fm.c rds_waveforms.c rds_mod.c)

ADD_EXECUTABLE(ardop1ofdm ${ardop1ofdm_srcs})

#SET(INSTALL_TARGETS libosmo-fl2k_shared libosmo-fl2k_static fl2k_file fl2k_tcp fl2k_test fl2k_fm)

SET(INSTALL_TARGETS ardop1ofdm)

#TARGET_LINK_LIBRARIES(fl2k_file libosmo-fl2k_shared
#		${LIBUSB_LIBRARIES}
#		${CMAKE_THREAD_LIBS_INIT}
#)
#
#TARGET_LINK_LIBRARIES(fl2k_tcp libosmo-fl2k_shared
#		${LIBUSB_LIBRARIES}
#		${CMAKE_THREAD_LIBS_INIT}
#)
#
#TARGET_LINK_LIBRARIES(fl2k_test libosmo-fl2k_shared
#		${LIBUSB_LIBRARIES}
#		${CMAKE_THREAD_LIBS_INIT}
#)
#
#TARGET_LINK_LIBRARIES(fl2k_fm libosmo-fl2k_shared
#		${LIBUSB_LIBRARIES}
#		${CMAKE_THREAD_LIBS_INIT}
#)

TARGET_LINK_LIBRARIES(ardop1ofdm ${CMAKE_THREAD_LIBS_INIT})


FIND_LIBRARY(LIBRT rt)

IF (LIBRT)
	MESSAGE("Found librt: ${LIBRT}")
	TARGET_LINK_LIBRARIES(ardop1ofdm ${LIBRT})
ELSE ()
	MESSAGE(FATAL_ERROR "librt not found")
ENDIF()

TARGET_LINK_LIBRARIES(ardop1ofdm m)

if (ALSA_FOUND)
	MESSAGE("Found libasound: ${ALSA_LIBRARY}")
	TARGET_LINK_LIBRARIES(ardop1ofdm ${ALSA_LIBRARIES})
else ()
	MESSAGE(FATAL_ERROR "libasound not found")
ENDIF ()


#IF (WIN32 AND NOT MINGW)
#	TARGET_LINK_LIBRARIES(fl2k_file libgetopt_static)
#	TARGET_LINK_LIBRARIES(fl2k_tcp ws2_32 libgetopt_static)
#	TARGET_LINK_LIBRARIES(fl2k_test libgetopt_static)
#	TARGET_LINK_LIBRARIES(fl2k_fm libgetopt_static)
#	SET_PROPERTY(TARGET fl2k_file APPEND PROPERTY COMPILE_DEFINITIONS "libosmo-fl2k_STATIC")
#	SET_PROPERTY(TARGET fl2k_tcp APPEND PROPERTY COMPILE_DEFINITIONS "libosmo-fl2k_STATIC")
#	SET_PROPERTY(TARGET fl2k_test APPEND PROPERTY COMPILE_DEFINITIONS "libosmo-fl2k_STATIC")
#	SET_PROPERTY(TARGET fl2k_fm APPEND PROPERTY COMPILE_DEFINITIONS "libosmo-fl2k_STATIC")
#ENDIF ()
#
#IF (MINGW)
#	TARGET_LINK_LIBRARIES(fl2k_tcp ws2_32)
#ENDIF ()


########################################################################
# Install built library files & utilities
########################################################################

INSTALL(TARGETS ${INSTALL_TARGETS}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} # .so/.dylib file
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR} # .lib file
		RUNTIME DESTINATION bin              # .dll file
)
