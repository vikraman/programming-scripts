#!/bin/bash
[ $# -ne 1 ] && exit
FILE=$1
FILENAME=`basename $FILE`
EXT=`echo $FILENAME | cut -f2 -d'.'`
NAME=`basename $FILENAME .$EXT`
CTMPL="#include <stdio.h>\nint main () {\n\n   return 0;\n}"
CXXTMPL="#include <iostream>\nusing namespace std;\nclass $NAME {\n\n};\n\nint main () {\n\n   return 0;\n}"
JTMPL="class $NAME {\n   public static void main (String args[]) {\n\n  }\n}"
PLTMPL="#!/usr/bin/env perl\nuse warnings;\nuse strict;\nuse Data::Dumper;\n"
PYTMPL="#!/usr/bin/env python\n"
SCMTMPL="#!/usr/bin/env guile\n!#"
HSTMPL=""
CFLAGS="-Wall -Wextra -g -pipe"
CXXFLAGS="$CFLAGS"
JFLAGS=""
HSFLAGS="-O"
MAKEXEC="chmod +x"

function die ()
{
    echo "$1 not found in PATH! :("
    exit
}

function do_edit ()
{
    echo "Opening $FILE for editing..."
    $EDITOR $FILE
    echo "Closing $FILE..."
}

test $EDITOR || (test type -P gvim >/dev/null && EDITOR="`type -P gvim` -f" || die gvim)

case $EXT in
    c )
	type -P gcc >/dev/null && GCC=`type -P gcc` || die gcc
	[ -f $FILE ] || echo -e $CTMPL >$FILE
	do_edit
	echo "Compiling..."
	$GCC $CFLAGS -o $NAME $FILE && echo "Completed... :)" ;;
    
    cpp )
	type -P g++ >/dev/null && GXX=`type -P g++` || die g++
	[ -f $FILE ] || echo -e $CXXTMPL >$FILE
	do_edit
	echo "Compiling..."
	$GXX $CXXFLAGS -o $NAME $FILE && echo "Completed... :)" ;;

    java )
	type -P javac >/dev/null && JAVAC=`type -P javac` || die javac
	[ -f $FILE ] || echo -e $JTMPL >$FILE
	do_edit
	echo "Compiling..."
	$JAVAC $JFLAGS $FILE && echo "Completed... :)" ;;
	
    pl )
	[ -f $FILE ] || echo -e $PLTMPL >$FILE
	do_edit
	$MAKEXEC $FILE && echo "Completed... :)" ;;

    py )
	[ -f $FILE ] || echo -e $PYTMPL >$FILE
	do_edit
	$MAKEXEC $FILE && echo "Completed... :)" ;;

    scm )
	[ -f $FILE ] || echo -e $SCMTMPL >$FILE
	do_edit
	$MAKEXEC $FILE && echo "Completed... :)" ;;

    hs )
	type -P ghc >/dev/null && GHC=`type -P ghc` || die ghc
	[ -f $FILE ] || echo -e $HSTMPL >$FILE
	do_edit
	echo "Compiling..."
	/bin/rm -f $NAME.hi $NAME.o
	$GHC $HSFLAGS -o $NAME $FILE && echo "Completed... :)"
	/bin/rm -f $NAME.hi $NAME.o;;

    * )
	echo "File extension not recognized! :("
esac
