include $(top_srcdir)/config/Makefile.for.ROSE.includes.and.libs

noinst_PROGRAMS = parseOmp
parseOmp_SOURCES = parseOmp.C

SUBDIRS=
if ROSE_BUILD_CXX_LANGUAGE_SUPPORT
  SUBDIRS += . cvalidation
endif
if ROSE_BUILD_FORTRAN_LANGUAGE_SUPPORT
  SUBDIRS += fortran 
endif

AM_CPPFLAGS = $(ROSE_INCLUDES)
AM_LDFLAGS = $(ROSE_RPATHS)
LDADD    = $(ROSE_LIBS)

# put macroCalls.c here since it requires -rose:wave, which causes seg fault on 64-bit machine
TESTCODE_CURRENTLY_FAILING = \
	ompfor7.c \
	macroCalls.c \
	data-member-access.cpp \
	define-directive2.cpp \
	define-directive.c

# the commented files break this variable assignment.
# it's only used to mark which tests failed now.
# when a test case is fixed, the comment symbol should be removed and this file should be added to the corresponding REX variable assignment.
C_TESTCODES_REQUIRED_TO_PASS = \
	3loops.c \
	affinity.c \
	jacobi.c \
	jacobi-collapse.c \
	alignment.c \
	array_init.c \
	array_init_2.c \
	atomic.c \
	atoms-2.c \
	atomic-3.c \
	barrier.c \
	#collapse.c \
	copyin.c \
	copyprivate2.c \
	copyprivate3.c \
	copyprivate.c \
	critical.c \
	critical1.c \
	critical_dead.c \
	critical_orphaned.c \
	distribute.c \
	distribute2.c \
	dijkstra_open_mp.c \
	dynamicChunk.c \
	empty.c \
	endif.c \
	endif2.c \
	endif3.c \
	nowait.c \
	expressions.c \
	falsesharing.c \
	firstprivate.c \
	firstPrivateArray.c \
	firstPrivateArray_2.c \
	firstlastprivate.c \
	flush.c \
	flush_exampleA_21_1c.c \
	full_verify.c \
	get_max_threads.c \
	hello.c \
	hello-1.c \
	hello-2.c \
	hello-ordered.c \
	include_header_only.c \
	lastprivate0.c \
	lastprivate.c \
	lastprivateOrphaned.c \
	limits_threads.c \
	linebreak.c \
	lockarray.c \
	loop.c \
	loop1.c \
	lu_factorization.c \
	master.c \
	masterSingle.c \
	matrix_vector.c \
	matrixmultiply.c \
	md_open_mp.c \
	multiple_return.c \
	nestedpar1.c \
	nestedpar.c \
	omp1.c \
	ompfor.c \
	ompfor_c99.c \
	ompfor2.c \
	ompfor3.c \
	ompfor4.c \
	ompfor5.c \
	ompfor6.c \
	ompfor8.c \
	ompfor9.c \
	ompfor10.c \
	ompfor-default.c \
	ompfor-decremental.c \
	ompfor-static.c \
	ompGetNumThreads.c \
	omp_sections.c \
	ordered3.c \
	ordered2.c \
	ordered.c \
	orphaned-directives.c \
	parallel.c \
	parallel_allocate_predefined_modifier.c \
	parallel_allocate_user_modifier.c \
	parallel-if.c \
	parallel-if-numthreads.c \
	parallel_if_parallel.c \
	parallel-numthreads.c \
	parallel-reduction.c \
	parallel-reduction2.c \
	parallel_pragma.c \
	parallelfor.c \
	parallelfor2.c \
	parallelsections.c \
	parallelmaster.c \
	pi.c \
	preprocessingInfo.c \
	prettyfunc.c \
	private.c \
	privatej.c \
	private-duplicate.c \
	recursive.c \
	reduction2.c \
	reduction.c \
	reduction-classic.c \
	reduction_min_max.c \
	reduction_modifier.c \
	reduction_user_identifier.c \
	requires.c \
	#requires1.c \
	rice1.c \
	scan.c \
	section.c \
	section1.c \
	sections.c \
	sections1.c \
	set_num_threads.c \
	shared.c \
	#simd.c \
	simd2.c \
	simd3.c \
	simd4.c \
	simd5.c \
	#single.c \
	#single2.c \
	single3.c \
	#single_copyprivate.c \
	sizeof.c \
	spmd1.c \
	staticChunk.c \
	subteam2.c \
	subteam.c \
	target.c \
	target1.c \
	task_array.c \
	task_array2.c \
	task_dep1.c \
	#task_dep2.c \
	task_dep3.c \
	#task_dep.load.compute.c \
	task_final.c \
	task_largenumber.c \
	task_mergeable.c \
	task_orphaned.c \
	task_outlining.c \
	task_priority.c \
	task_untied.c \
	task_untied2.c \
	task_untied3.c \
	#task_untied4.c \
	task_underIf.c \
	taskwait.c \
	taskwait2.c \
	teams.c \
	twoRegions.c \
	threadprivate2.c \
	threadprivate3.c \
	threadprivate.c \
	threadProcessor.c \
	upperCase.c \
	variables.c

