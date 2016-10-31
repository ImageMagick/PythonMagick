
topincludedir = @includedir@

AM_CPPFLAGS = -I$(top_builddir) -I$(top_srcdir)

ACLOCAL_AMFLAGS = -I m4

# Library built from two directories
SUBDIRS = pythonmagick_src helpers_src

# where to put the bastard
pymagickexecdir = $(pyexecdir)/$(PACKAGE_NAME)

# name of our library
pymagickexec_LTLIBRARIES = _PythonMagick.la

# the python initalization code
pymagickexec_PYTHON = PythonMagick/__init__.py

# EMPTY! we dont have any sources at top level
_PythonMagick_la_SOURCES =

# A dummy to tell that we are building c++
nodist_EXTRA__PythonMagick_la_SOURCES = dummy.cpp
 
# Flags are always good to have
_PythonMagick_la_LDFLAGS = -avoid-version -module $(BOOST_LDFLAGS)

# And the libraries to include
_PythonMagick_la_LIBADD = pythonmagick_src/libpymagick.la helpers_src/libhelper.la $(BOOST_LDFLAGS) -l$(BOOST_PYTHON_LIB) $(MAGICKPP_LIBS) $(MAGICK_LIBS)

EXTRA_DIST = autogen.pl SConstruct pyste_src LICENSE

# Automatically reconfigure libtool
LIBTOOL_DEPS = @LIBTOOL_DEPS@
libtool: $(LIBTOOL_DEPS)
	$(SHELL) ./config.status --recheck
