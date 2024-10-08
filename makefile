COMPILER_FILE = compiler.exe
TEST_PROGRAM = testProgram.txt

MAKEFLAGS += --no-print-directory

#compile the compiler:
compile:
	@echo compiling lexer and executable compiler
	@flex lex.l
	@gcc.exe lex.yy.c -o $(COMPILER_FILE) Lista.c
	@echo compilation finished

#run the compiler:
run:
	@if not exist $(COMPILER_FILE)  @($(MAKE) compile)
	@.\$(COMPILER_FILE) $(TEST_PROGRAM)

clean:
	@del lex.yy.c compiler.exe