REX_C_TESTCODES_REQUIRED_TO_PASS = \
	3loops.c \
	affinity.c \
	allocate.c \
	jacobi.c \
	jacobi-collapse.c \
	alignment.c \
	array_init.c \
	array_init_2.c \
	atoms-2.c \
	atomic.c \
	atomic-3.c \
	barrier.c \
	cancel.c \
	cancellation_point.c \
	copyin.c \
	copyprivate2.c \
	copyprivate3.c \
	copyprivate.c \
	critical.c \
	critical1.c \
	critical_dead.c \
	critical_orphaned.c \
	depobj.c \
	task_dep1.c \
	task_dep3.c \
	task_dep_iterator1.c \
	task_dep_iterator2.c \
	declare_simd.c \
	distribute_parallel_for.c \
	distribute_parallel_for_simd.c \
	distribute_simd.c \
	distribute.c \
	distribute2.c \
	dijkstra_open_mp.c \
	dynamicChunk.c \
	empty.c \
	endif.c \
	endif2.c \
	endif3.c \
	nowait.c \
	expressions.c \
	falsesharing.c \
	firstprivate.c \
	firstPrivateArray.c \
	firstPrivateArray_2.c \
	firstlastprivate.c \
	flush.c \
	flush_exampleA_21_1c.c \
	full_verify.c \
	flush_with_clauses.c \
	get_max_threads.c \
	hello.c \
	hello-1.c \
	hello-2.c \
	hello-ordered.c \
	include_header_only.c \
	lastprivate0.c \
	lastprivate.c \
	lastprivateOrphaned.c \
	limits_threads.c \
	linebreak.c \
	lockarray.c \
	loop.c \
	loop1.c \
	lu_factorization.c \
	master.c \
	masterSingle.c \
	mastertaskloop.c \
	mastertaskloopsimd.c \
	matrix_vector.c \
	matrixmultiply.c \
	md_open_mp.c \
	multiple_return.c \
	nestedpar1.c \
	nestedpar.c \
	omp1.c \
	ompfor.c \
	ompfor_c99.c \
	ompfor2.c \
	ompfor3.c \
	ompfor4.c \
	ompfor5.c \
	ompfor6.c \
	ompfor8.c \
	ompfor9.c \
	ompfor10.c \
	ompfor-default.c \
	ompfor-decremental.c \
	ompfor-static.c \
	ompGetNumThreads.c \
	omp_sections.c \
	ordered3.c \
	ordered2.c \
	ordered.c \
	ordered_depend.c \
	orphaned-directives.c \
	parallel.c \
	parallel_allocate_predefined_modifier.c \
	parallel_allocate_user_modifier.c \
	parallel-if.c \
	parallel-if-numthreads.c \
	parallel_if_parallel.c \
	parallel-numthreads.c \
	parallel-reduction.c \
	parallel-reduction2.c \
	parallel_pragma.c \
	parallelfor.c \
	parallelfor2.c \
	parallelsections.c \
	parallelloop.c \
	parallelmaster.c \
	parallelmastertaskloop.c \
	parallelmastertaskloopsimd.c \
	pi.c \
	preprocessingInfo.c \
	prettyfunc.c \
	private.c \
	privatej.c \
	private-duplicate.c \
	recursive.c \
	reduction2.c \
	reduction.c \
	reduction-classic.c \
	reduction_min_max.c \
	reduction_modifier.c \
	reduction_user_identifier.c \
	requires.c \
	requires_atomic_default_mem_order.c \
	requires_ext.c \
	requires_reverse_offload.c \
	requires_unified_address.c \
	requires_dynamic_allocators.c \
	requires_unified_shared_memory.c \
	rice1.c \
	scan.c \
	section.c \
	section1.c \
	sections.c \
	sections1.c \
	set_num_threads.c \
	shared.c \
	simd2.c \
	simd3.c \
	simd4.c \
	simd5.c \
	single.c \
	single2.c \
	single3.c \
	single_copyprivate.c \
	sizeof.c \
	spmd1.c \
	staticChunk.c \
	subteam2.c \
	subteam.c \
	target.c \
	target1.c \
	target_uses_allocators.c \
	targetparallel.c \
	targetparallelforsimd.c \
	targetparallelloop.c \
	targetsimd.c \
	targetteams.c \
	targetteamsdistribute.c \
	targetteamsdistributesimd.c \
	targetteamsloop.c \
	targetteamsdistributeparallelfor.c \
	targetteamsdistributeparallelforsimd.c \
	targetupdate.c \
	targetupdate_nowait.c \
	targetupdate_device.c \
	target_update_from.c \
	target_update_to.c \
	taskloop_simd_reduction.1.c \
	task_affinity.c \
	task_affinity1.c \
	task_array.c \
	task_array2.c \
	task_dep1.c \
	task_dep3.c \
	task_final.c \
	task_largenumber.c \
	task_mergeable.c \
	task_orphaned.c \
	task_outlining.c \
	task_priority.c \
	task_untied.c \
	task_untied2.c \
	task_untied3.c \
	task_underIf.c \
	taskgroup.c \
	taskloop.c \
	taskwait.c \
	taskwait2.c \
	taskwait3.c \
	taskwait4.c \
	taskwait5.c \
	taskyield.c \
	threadprivate.c \
	threadprivate2.c \
	threadprivate3.c \
	teams.c \
	teamsdistribute.c \
	teamsdistributesimd.c \
	teamsdistributeparallelfor.c \
	teamsdistributeparallelforsimd.c \
	teamsloop.c \
	twoRegions.c \
	threadProcessor.c \
	upperCase.c \
	variables.c
