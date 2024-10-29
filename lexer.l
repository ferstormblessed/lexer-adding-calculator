%{
#include <stdio.h>
FILE *output_file;
%}

%%
\/\/.*                  { fprintf(output_file, "COMMENT"); }
f                       { fprintf(output_file, "floatdcl "); }
i                       { fprintf(output_file, "intdcl "); }
p                       { fprintf(output_file, "print "); }
[a-eg-hj-z]             { fprintf(output_file, "id "); }
[0-9]+                  { fprintf(output_file, "inum "); }
[0-9]*\.?[0-9]{1,5}     { fprintf(output_file, "fnum "); }
=                       { fprintf(output_file, "assign "); }
\+                      { fprintf(output_file, "plus "); }
\*                      { fprintf(output_file, "multiply "); }
\/                      { fprintf(output_file, "division "); }
\-                      { fprintf(output_file, "substraction "); }
[ \t]+                  { fputc(' ', output_file); }
\n                      { fputc('\n', output_file); }
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

    output_file = fopen("tokens.out", "w");
    if (!output_file) {
        printf("Error opening output file: tokens.out\n");
        fclose(file);
        return 1;
    }


    yyin = file;
    yylex();
    fclose(file);
    fclose(output_file);

    return 0;
}

