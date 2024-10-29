%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();

int node_id = 0;

typedef struct Node {
    int id;
    const char* label;
    struct Node* left;
    struct Node* middle;
    struct Node* right;
} Node;

Node* create_node(const char* label) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->id = node_id++;
    node->label = label;
    node->left = node->middle = node->right = NULL;
    return node;
}

// Adjusted print_tree function
void print_tree(Node* node) {
    if (node == NULL) return;

    printf("%s", node->label);

    if (node->left != NULL || node->middle != NULL || node->right != NULL) {
        printf(" -> {");
        int first = 1;

        if (node->left != NULL) {
            if (!first) printf(", ");
            print_tree(node->left);
            first = 0;
        }

        // Print middle child
        if (node->middle != NULL) {
            if (!first) printf(", ");
            print_tree(node->middle);
            first = 0;
        }

        // Print right child
        if (node->right != NULL) {
            if (!first) printf(", ");
            print_tree(node->right);
        }
        printf("}");
    }

    // End the current node output
    printf(";\n");
}

#define YYSTYPE Node*
%}

%token floatdcl intdcl print id inum fnum assign plus minus multiply division

%%

// Program structure
program: declarations statements { 
            printf("digraph D {\n"); 
            print_tree($1);  // Print declarations
            print_tree($2);  // Print statements
            printf("}\n"); 
        }
       ;

// Declarations and declaration rules
declarations: declarations declaration { $$ = create_node("declarations"); $$->left = $1; $$->middle = $2; }
            | /* empty */              { $$ = create_node("declarations"); }
            ;

declaration: floatdcl id               { $$ = create_node("declaration"); $$->left = create_node("floatdcl"); $$->middle = create_node("id"); }
           | intdcl id                 { $$ = create_node("declaration"); $$->left = create_node("intdcl"); $$->middle = create_node("id"); }
           ;

// Statements and statement rules
statements: statements statement       { $$ = create_node("statements"); $$->left = $1; $$->middle = $2; }
          | /* empty */                { $$ = create_node("statements"); }
          ;

statement: id assign expr              { $$ = create_node("statement"); $$->left = create_node("id"); $$->middle = create_node("assign"); $$->right = $3; }
         | print id                    { $$ = create_node("statement"); $$->left = create_node("print"); $$->middle = create_node("id"); }
         ;

// Expression and term rules
expr: expr plus term                   { $$ = create_node("expr"); $$->left = $1; $$->middle = create_node("plus"); $$->right = $3; }
    | expr minus term                  { $$ = create_node("expr"); $$->left = $1; $$->middle = create_node("minus"); $$->right = $3; }
    | term                             { $$ = $1; }
    ;

term: term multiply factor             { $$ = create_node("term"); $$->left = $1; $$->middle = create_node("multiply"); $$->right = $3; }
    | term division factor             { $$ = create_node("term"); $$->left = $1; $$->middle = create_node("division"); $$->right = $3; }
    | factor                           { $$ = $1; }
    ;

factor: inum                           { $$ = create_node("factor"); $$->left = create_node("inum"); }
      | fnum                           { $$ = create_node("factor"); $$->left = create_node("fnum"); }
      | id                             { $$ = create_node("factor"); $$->left = create_node("id"); }
      ;

%%

// Error handling
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