# frontend: EDG to SAGE connection bug
#	while-task.c

# removed experimental test cases
removed_Experimental_TEST = \
	axpy_ompacc_mpi.c \
	axpy_ompacc4.c \
	axpy_ompacc_parseonly.c 


# NP 4/23/21 Fails on move to Intel 19 and RHEL8
if USING_INTEL_COMPILER
   TESTCODE_CURRENTLY_FAILING += \
        simd.c 
else
   C_TESTCODES_REQUIRED_TO_PASS += \
        simd.c 
endif

# DQ (2/19/2017): This logic has not yet been updated to reflect the new logic for GNU, Clang, Intel compilers.
# It might be that it need not be updated since it is sufficently portable as it is (if not then it will be updated).
if USING_CLANG_COMPILER
# This Clang doesn't need to be updated since we don't use Clang at this moment.
# Only the ELSE branch should be maintained.
C_OMP_ACC_TESTCODES_REQUIRED_TO_PASS = \
        axpy_ompacc.c \
        axpy_ompacc2.c

CXX_TESTCODES_REQUIRED_TO_PASS = \
        jacobi-ompacc2.cpp \
	classMember.cpp \
	hello1.cpp \
	helloNested.cpp \
	memberFunction.cpp \
	memberFunction2.cpp \
	objectPrivate.cpp \
	objectFirstPrivate.cpp \
	objectLastprivate.cpp \
	orphanedAtomic.cpp \
	preprocessingInfo2.cpp \
	task_link.cpp \
	task_link2.cpp \
	task_tree.cpp 
else
C_OMP_ACC_TESTCODES_REQUIRED_TO_PASS = \
        axpy_ompacc.c \
        axpy_ompacc2.c \
	axpy_ompacc3.c \
	matrixmultiply-ompacc.c \
	matrixmultiply-ompacc2.c \
	jacobi-ompacc.c \
	jacobi-ompacc-v2.c \
	jacobi-ompacc-opt1.c \
	jacobi-ompacc-opt2.c \
	jacobi-ompacc-multiGPU.c

