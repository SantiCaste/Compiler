COMPILER_FILE = compiler.exe
TEST_PROGRAM = testProgram.txt

MAKEFLAGS += --no-print-directory

#compile the compiler:
compile:
	@echo compiling lexer and executable compiler
	@flex lex.l
	@bison -dyv syntax.y
	@gcc.exe lex.yy.c y.tab.c -o $(COMPILER_FILE)
	@echo compilation finished

#run the compiler:
run:
	@if not exist $(COMPILER_FILE)  @($(MAKE) compile)
	@.\$(COMPILER_FILE) $(TEST_PROGRAM)

clean:
	@del lex.yy.c y.tab.c y.tab.h y.output compiler.exe 