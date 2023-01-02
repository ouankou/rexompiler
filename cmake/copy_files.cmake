set(GENERATED_HEADERS
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/grammar.h  
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/grammarString.h  
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/ROSETTA_macros.h  
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/terminal.h
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarMemoryPoolSupport.h
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/AstQueryMemoryPool.h  
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_Grammar.h 
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarTreeTraversalAccessEnums.h
   )

#temporaries of source files generated by ROSETTA
set(GENERATED_SRC
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarNewAndDeleteOperators.C                
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarTraverseMemoryPool.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_Grammar.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarNewConstructors.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarTreeTraversalSuccessorContainer.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarCheckingIfDataMembersAreInMemoryPool.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarProcessDataMemberReferenceToPointers.C  
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarVariantEnumNames.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarCopyMemberFunctions.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarReturnClassHierarchySubTree.C      
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarGetChildIndex.C
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarReturnDataMemberPointers.C  
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarMemoryPoolSupport.C  
    ${ROSE_TOP_BINARY_DIR}/src/ROSETTA/src/Cxx_GrammarRTI.C
    )
#Copy the generated files to ${BUILD_DIR}/src/frontend/SageIII
foreach (src ${GENERATED_HEADERS} ${GENERATED_SRC})
  get_filename_component (FILE_BASE ${src} NAME_WE)

  add_custom_command(
      OUTPUT ${CMAKE_BINARY_DIR}/src/frontend/SageIII/${FILE_BASE} 
      COMMAND
      ${CMAKE_COMMAND}  -E copy  ${FILE_BASE} ${ROSE_TOP_BINARY_DIR}/src/frontend/SageIII/${FILE_BASE}
      DEPENDS ${FILE_BASE} 
      )
endforeach(src)

