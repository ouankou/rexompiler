#!/usr/bin/perl

# Build the public configuration file from the private configuration file by reading from standard input and writing
# to standard output.  The private configuration file is probably "rose_config.h" which was generated by config.status
# and which cannot be included in end-user header files (e.g., "rose.h") because it pollutes the name space.  The output
# is simply a copy of the input, prepending "ROSE_" to each desired CPP symbol.
#
# Only certain symbols are copied from the input to the output. The candidates are defined herein (see @symbols below) and
# specified on the command line. Also, any symbol whose name begins with "ROSE_" is copied to the public file.
#
# In order to make the output look nice, we use the fact that config.status emits "paragraphs" separated from one another
# by a blank line.  The first paragraph contains comments about the file provenance; each remaining paragraph is a
# configuration setting containing one of three posibilities:
#     1.  An explicit definition    ("#define")
#     2.  An explicit undefinition  ("#undef")
#     3.  An implicit undefinition  ("#undef" within a comment)
#
# Example usage:
#
#     $ publicConfiguration.pl HAVE_C_ASM_H <rose_config.h >rose_config_public.h
#
#   might generate:
#
#     /* rose_config.h.  Generated from rose_config.h.in by configure.  */
#     /* rose_config.h.in.  Generated from configure.in by autoheader.  */
#     /* this public header generated by ../scripts/publicConfiguration.pl */
#
#     /* Define to 1 if you have the <c_asm.h> header file. */
#     /* #undef ROSE_HAVE_C_ASM_H */
#
#     /* Define to 1 if you have the <pthread.h> header file. */
#     #define ROSE_HAVE_PTHREAD_H 1


use strict;

# Produce output only for the following symbols:
my @symbols = (qw/HAVE_PTHREAD_H HAVE_DWARF_H HAVE_LIBDWARF
                  PACKAGE_VERSION SIZEOF_INT SIZEOF_LONG
                  HAVE_LIBREADLINE HAVE_BOOST_SERIALIZATION_LIB USE_CMAKE
	          HAVE_SYS_PERSONALITY_H/,
	       @ARGV);

my @paragraphs = map {"$_\n"} split /\n[ \t]*\n/, join "", <STDIN>;
# print "=================\n", $_ for @paragraphs;  # DEBUGGING: print each paragraph

print shift(@paragraphs), "/* this public header generated by $0 */\n";

for (@paragraphs) {
  next unless my($sym) = /(?:#\s*define|undef)\s+(\w+)/;
  next unless $sym=~/^ROSE_/ || grep {$sym eq $_} @symbols;
  s/\b(?!ROSE_)$sym\b/ROSE_$sym/g;
  print "\n", $_;
}
