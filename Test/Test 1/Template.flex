/*
	User-defined
*/
%%

%byaccj

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

%x TAG_CONTENT

NL = \r\n|\r|\n

BOOK = "book"
TAG_OPEN = "<"
TAG_CLOSE = ">"
CLOSE_TAG_OPEN = "</"

TEXT = [^'<']*


%%

/*
	Regole di traduzione
*/
<YYINITIAL, TAG_CONTENT>{NL}	
	{ 
		return Parser.NL;
	}
{BOOK} 
	{	
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.BOOK; 
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

/* whitespace */
[ \t]+ { }

\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]    { System.err.println("Error: unexpected character '" + yytext() + "'"); return -1; }