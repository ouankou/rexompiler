if(NOT disable-tutorial-directory)
  include_directories(${ROSE_INCLUDES})

  add_subdirectory(outliner)

  ########### next target ###############

  set(tutorials
    ASTGraphGenerator
    ASTGraphGeneratorCustomized AST_PDF_Generator wholeASTGraphGenerator
    identityTranslator lineReplacement queryLibraryExample nestedQueryExample
    visitorTraversal prePostTraversal combinedTraversals traverseIRnodeTypes
    classicObjectOrientedVisitorPatternTraversal inheritedAttributeTraversal
    synthesizedAttributeTraversal inheritedAndSynthesizedAttributeTraversal
    accumulatorAttributeTraversal persistantAttributes nestedTraversal
    visitorMemoryPoolTraversal
    classicObjectOrientedVisitorPatternMemoryPoolTraversal loopRecognition
    typeInfoFromFunctionParameters resolveOverloadedFunction templateParameter
    instrumentEndOfFunction reductionRecognition instrumentationExample
    addVariableDeclaration addVariableDeclaration2
    addAssignmentStmt addExpression addFunctionCalls addFunctionDeclaration
    addFunctionDeclaration2 addFunctionDeclaration3 loopOptimization LoopProcessor
    bin_example buildCallGraph buildVFA livenessAnalysis CharmSupport
    debuggingIRnodeToString debuggingSourceCodePositionInformation
    commandlineProcessing interveneAtVariables changeFunction classHierarchyGraph
    dataBaseUsage 
    loopNestingInfoProcessing tauInstrumenter typeTransformation
    generatingUniqueNamesFromDeclaration
    symbolTableHandling scopeInformation customGraphGeneration inlineTransformations
    addComments addArbitraryTextForUnparser collectComments
    collectDefineDirectives partialRedundancyElimination
    codeGenerationFormatControl dataFlowGraph customGraphGenerationWithFiltering
    graphTraversal wholeGraphAST traversalShortCircuit
    customGraphGenerationWithColors
    constantFoldingTransformation constantUnFoldingTransformation
    selectedFileTranslation wholeGraphFilterOnPersistantAttributes
    graphGenerationOfSubtree virtualCFG interproceduralCFG
    virtualFunctionIdentification switchWithoutDefault addStruct
    sprintf_to_snprintf seedBugsExample_arrayIndexing volatileTypeModifier
    findVariableDeclarations)

  if(HAVE_PTHREAD_H)
    list(APPEND tutorials sharedMemoryTraversals)
  endif()

  foreach(tutorial ${tutorials})
    add_executable(${tutorial}Tutorial "${tutorial}.C")
    target_link_libraries(${tutorial}Tutorial ROSE_DLL ${Boost_LIBRARIES})
  #  install(TARGETS ${tutorial}Tutorial DESTINATION bin)
  endforeach()

  # Install only those executables that are useful to users after ROSE is installed. If the main purpose of compiling
  # the tool is to ensure that the source code is correct for the purposes of documentation in the various tutorials,
  # then there's no point in installing that executable.
  #install(TARGETS buildCallGraphTutorial DESTINATION bin)
  #install(TARGETS livenessAnalysisTutorial DESTINATION bin)
  #install(TARGETS interproceduralCFGTutorial DESTINATION bin)
  #install(TARGETS virtualCFGTutorial DESTINATION bin)

  if(HAVE_SYS_TIME_H)
    add_executable(codeCoverage codeCoverage.C coverageCodeFromShmuel.c)
    target_link_libraries(codeCoverage ROSE_DLL ${Boost_LIBRARIES})
  endif()
endif()
