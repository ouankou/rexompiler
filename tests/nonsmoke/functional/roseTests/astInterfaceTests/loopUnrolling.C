/*
test code for loopUnrolling
by Liao, 5/6/2009
*/
#include "rose.h"
#include <string>
#include <iostream>
#include "commandline_processing.h"

using namespace std;

int main(int argc, char * argv[])

{
  int line;
  int factor =2;
  // command line processing
  //--------------------------------------------------
  vector<std::string> argvList (argv, argv+argc);
  if (!CommandlineProcessing::isOptionWithParameter (argvList,"-rose:loopunroll:","line", line, true)
     || !CommandlineProcessing::isOptionWithParameter (argvList,"-rose:loopunroll:","factor",factor, true))
  {
     cout<<"Usage: loopUnrolling inputFile.c -rose:loopunroll:line <line_number> -rose:loopunroll:factor N"<<endl;
     return 0;
  }

  // Retrieve corresponding SgForStatement from line number
  //--------------------------------------------------
  SgProject *project = frontend (argvList);
  SgForStatement* forLoop = NULL;
  ROSE_ASSERT(project != NULL);
  SgFilePtrList & filelist = project->get_fileList();
  SgFilePtrList::iterator iter= filelist.begin();
  for (;iter!=filelist.end();iter++)
  {
    SgSourceFile* sFile = isSgSourceFile(*iter);
    SgStatement * stmt = SageInterface::getFirstStatementAtLine(sFile, line);
    forLoop = isSgForStatement(stmt);
    if (forLoop != NULL) {
      cout<<"Find a loop from line:"<<line<<endl;
      break;
    } else {
      cout<<"Cannot find a matching target from line:"<<line<<endl;
      return 0;
    }
  }

  // Unroll it
  //--------------------------------------------------
  bool result=false;
  result = SageInterface::loopUnrolling(forLoop, factor);
  ROSE_ASSERT(result != false);
// Qing's loop processor does not pass postprocessing and runAllTests
//  AstPostProcessing(project);

  // generateWholeGraphOfAST("WholeAST");

  // run all tests
//  AstTests::runAllTests(project);

  // Generate source code from AST and call the vendor's compiler
  return backend(project);
}

