grammar Ruby;

start : expression_list ;

expression_list : ((CRLF)* expression terminator (CRLF)*)*;
 
expression : function_definition
            |require_block
            |if_statement
            |unless_statement
            |rvalue
            |while_statement
            |for_statement
            |case_statement
            |until_statement
    	    |repeat_statement
            ;
 
require_block: REQUIRE CADENA;
 
function_definition: function_definition_header function_definition_body END;

 
function_definition_header: DEF function_name  CRLF | DEF function_name function_definition_params CRLF;
 
function_name:  IDENTIFICADORFUNCION | IDENTIFICADOR;
 
function_definition_params: PARENTESISABIERTO function_definition_params_list PARENTESISCERRADO |  function_definition_params_list;
 
function_definition_params_list: (IDENTIFICADOR COMA)* IDENTIFICADOR;
 
function_definition_body : expression_list (return_statement CRLF| );

return_statement: RETURN rvalue;
 
function_call : function_name function_call_param_list | function_name;
 
function_call_param_list: function_call_params;
 
function_call_params: (rvalue COMA)* rvalue;



if_elseif_statement: ELSIF rvalue (THEN | ) CRLF expression_list |
                     ELSIF rvalue (THEN | ) CRLF expression_list ELSE CRLF expression_list |
                     ELSIF rvalue (THEN | ) CRLF expression_list if_elseif_statement;
 
if_statement: IF rvalue (THEN | ) CRLF expression_list END |
              IF rvalue  (THEN | ) CRLF expression_list ELSE CRLF expression_list END |
              IF rvalue (THEN | ) CRLF  expression_list if_elseif_statement END;



for_statement : FOR lvalue (COMA lvalue)* IN (PARENTESISABIERTO ((ENTERO | FLOAT | lvalue) RANGO (ENTERO | FLOAT | lvalue)) PARENTESISCERRADO |
((ENTERO | FLOAT | lvalue)  RANGO (ENTERO | FLOAT | lvalue)) | CORCHETEABIERTO array_definition (COMA array_definition)* CORCHETECERRADO ) (expression_list (BREAK))* expression_list (BREAK | ) CRLF END;
 


unless_statement: UNLESS rvalue (THEN | ) CRLF expression_list (ELSE CRLF expression_list | ) END;



case_statement: CASE lvalue CRLF (WHEN (rvalue | PARENTESISABIERTO (ENTERO | FLOAT | lvalue) RANGO (ENTERO | FLOAT | lvalue) PARENTESISCERRADO | (ENTERO | FLOAT | lvalue)  RANGO (ENTERO | FLOAT | lvalue)) (THEN | ) CRLF expression_list)* (ELSE CRLF expression_list | ) END;
 


until_statement: UNTIL rvalue (DO | ) CRLF expression_list END;

                                               
while_statement: WHILE rvalue (DO | ) CRLF (expression terminator)*  (BREAK | ) CRLF END;


repeat_statement : BEGIN CRLF expression_list END WHILE rvalue;


            
assigment: lvalue (IGUAL | MASIGUAL | MENOSIGUAL | MULTIGUAL | DIVISIONIGUAL | PORCENTAJEIGUAL | ELEVADOIGUAL) rvalue
;
            
array_assigment: lvalue  (IGUAL | MASIGUAL | MENOSIGUAL)  array_definition | lvalue MULTIGUAL (ENTERO | FLOAT);

 
array_definition: CORCHETEABIERTO array_definition_elements CORCHETECERRADO | CORCHETEABIERTO CORCHETECERRADO;
 
array_definition_elements: (rvalue COMA)* rvalue;

 
lvalue: IDENTIFICADOR | ID_GLOBAL;
 
rvalue: lvalue 
	|CADENA
	|BOOLEAN
	|FLOAT
	|ENTERO
	|NULO
	|array_definition
	|array_assigment 
	|assigment
	|function_call
	|rvalue (SUMA | RESTA | MULT | DIVISION | PORCENTAJE | ELEVADO) rvalue
	|COMPARADORBOL2 rvalue
	|rvalue COMPARADORBOL1 rvalue
	|rvalue COMPARADORESBIT rvalue
	|(ENTERO | FLOAT | CADENA | lvalue) (COMPARADORES2| COMPARADORES1) (ENTERO | FLOAT | CADENA | lvalue)
	|(array_definition | BOOLEAN | NULO | lvalue) COMPARADORES1 (array_definition | BOOLEAN | NULO | lvalue)
	|PARENTESISABIERTO rvalue PARENTESISCERRADO (rvalue | )
	;

terminator : (PUNTOYCOMA | CRLF);


REQUIRE : 'require';
END : 'end';
DEF : 'def';
RETURN : 'return';
IF : 'if';
THEN : 'then';
BEGIN : 'begin';
ELSE : 'else';
CASE : 'case';
WHEN : 'when';
UNTIL : 'until';
DO : 'do';
ELSIF : 'elsif';
UNLESS: 'unless';
WHILE : 'while';
RETRY : 'retry';
BREAK : 'break';
FOR : 'for';
IN : 'in';
BOOLEAN : 'true' | 'false';
SUMA: '+';
RESTA: '-';
MULT: '*';
DIVISION: '/';
PORCENTAJE: '%';
ELEVADO: '**';
COMPARADORES1: '==' | '!=';
COMPARADORES2: '>' | '<' | '<=' | '>=';
IGUAL: '=';
MASIGUAL: '+=';
MENOSIGUAL: '-=';
MULTIGUAL: '*=';
DIVISIONIGUAL: '/=';
PORCENTAJEIGUAL: '%=';
ELEVADOIGUAL: '**=';
COMPARADORESBIT : '&' | '|' | '^' | '<<' | '>>';
COMPARADORBOL1 : 'and' | '&&' | 'or' ;
COMPARADORBOL2 : 'not' | '!' | '~';
PARENTESISABIERTO : '(';
PARENTESISCERRADO : ')';
CORCHETEABIERTO : '[';
CORCHETECERRADO : ']';
NULO : 'nil';
ENTERO : [0-9]+ ;
FLOAT : [0-9]+'.'[0-9]+;
IDENTIFICADOR : [a-zA-Z_][a-zA-Z0-9_]*;
ID_GLOBAL : '$' [a-zA-Z_][a-zA-Z0-9_]*;
IDENTIFICADORFUNCION :  [a-zA-Z_][a-zA-Z0-9_]* [!?];
COMA : ',';
PUNTOYCOMA : ';';
RANGO : '..'|'...';
CRLF : '\n';
COMENTARIOS : ('#' ~('\r' | '\n')* '\n' | '=begin' .*? '=end') -> skip;
CADENA :  '"'( ESCAPEDQUOTE| ~('\n'|'\r') )*? '"'| '\''( ESCAPEDQUOTE| ~('\n'|'\r') )*? '\'';
ESCAPEDQUOTE : '\\"';
ESPACIOSBLANCOS : [ \t\r]+ -> skip;
