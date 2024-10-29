all:
	python3 code_generator.py > FILE
	lex lexer.l
	yacc -d parser.y
	gcc lex.yy.c y.tab.c -o parser

clean:
	rm -f lex.yy.c y.tab.c y.tab.h parser FILE

