#
# Modify these two flags according to your system
#
# The directory where jni.h is to be found
JNI_H_PATH ?= /usr/lib/jvm/java-8-jdk/include
#JNI_H_PATH = /usr/lib/jvm/java-6-sun-1.6.0.17/include/
# Where jni_md.h is to be found
JNI_MD_H_PATH ?= /usr/lib/jvm/java-8-jdk/include/linux
#JNI_MD_H_PATH = /usr/lib/jvm/java-6-sun-1.6.0.17/include/linux


JNI_INCLUDE = -I$(JNI_H_PATH) -I$(JNI_MD_H_PATH)

# Target platform selection ("native" or "windows")
TARGET_OS ?= native

PIC_FLAG ?= -fPIC

ifeq ($(TARGET_OS),windows)
PIC_FLAG :=
SHARED_LIB_EXT ?= dll
SHARED_LDFLAGS ?= -shared -Wl,--out-implib,lib/libjbliss.a
else
SHARED_LIB_EXT ?= so
SHARED_LDFLAGS ?= -shared -Wl,-soname,libjbliss.$(SHARED_LIB_EXT)
endif

LIB_OUTPUT ?= lib/libjbliss.$(SHARED_LIB_EXT)

# Where the true bliss is to be found
BLISS_DIR ?= ./bliss-0.50
# bliss sources, objects, and compiler options
BLISS_SRCS += $(BLISS_DIR)/graph.cc
BLISS_SRCS += $(BLISS_DIR)/partition.cc
BLISS_SRCS += $(BLISS_DIR)/orbit.cc
BLISS_SRCS += $(BLISS_DIR)/uintseqhash.cc
BLISS_SRCS += $(BLISS_DIR)/heap.cc
BLISS_SRCS += $(BLISS_DIR)/timer.cc
BLISS_OBJS = $(addsuffix .o, $(basename $(BLISS_SRCS)))
BLISS_CC ?= g++
BLISS_CCFLAGS ?= -O3 -Wall --pedantic $(PIC_FLAG)

#
JAVA_SRCDIR = ./src
JAVA_PREFIX = fi/tkk/ics/jbliss
JAVA_SRCS += Graph.java
JAVA_SRCS += Utils.java
JAVA_SRCS += Reporter.java
JAVA_SRCS += DefaultReporter.java
JAVA_SRCFILES = $(addprefix $(JAVA_SRCDIR)/$(JAVA_PREFIX)/, $(JAVA_SRCS))
JAVA_CLASSFILES = $(addsuffix .class, $(basename $(JAVA_SRCFILES)))

# The wrapper sources, objects, and compiler options
WRAPPER_DIR = ./src-wrapper
#WRAPPER_SRCS += $(WRAPPER_DIR)/jbliss_AbstractGraph.cc
WRAPPER_SRCS += $(WRAPPER_DIR)/fi_tkk_ics_jbliss_Graph.cc
#WRAPPER_SRCS += $(WRAPPER_DIR)/jbliss_Digraph.cc
WRAPPER_OBJS = $(addsuffix .o, $(basename $(WRAPPER_SRCS)))
WRAPPER_CC ?= $(BLISS_CC)
WRAPPER_CCFLAGS ?= -O3 -Wall $(PIC_FLAG)
WRAPPER_INCLUDES = $(JNI_INCLUDE) -I$(BLISS_DIR)

#
CLASSPATHOPT = -classpath src

all:: lib jar doc

gmp:    LIBS += -lgmp
gmp:    BLISS_CCFLAGS += -DBLISS_USE_GMP

.SUFFIXES: .java .class

.java.class: $@
	javac $(CLASSPATHOPT) $<

$(WRAPPER_DIR)/%.o: $(WRAPPER_DIR)/%.cc
	$(WRAPPER_CC) $(WRAPPER_CCFLAGS) $(WRAPPER_INCLUDES) -c -o $@ $<

$(BLISS_DIR)/%.o: $(BLISS_DIR)/%.cc
	$(BLISS_CC) $(BLISS_CCFLAGS) -I$(BLISS_DIR) -c -o $@ $<


bliss: # nothing

headers: $(JAVA_CLASSFILES)
	#javah -jni -d $(WRAPPER_DIR) $(CLASSPATHOPT) fi.tkk.ics.jbliss.Graph

jar: $(JAVA_CLASSFILES)
	cd $(JAVA_SRCDIR); jar cf ../lib/jbliss.jar $(JAVA_PREFIX)/*.class

lib: bliss $(BLISS_OBJS) headers $(WRAPPER_OBJS)
	@mkdir -p lib
	$(WRAPPER_CC) $(WRAPPER_CCFLAGS) $(WRAPPER_INCLUDES) $(SHARED_LDFLAGS) -o $(LIB_OUTPUT) $(BLISS_OBJS) $(WRAPPER_OBJS) $(LIBS)

jbliss: lib JBliss.class

doc: $(JAVA_SRCFILES)
	cd doc; javadoc -public -classpath ../src fi.tkk.ics.jbliss

clean:
	rm -f $(JAVA_CLASSFILES)
	rm -f $(WRAPPER_OBJS)
	rm -f bliss-0.50/*.o
	rm -f lib/jbliss.jar
	rm -f lib/libjbliss.so lib/libjbliss.dll lib/libjbliss.a

