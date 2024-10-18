%{
#include <stdio.h>
%}

%%
\/\/.*                  { printf("COMMENT"); }
f                       { printf("floatdcl "); }
i                       { printf("intdcl "); }
p                       { printf("print "); }
[a-eg-hj-z]             { printf("id "); }
[0-9]+                  { printf("inum "); }
[0-9]*\.?[0-9]{1,5}     { printf("fnum "); }
=                       { printf("assign "); }
\+                       { printf("plus "); }
%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Error opening file: %s\n", argv[1]);
        return 1;
    }

    yyin = file;
    yylex();
    fclose(file);

    return 0;
}

