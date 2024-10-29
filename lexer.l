%{
#include "y.tab.h"
int yywrap(void);
%}

%%
\/\/.*                  { /* ignore COMMENT */; }
f                       { return floatdcl; }
i                       { return intdcl; }
p                       { return print; }
[a-eg-hj-z]             { yylval = strdup(yytext); return id; }
[0-9]+                  { yylval = atoi(yytext); return inum; }
[0-9]*\.[0-9]{1,5}      { yylval = atof(yytext); return fnum; }
=                       { return assign; }
\+                      { return plus; }
\*                      { return multiply; }
\/                      { return division; }
\-                      { return minus; }
\n                      { /* ignore end of line */; }
[ \t]+                  { /* ignore whitespace */; }
.                       { printf("Unexpected character: %s\n", yytext); }
%%

int yywrap(void) {
    return 1; 
}
