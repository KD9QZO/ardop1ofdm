#
# ARDOPC Makefile
#

PREFIX ?= /usr/local

CROSS_COMPILE ?=

CC      ?= $(CROSS_COMPILE)gcc
CXX     ?= $(CROSS_COMPILE)g++
AS      ?= $(CROSS_COMPILE)as
LD      ?= $(CROSS_COMPILE)ld
AR      ?= $(CROSS_COMPILE)ar
OBJCOPY ?= $(CROSS_COMPILE)objcopy
OBJDUMP ?= $(CROSS_COMPILE)objdump
SIZE    ?= $(CROSS_COMPILE)size
NM      ?= $(CROSS_COMPILE)nm
CPP     ?= $(CROSS_COMPILE)cpp
A2L     ?= $(CROSS_COMPILE)addr2line
RANLIB  ?= $(CROSS_COMPILE)ranlib
READELF ?= $(CROSS_COMPILE)readelf
STRIP   ?= $(CROSS_COMPILE)strip

INSTALL ?= install
ECHO    ?= echo
LN      ?= ln
RM      ?= rm


OBJS := ofdm.o \
		LinSerial.o \
		KISSModule.o \
		pktARDOP.o \
		pktSession.o \
		BusyDetect.o \
		i2cDisplay.o \
		ALSASound.o \
		ARDOPC.o \
		ardopSampleArrays.o \
		ARQ.o \
		FFT.o \
		FEC.o \
		HostInterface.o \
		Modulate.o \
		rs.o \
		berlekamp.o \
		galois.o \
		SoundInput.o \
		TCPHostInterface.o \
		SCSHostInterface.o

# Configuration:

CSTD   ?= gnu11
CXXSTD ?= gnu++14
OPTLVL ?= 2
DBGLVL ?= 0

DEFINES := -DLINBPQ
EXTRA_DEFINES ?=

CFLAGS := -MMD -Wall -O$(OPTLVL) -g$(DBGLVL) -std=$(CSTD) $(DEFINES) $(EXTRA_DEFINES)
CXXFLAGS := -MMD -Wall -O$(OPTLVL) -g$(DBGLVL) -std=$(CXXSTD) $(DEFINES) $(EXTRA_DEFINES)

LIBS := -lrt -lm -lpthread -lasound

all: ardopc

ardopc: $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) $(LIBS) -o ardop1ofdm

install: ardop1ofdm
	$(INSTALL) ardop1ofdm $(PREFIX)/bin
	ln -sf $(PREFIX)/bin/ardop1ofdm $(PREFIX)/bin/ardop
#	$(INSTALL) ../initscripts/ardop.service /etc/systemd/system

-include *.d

clean :
	$(RM) -f ardop1ofdm *.o
