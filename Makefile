all:
	lex lexer.l
	gcc lex.yy.c -o lexer -ll

clean:
	rm -rf *.c
	rm -rf lexer
