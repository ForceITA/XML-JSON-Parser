/*
	User-defined
*/
%%

%byaccj
%debug
%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

/*
	Espressioni Regolari 
*/

%x TAG_CONTENT IN_VIRGOLETTE IN_COMMENT

NL = \r\n|\r|\n


BOOK = "book"
TAG_OPEN = "<"
TAG_CLOSE = ">"
CLOSE_TAG_OPEN = "</"
EDITION = "edition"
UGUALE = "="
VIRGOLETTE = "\""
//TEXT = [a-zA-Z0-9\-_\"]*
TEXT = [^'<']*
TEXT2 = [^'\"']*

%%

/*
	Regole di traduzione
*/
<YYINITIAL, TAG_CONTENT, IN_VIRGOLETTE>{NL}	
	{ 
		return Parser.NL;
	}
{BOOK} 
	{	
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.BOOK; 
	}
{EDITION} 
	{	
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.EDITION; 
	}
{UGUALE} 
	{	
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.UGUALE; 
	}
<YYINITIAL,IN_VIRGOLETTE>{VIRGOLETTE} 
	{
		if(yystate() == IN_VIRGOLETTE){
			yybegin(YYINITIAL);
		}else{
			yybegin(IN_VIRGOLETTE);
		}
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.VIRGOLETTE; 
	}	
<TAG_CONTENT>{CLOSE_TAG_OPEN} 	
	{ 
		yybegin(YYINITIAL);	
		return Parser.CLOSE_TAG_OPEN; 
	}
{TAG_OPEN} 	
	{
		return Parser.TAG_OPEN;
	}
{TAG_CLOSE}
	{
		yybegin(TAG_CONTENT);
		return Parser.TAG_CLOSE;
	}
<TAG_CONTENT>{TEXT}
	{ 
		yyparser.yylval = new ParserVal (yytext());
		return Parser.TEXT;
	}

<IN_VIRGOLETTE>{TEXT2}
	{ 
		yyparser.yylval = new ParserVal (yytext());
		return Parser.TEXT2;
	}
	
	
/* whitespace */
<YYINITIAL,IN_VIRGOLETTE, TAG_CONTENT>[ \t]+ { }

<YYINITIAL,IN_VIRGOLETTE, TAG_CONTENT>\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
<YYINITIAL,IN_VIRGOLETTE, TAG_CONTENT>[^]    { System.err.println("Error: unexpected character '" + yytext() + "'"); return -1; }