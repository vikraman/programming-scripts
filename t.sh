#!/bin/bash
[ $# -ne 2 ] && exit
FILE="$1"
SIG="$2"
FILENAME=`basename "$FILE"`
EXT=`echo "$FILENAME" | cut -f2 -d'.'`
NAME=`basename "$FILENAME" ."$EXT"`
FUNC=`echo "$SIG" | awk -F'(' '{ print $1 }' | awk '{ print $2 }'`
CXXTMPL="             \
class $NAME {       \n\
public:             \n\
    $SIG {          \n\
    }               \n\
};                  \n\
                    \n\
int main () {       \n\
    $NAME().$FUNC();\n\
    return 0;       \n\
}"
CFLAGS="-Wall -Wextra -g -pipe"
CXXFLAGS="$CFLAGS"

function die ()
{
  echo -e "$1 not found in PATH! :("
  exit
}

function do_edit ()
{
  echo -e "Opening $FILE for editing..."
  $EDITOR $FILE
  echo -e "Closing $FILE..."
}

test $EDITOR || (test type -P gvim >/dev/null && EDITOR="`type -P gvim` -f" || die gvim)

case $EXT in
  cpp )
    type -P g++ >/dev/null && GXX=`type -P g++` || die g++
    [ -f $FILE ] || (echo -e $CXXTMPL >>$FILE)
    do_edit
    echo -e "Compiling..."
    $GXX $CXXFLAGS -o $NAME $FILE && echo -e "Completed... :)" ;;

  * )
    echo -e "Only use C++ for topcoder ;)"
esac
