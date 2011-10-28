#!/bin/bash
[ $# -ne 1 ] && exit
FILE="$1"
FILENAME=`basename "$FILE"`
EXT=`echo "$FILENAME" | cut -f2 -d'.'`
NAME=`basename "$FILENAME" ."$EXT"`
CXXTMPL="                     \
#include <vector>           \n\
#include <list>             \n\
#include <map>              \n\
#include <set>              \n\
#include <deque>            \n\
#include <queue>            \n\
#include <stack>            \n\
#include <bitset>           \n\
#include <algorithm>        \n\
#include <functional>       \n\
#include <numeric>          \n\
#include <utility>          \n\
#include <sstream>          \n\
#include <iostream>         \n\
#include <iomanip>          \n\
#include <string>           \n\
#include <cstdio>           \n\
#include <cmath>            \n\
#include <cstdlib>          \n\
#include <cctype>           \n\
#include <cstring>          \n\
#include <ctime>            \n\
                            \n\
using namespace std;        \n\
                            \n\
int main () {               \n\
    int t, T;               \n\
                            \n\
    cin >> T;               \n\
    for (t = 1; t <= T; t++) {\n\
                            \n\
    }                       \n\
    return 0;               \n\
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
    echo -e "Only use C++ for codechef ;)"
esac
