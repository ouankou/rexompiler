include $(top_srcdir)/config/Makefile.for.ROSE.includes.and.libs

# DQ (4/17/2010): These directories are now organized based on what sets of languages 
# are enabled in ROSE (including binary analysis).
SUBDIRS =

# DQ (9/22/2020): Exclude the Intel compiler for now since it's testing is assigned 
# to a slow machine on Jenkins and it causes the tests to take 5.75 hours. We have 
# newer and faster machines coming soon.
# DQ (9/18/2020): Comment out as a test so that we can use clang and Intel compilers.
# if USING_GNU_COMPILER
if !USING_INTEL_COMPILER

if ROSE_BUILD_CXX_LANGUAGE_SUPPORT

   SUBDIRS += astMergeTests astPerformanceTests \
              astProcessingTests astQueryTests \
              astSymbolTableTests \
              programTransformationTests \
              mergeTraversal_tests \
              astLValueTests varDeclNorm

# DQ (3/31/2021): Testing by removing astTokenStreamTests (above)
#              astSymbolTableTests astTokenStreamTests

# DQ (11/5/2016): Skip these tests when using the address sanitizer since they would 
# take SO LONG (at least over an hour for initial testing, I think).
if !ROSE_USE_SANITIZER
   SUBDIRS += ROSETTA
endif

# TOO (2/16/2011): Errors with Thrifty (GCC 3.4.4) backend compiler. We can gradually
# enable these tests at a later stage if necessary.
if !USING_GCC_3_4_4_BACKEND_COMPILER
# TOO (2/17/11): Errors with Tensilica's Xtensa compilers. 
if !USING_XTENSA_BACKEND_COMPILER
#  SUBDIRS += astInterfaceTests astInliningTests ompLoweringTests programAnalysisTests astOutliningTests loopProcessingTests fileLocation_tests
   SUBDIRS += astInterfaceTests astInliningTests 
if !USING_CLANG_COMPILER
 # DQ (9/19/2020): Clang does not work with most of the test codes in this directory.
   SUBDIRS += ompLoweringTests
endif
   SUBDIRS += programAnalysisTests
if !USING_CLANG_COMPILER
 # DQ (9/19/2020): Clang does not work with most of the test codes in this directory.
   SUBDIRS += astOutliningTests
endif
   SUBDIRS += loopProcessingTests fileLocation_tests

endif # !USING_XTENSA_BACKEND_COMPILER
endif # !USING_GCC_3_4_4_BACKEND_COMPILER

endif # ROSE_BUILD_CXX_LANGUAGE_SUPPORT

# endif # USING_GNU_COMPILER
endif # !USING_INTEL_COMPILER

check-local:
	@echo "*******************************************"
	@echo "*******************************************"
	@echo "Passed tests for tests/roseTests directory."
	@echo "*******************************************"
	@echo "*******************************************"

