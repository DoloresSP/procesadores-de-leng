//* --------------------------Seccion codigo-usuario ------------------------*/ 

import java.io.*;
import java_cup.runtime.*;

%% 

/* -----------------Seccion de opciones y declaraciones -----------------*/ 
/*--OPCIONES --*/ 
/* Nombre de la clase generada para el analizadorlexico*/ 

%class analex 

/* Posibilitar acceso a la columna y fila actual de analisis*/ 

%line

%column

/* Habilitar la compatibilidad con el interfaz CUP para el generador sintáctico */

%cup


%state COMENTARIO, FINAL, CADENA

/*--DECLARACIONES --*/ 

%{ 
	public void ComprobarPalabra(String palabra){
		
		switch(palabra){
			case "require": 
				return symbol(sym.require);
				break;
			case "end":
				return symbol(sym.end);
				break;
			case "def":
				return symbol(sym.def);
				break;
			case "return":
				return symbol(sym.return);
				break;
			case "if":
				return symbol(sym.if);
				break;
			case "then":
				return symbol(sym.then);
				break;
			case "begin":
				return symbol(sym.begin);
				break;
			case "else":
				return symbol(sym.else);
				break;
			case "case":
				return symbol(sym.case);
				break;
			case "when":
				return symbol(sym.when);
				break;
			case "until":
				return symbol(sym.until);
				break;
			case "do":
				return symbol(sym.do);
				break;
			case "elseif":
				return symbol(sym.elseif);
				break;
			case "unless":
				return symbol(sym.unless);
				break;
			case "while":
				return symbol(sym.while);
				break;
			case "retry":
				return symbol(sym.retry);
				break;			
			case "break":
				return symbol(sym.break);
				break;
			case "for":
				Sreturn symbol(sym.for);
				break;
			case "in":
				return symbol(sym.in);
				break;
			case "true":
				return symbol(sym.boolean);
				break;
			case "false":
				return symbol(sym.boolean);
				break;
				
			case "and":
				return symbol(sym.comparadorbol1);
				break;
			case "or":
				return symbol(sym.comparadorbol1);
				break;
			case "not":
				return symbol(sym.comparadorbol2);
				break;
			case "nil":
				return symbol(sym.nulo);
				break;
			default:
				return symbol(sym.identificador);
				break;
			

		}

	}

	public  void ComprobarBoleano(String token){
		switch(token){
			case "&&": 
				return symbol(sym.comparadorbol1);
				break;
			case "||": 
				System.out.println("Operador booleano <"+token+"> encontrado en linea: " + (yyline+1) + " columna: " + (yycolumn+1));
				break;
			case "!": 
				return symbol(sym.comparadorbol2);
				break;
			case "~": 
				return symbol(sym.comparadorbol2);
				break;
		}
	}

	public  void ComprobarOperador(String token){
		switch(token){
			case "+": 
				return symbol(sym.suma);
				break;
			case "-": 
				return symbol(sym.resta);
				break;
			case "*": 
				return symbol(sym.mult);
				break;
			case "/": 
				return symbol(sym.division);
				break;
			case "%": 
				return symbol(sym.porcentaje);
				break;
			case "**": 
				return symbol(sym.elevado);
				break;
		}
	}

	public  void ComprobarComparador(String token){
		switch(token){
			case "==": 
				return symbol(sym.comparadores1);
				break;
			case "!=": 
				return symbol(sym.comparadores1);
				break;
			case "<=": 
				return symbol(sym.comparadores2);
				break;
			case ">=": 
				return symbol(sym.comparadores2);
				break;
			case "<": 
				return symbol(sym.comparadores2);
				break;
			case ">": 
				return symbol(sym.comparadores2);
				break;
		}
	}
 
%} /* Fin Declaraciones */


%type Object


/* Declaraciones de macros NL(nueva linea) BLANCO(espacio en blanco) y TAB(tabulador) */

NL  = \n | \r | \r\n
BLANCO = " "
TAB =  \t
COMPARADORBOOLEANO = "&&" | "||" | "!"
COMPARADORES = "==" | "!=" | "<=" | ">=" | "<" |">"
OPERADORES = "+" | "-" | "*" | "/" | "%" | "**"
NUMEROS = [1-9][:digit:]+
PALABRA = [:jletter:][:jletterdigit:]*
COMILLA = \"

%%

/* ------------------------Seccion de reglas y acciones ----------------------*/
<YYINITIAL> {

{NUMEROS}"."{NUMEROS}	{return symbol(sym.float);}

{NUMEROS}				{return symbol(sym.entero);}

{PALABRA}"!?"			return symbol(sym.identificadorfuncion);
{PALABRA}				{ComprobarPalabra(yytext());}
"$"{PALABRA} 			{return symbol(sym.id_global);}
"#"~\n					{return symbol(sym.comentarios);}
"=begin"				{yybegin(COMENTARIO);}
{COMILLA}				{yybegin(CADENA);}

 
{NL}					{return symbol(sym.crlf);}
{TAB}					{ /* ignora los tabuladores */ }
{BLANCO}				{ /* ignora los espacios en blanco */ }
				
{COMPARADORBOOLEANO}	{ComprobarBoleano(yytext());}
{OPERADORES} 			{ComprobarOperador(yytext());}
{COMPARADORES}			{ComprobarComparador(yytext());}

"("						{return symbol(sym.parentesisabierto);}
")"						{return symbol(sym.parentesiscerrado);}
"["						{return symbol(sym.corcheteabierto);}
"]"						{return symbol(sym.corchetecerrado);}
","						{return symbol(sym.coma);}
";"						{return symbol(sym.puntoycoma);}

"="						{return symbol(sym.igual);}
"+="					{return symbol(sym.masigual);}
"-="					{return symbol(sym.menosigual);}
"*="					{return symbol(sym.multigual);}
"/="					{return symbol(sym.divisionigual);}
"%="					{return symbol(sym.porcentajeigual);}
"**="					{return symbol(sym.elevadoigual);}

"&" | "|" | "^" | "<<" | ">>" {return symbol(sym.comparadoresbit);}

"..|..."				{return symbol(sym.rango);}

"\\"					{return symbol(sym.escapedquote);}


. 						{System.out.println("Token No Valido <" +yytext()+ ">linea: " + (yyline+1) + " columna: " + (yycolumn+1));}


}/* fin YYinitial */



<COMENTARIO>{
	~"=end" {return symbol(sym.comentarios);}
	.	{System.out.println("Error no ha terminado el comentario");yybegin(FINAL);}
}

<CADENA>{
	~{COMILLA} 	{return symbol(sym.cadena);}
	.		{System.out.println("Error no se ha cerrado la cadena");yybegin(FINAL);}
}

<FINAL>{
	.	{System.exit(0);}
}