REX_C_OMP_ACC_TESTCODES_REQUIRED_TO_PASS = \
        axpy_ompacc.c \
        axpy_ompacc2.c \
	axpy_ompacc3.c \
	matrixmultiply-ompacc.c \
	matrixmultiply-ompacc2.c \
	jacobi-ompacc.c \
	jacobi-ompacc-v2.c \
	jacobi-ompacc-opt1.c \
	jacobi-ompacc-opt2.c \
	jacobi-ompacc-multiGPU.c
CXX_TESTCODES_REQUIRED_TO_PASS = \
    #    jacobi-ompacc2.cpp \
	classMember.cpp \
	hello1.cpp \
	helloNested.cpp \
	memberFunction.cpp \
	memberFunction2.cpp \
	objectPrivate.cpp \
	objectFirstPrivate.cpp \
	objectLastprivate.cpp \
	#orphanedAtomic.cpp \
	#preprocessingInfo2.cpp \
	#task_link.cpp \
	#task_link2.cpp \
	#task_tree.cpp \
	referenceType.cpp

REX_CXX_TESTCODES_REQUIRED_TO_PASS = \
	classMember.cpp \
	hello1.cpp \
	helloNested.cpp \
	memberFunction.cpp \
	memberFunction2.cpp \
	objectPrivate.cpp \
	objectFirstPrivate.cpp \
	objectLastprivate.cpp \
	referenceType.cpp
endif

if !USING_INTEL_COMPILER
C_TESTCODES_REQUIRED_TO_PASS += \
	init.c 
endif

#C_OMP_ACC_TEST_RESULTS = $(C_OMP_ACC_TESTCODES_REQUIRED_TO_PASS:.c=.o)
# we only care about unparsing for ACC input, not the object file generation
C_OMP_ACC_TEST_Unparsed = $(addprefix rose_,${REX_C_OMP_ACC_TESTCODES_REQUIRED_TO_PASS})

ROSE_FLAGS = -rose:openmp:ast_only --edg:no_warnings -w -rose:verbose 0 --edg:restrict #-rose:wave
# used to find omp.h, added it as one of  rose headers
TESTCODE_INCLUDES = -I$(top_srcdir)/src/frontend/SageIII

PASSING_C_TEST_RESULTS = $(addprefix rose_,${REX_C_TESTCODES_REQUIRED_TO_PASS})
PASSING_CXX_TEST_RESULTS = $(addprefix rose_,${REX_CXX_TESTCODES_REQUIRED_TO_PASS})

# rose_input.c/cpp 
PASSING_C_CXX_TEST_RESULTS = $(PASSING_C_TEST_RESULTS) $(PASSING_CXX_TEST_RESULTS) 

# DQ (11/30/2018): We have a combination of folded and non-folded values for macros in OpenMP pragmas 
# (Liao is looking into this) and we decided to comment this out in my testing while he does this.
# PASSING_C_CXX_ACC_TEST_RESULTS=$(PASSING_C_CXX_TEST_RESULTS) $(C_OMP_ACC_TEST_Unparsed) rose_bonds-2.c rose_macroIds.c
PASSING_C_CXX_ACC_TEST_RESULTS=$(PASSING_C_CXX_TEST_RESULTS) $(C_OMP_ACC_TEST_Unparsed) rose_bonds-2.c

PASSING_C_CXX_ACC_TEST_OUTPUT=$(addsuffix .output, $(PASSING_C_CXX_ACC_TEST_RESULTS))

$(PASSING_C_CXX_TEST_RESULTS): $(srcdir)/$(@:rose_%=%) parseOmp
	./parseOmp $(ROSE_FLAGS) $(TESTCODE_INCLUDES) -c $(srcdir)/$(@:rose_%=%) 

$(PASSING_C_CXX_ACC_TEST_OUTPUT): %.output:% 
	grep "pragma omp" $(@:%.output=%) > $@ || exit 0;

PASSING_C_CXX_ACC_TEST_OUTPUT_DIFF=$(addsuffix .diff, $(PASSING_C_CXX_ACC_TEST_OUTPUT))

REFERENCE_PATH=$(top_srcdir)/tests/nonsmoke/functional/CompileTests/OpenMP_tests/referenceResults

