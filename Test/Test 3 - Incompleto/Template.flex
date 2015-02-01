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

%x IN_CONTENT IN_TAG

NL = \r\n|\r|\n

INTRO_XML = "<?xml version='1.0' encoding='UTF-8'?>"
INTRO_DOC = "<!DOCTYPE book SYSTEM \"book.dtd\">"
TAG_OPEN = "<"
TAG_CLOSE = ">"
CLOSE_TAG_OPEN = "</"
BOOK = "book"
EDITION = "edition"
DEDICATION = "dedication"
UGUALE = "="
VALUE = \"[ a-zA-Z0-9\-\_\.]+\"
TEXT = [^'<']*


/*
ACCENT = (è|é|ò|à|ù|ç|ì)
SYMBOLS = (\.|\,|\;|\:|\?|\^|\!|\"|\'|\$|\&|\£|\%|\(|\)|\=|\*|\[|\]|\\|\+|\-|\_|§|°|#|@)
CONTENT =(({NL}|[ \t])*({ACCENT}|{SYMBOLS}|[a-zA-Z0-9])+({NL}|[ \t])*)*
*/

%%

/*
	Regole di traduzione
*/

{INTRO_XML} {}
{INTRO_DOC}	{}

<YYINITIAL, IN_CONTENT, IN_TAG>{NL}	
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
{DEDICATION}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.DEDICATION;
	}
{VALUE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.VALUE;
	}
{UGUALE}
	{	
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.UGUALE;
	}	
<IN_CONTENT>{CLOSE_TAG_OPEN}
	{ 
		yybegin(YYINITIAL);
		return Parser.CLOSE_TAG_OPEN;
	}
<IN_CONTENT>{TAG_OPEN}
	{	
		//yybegin(IN_TAG);
		return Parser.TAG_OPEN;
	}
{TAG_CLOSE}
	{
		yybegin(IN_CONTENT);
		return Parser.TAG_CLOSE;
	}
{TEXT}
	{
		yyparser.yylval = new ParserVal (yytext());
		return Parser.TEXT;
	}

	
/* whitespace */
<YYINITIAL, IN_CONTENT>[ \t]+ { }

<YYINITIAL, IN_CONTENT>\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
<YYINITIAL, IN_CONTENT>[^]    { System.err.println("Error: unexpected character '" + yytext() + "'"); return -1; }