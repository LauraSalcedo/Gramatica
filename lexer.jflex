package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Pepito
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Pepito(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Pepito(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
Number     = [0-9]+
Name	   = [A-Za-z][a-zA-Z]*

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
EndOfLineComment = "//" [^\r\n]* {Newline}
CommentContent = ( [^*] | \*+[^*/] )*

ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {
  
 /* {Whitespace}   {                              }*/
  asociative     { return symbolFactory.newSymbol ("ASOCIATIVE", ASOCIATIVE); }
  conmutative    { return symbolFactory.newSymbol ("CONMUTATIVE", CONMUTATIVE); }
  identity       { return symbolFactory.newSymbol ("IDENTITY", IDENTITY); }
  zero		     { return symbolFactory.newSymbol ("ZERO", ZERO); }
  distributive   { return symbolFactory.newSymbol ("DISTRIBUTIVE", DISTRIBUTIVE); }
  common_factor  { return symbolFactory.newSymbol ("COMMON_FACTOR", COMMON_FACTOR); }
  element		 { return symbolFactory.newSymbol ("ELEMENT", ELEMENT); }
  operation		 { return symbolFactory.newSymbol ("OPERATION", OPERATION); }
  uses_func		 { return symbolFactory.newSymbol ("USES_FUNC", USES_FUNC); }
  uses_constants { return symbolFactory.newSymbol ("USES_CONSTANTS", USES_CONSTANTS); }
  nameOp		 { return symbolFactory.newSymbol ("NAMEOP", NAMEOP); }
  nParam		 { return symbolFactory.newSymbol ("NPARAM", NPARAM); }
  "="			 { return symbolFactory.newSymbol("EQUAL", EQUAL); }
  /*paramType		 { return symbolFactory.newSymbol ("PARAMTYPE", PARAMTYPE); }*/
  /*combines		 { return symbolFactory.newSymbol ("COMBINES", COMBINES); }*/
  /*{Name}		 { return symbolFactory.newSymbol("NAME", NAME); }*/
  
  {Whitespace} {                              }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  {Number}     { return symbolFactory.newSymbol("NUMBER", NUMBER, Integer.parseInt(yytext())); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
