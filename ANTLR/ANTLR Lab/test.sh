#!/bin/sh
ANTLR_LIB="antlr-4.13.2-complete.jar"

# Making an empty out directory
touch out
rm -r out
mkdir out

# Generating code
java -jar ${ANTLR_LIB} -no-listener -visitor Expr.g4 -o out/

# Adding in our own code
cp *.java out/

# Compiling everything together
javac -cp .:out:${ANTLR_LIB} out/*.java

# Showing the parse tree
java -cp .:out:${ANTLR_LIB} org.antlr.v4.gui.TestRig Expr prog -gui testWithId.expr

# Run the calculator
java -classpath .:out/:${ANTLR_LIB} Calc test.expr