$(PASSING_C_CXX_ACC_TEST_OUTPUT_DIFF): %.diff:%
	if diff $(@:.output.diff=.output) $(REFERENCE_PATH)/$(@:.output.diff=.output) > $@ ; then echo "Test Passed"; rm -rf $@ ; else echo "Files differ; test falied"; cat $@; exit 1; fi

gen-output: $(PASSING_C_CXX_ACC_TEST_OUTPUT)

check-c:$(PASSING_C_TEST_RESULTS) 
check-cxx:$(PASSING_CXX_TEST_RESULTS)

ALL_TESTCODES = \
$(REX_C_TESTCODES_REQUIRED_TO_PASS) \
$(REX_CXX_TESTCODES_REQUIRED_TO_PASS) \
$(REX_C_OMP_ACC_TESTCODES_REQUIRED_TO_PASS) \
$(TESTCODE_CURRENTLY_FAILING)

# Liao 11/18/2009
# Test for a bug which happens when more than two source files show in the command line
# the translator should now be able to avoid duplicated processing of pragma statements
rose_bonds-2.c: $(srcdir)/atoms-2.c $(srcdir)/bonds-2.c parseOmp
	./parseOmp $(ROSE_FLAGS) $(TESTCODE_INCLUDES) -c $(srcdir)/atoms-2.c $(srcdir)/bonds-2.c

rose_macroIds.c: $(srcdir)/macroIds.c parseOmp
	./parseOmp $(ROSE_FLAGS) $(TESTCODE_INCLUDES) -rose:collectAllCommentsAndDirectives $(srcdir)/macroIds.c

# we now experiment with multi gpu and MPI support, test parse_only without OpenMP-specific AST creation for now. Liao10/28/2015
# test parsing experimental OpenMP accelerator directives, Liao 1/16/2013
$(C_OMP_ACC_TEST_Unparsed): $(srcdir)/$(@:rose_%=%) parseOmp
	./parseOmp -rose:openmp:ast_only -rose:skipfinalCompileStep --edg:no_warnings -w -rose:verbose 0 --edg:restrict -c $(srcdir)/$(@:rose_%=%)
#	./parseOmp -rose:openmp:parse_only -rose:skipfinalCompileStep --edg:no_warnings -w -rose:verbose 0 --edg:restrict -c $(srcdir)/$(@:rose_%=%)

if ROSE_BUILD_CXX_LANGUAGE_SUPPORT
conditional-check-local:
	@echo "Test for ROSE OpenMP Parser."
if USING_GNU_COMPILER
if ROSE_USING_GCC_VERSION_LATER_4_8
	@$(MAKE) $(PASSING_C_CXX_ACC_TEST_OUTPUT_DIFF)
endif # ROSE_USING_GCC_VERSION_LATER_4_8
else
if USING_CLANG_COMPILER
# Exclude this list of files in the case of CLANG compiler.
	@$(MAKE) $(PASSING_C_CXX_ACC_TEST_OUTPUT_DIFF)
else # NOT USING_CLANG_COMPILER
	@echo "USING_CLANG_COMPILER == false"
if USING_INTEL_COMPILER
# Exclude this list of files in the case of Intel compiler.
	@$(MAKE) $(PASSING_C_CXX_ACC_TEST_OUTPUT_DIFF)
else # NOT USING_INTEL_COMPILER
# This is an unknown compiler.
	@echo "USING_INTEL_COMPILER == false"
endif # USING_INTEL_COMPILER
endif # USING_CLANG_COMPILER
endif # USING_GNU_COMPILER
	@echo "**********************************************************************************************************************"
	@echo "****** ROSE/tests/nonsmoke/functional/CompileTests/OpenMP_tests: make check rule complete (terminated normally) ******"
	@echo "**********************************************************************************************************************"
else
conditional-check-local:
	@echo "Test for ROSE OpenMP Parser."
	@echo "*******************************************************************************************************************************"
	@echo "****** ROSE/tests/nonsmoke/functional/CompileTests/OpenMP_tests: make check rule for C/C++ skipped (terminated normally) ******"
	@echo "*******************************************************************************************************************************"
endif

EXTRA_DIST = $(ALL_TESTCODES) README bonds-2.c \
			 macroIds.c macroIds.h macroIdsDef.h \
			 collapse_2.c 

check-local: conditional-check-local

clean-local:
	rm -f *.o rose_*.* *.out
	rm -rf QMTest


