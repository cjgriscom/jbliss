This repo updates jbliss to version 0.73 and is modified to build for
Windows x64 using MinGW-w64.

Pre-built copies are under the `release` directory.

# Building

Building `libjbliss.so` on Linux:
```
make clean all
```

Building Windows `jbliss.dll` from Linux
```
# x86_64-w64-mingw32-g++ and other utilities are required on classpath
./make-mingw.sh
```

# jbliss 

```
jbliss is a Java language wrapper for bliss. It allows fast prototyping of, 
for instance, search algorithms applying isomorph rejection. It is much 
more convenient to use than the C++ interface but it not well-suited for 
extremely performance critical software. 

Copyright (c) 2008-2010 Tommi Junttila
jbliss is released under the GNU General Public License version 3.
```

# bliss

http://www.tcs.hut.fi/Software/bliss/

```
bliss is an open source tool for computing automorphism groups and 
canonical forms of graphs. It has both a command line user interface as 
well as C++ and C programming language APIs. 

The current version 0.73 of bliss; includes GNU LGPL licensed C++ source 
code and a C API. 

Copyright (c) 2003-2015 Tommi Junttila
bliss is released under the GNU Lesser General Public License version 3.
```

# Examples

```
After successful compilation, you can inspect the files in the 'examples'
directory. For instance, you can try the following
  cd examples
  javac -classpath .:../lib/jbliss.jar TestEnumerateROM.java
  java -classpath .:../lib/jbliss.jar -Djava.library.path=../lib TestEnumerateROM
and should see an output consisting of the line:
There are 1044 graphs with 7 vertices

Similarly, try:
  javac -classpath .:../lib/jbliss.jar TestSimple.java
  java -classpath .:../lib/jbliss.jar -Djava.library.path=../lib TestSimple
```
