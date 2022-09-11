execute_process(COMMAND cat ${CMAKE_ARGV3} OUTPUT_VARIABLE signature)
message("signature='${signature}'")
string(REPLACE "\n" "" signature ${signature})
set(tarball_site "http://edg-binaries.rosecompiler.org")
set(workingDirectory "${CMAKE_BINARY_DIR}/src/frontend/CxxFrontend")
set(tarball_filename "roseBinaryEDG-${CMAKE_ARGV4}-${CMAKE_ARGV5}-${CMAKE_ARGV6}-${signature}")
set(tarball_fullname "roseBinaryEDG-${CMAKE_ARGV4}-${CMAKE_ARGV5}-${CMAKE_ARGV6}-${signature}.tar.gz")
#set(tarball_filename "roseBinaryEDG-5-0-x86_64-pc-linux-gnu-gnu-9-5.0.11.81.14")
#set(tarball_fullname "roseBinaryEDG-5-0-x86_64-pc-linux-gnu-gnu-9-5.0.11.81.14.tar.gz")
message("wget ${tarball_filename}")
execute_process(COMMAND wget -O ${workingDirectory}/EDG.tar.gz ${tarball_site}/${tarball_fullname} WORKING_DIRECTORY ${workingDirectory})
message("untar ${tarball_filename}")
execute_process(COMMAND tar zxvf ${workingDirectory}/EDG.tar.gz -C ${CMAKE_BINARY_DIR}/src/frontend/CxxFrontend/ WORKING_DIRECTORY ${workingDirectory})
message("rm EDG")
execute_process(COMMAND rm -rf ${workingDirectory}/EDG WORKING_DIRECTORY ${workingDirectory}) 
message("move EDG files")
execute_process(
COMMAND mv ${workingDirectory}/${tarball_filename} ${workingDirectory}/EDG WORKING_DIRECTORY ${workingDirectory})  
execute_process(COMMAND touch ${workingDirectory}/EDG/libroseEDG.la WORKING_DIRECTORY ${workingDirectory})
