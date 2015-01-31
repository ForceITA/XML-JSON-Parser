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

/* ELEMENTS */
BOOK = "book"
DEDICATION = "dedication"
PREFACE = "preface"
PART = "part"
TOC = "toc"
LOF = "lof"
LOT = "lot"
ITEM = "item"
CHAPTER = "chapter"
SECTION = "section"
FIGURE = "figure"
TABLE = "table"
ROW = "row"
CELL = "cell"
AUTHOR_NOTES = "authornotes"
NOTE = "note"

/* ATTRIBUTES */
EDITION = "edition"
ID = "id"
TITLE = "title"
CAPTION = "caption"
PATH = "path"

/* SYMBOLS */
TAG_OPEN = "<"
TAG_CLOSE = ">"
CLOSE_TAG_OPEN = "</"
CLOSE_TAG_CLOSE = "/>"
ATT_SEPARATOR = "="

/* VALUES */

/* Usato per i valori di ATTRIBUTES (CDATA)*/ 
VALUE = \"[ a-zA-Z0-9\-\_\.]+\"
ACCENT = (è|é|ò|à|ù|ç|ì)
SYMBOLS = (\.|\,|\;|\:|\?|\^|\!|\"|\'|\$|\&|\£|\%|\(|\)|\=|\*|\[|\]|\\|\+|\-|\_|§|°|#|@)
/* Usato come PCDATA - DA VERIFICARE */
CONTENT =(({NL}|[ \t])*({ACCENT}|{SYMBOLS}|[a-zA-Z0-9])+({NL}|[ \t])*)*

/* COMMENT */
COMMENT = <\!\-\-+ ([^\-\-] | [\r\n] | (\-+ ([^\-\->] | [\r\n])) )* \-+\->[ \t]*

/* SPECIAL CHARACTERS */
NL = \r\n|\r|\n

/* START CONDITIONS */
%x IN_TAG IN_CONTENT

%%

/*
	Regole di traduzione
*/


/* ELEMENTS */

{BOOK} 
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.BOOK; 
	}

{DEDICATION}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.DEDICATION;		
	}

{PREFACE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.PREFACE; 
	}
	
{PART}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.BOOK; 
	}

{TOC}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.TOC; 
	}

{LOF}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.LOF; 
	}

{LOT}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.LOT; 
	}
	
{ITEM}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ITEM; 
	}
	
{CHAPTER}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CHAPTER;
	}

{SECTION}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.SECTION;
	}

{FIGURE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.FIGURE; 
	}

{TABLE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.TABLE; 
	}
	
{ROW}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ROW; 
	}

{CELL}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CELL; 
	}
	
{AUTHOR_NOTES}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.AUTHOR_NOTES;
	}

{NOTE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.NOTE; 
	}

/* ATTRIBUTES */

{EDITION}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.EDITION; 
	}
	
{ID}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ID; 
	}
	
{TITLE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.TITLE; 
	}
	
{CAPTION}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CAPTION; 
	}
	
{PATH}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.PATH; 
	}
	
/* SYMBOLS */

{TAG_OPEN}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.TAG_OPEN; 
	}

{TAG_CLOSE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.TAG_CLOSE; 
	}
{CLOSE_TAG_OPEN}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CLOSE_TAG_OPEN; 
	}
{CLOSE_TAG_CLOSE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CLOSE_TAG_CLOSE; 
	}
	
{ATT_SEPARATOR}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ATT_SEPARATOR; 
	}

/* VALUES */
{VALUE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.VALUE; 
	}
	
{ACCENT}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ACCENT; 
	}
	
{SYMBOLS}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.SYMBOLS; 
	}

{CONTENT}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CONTENT; 
	}
	

/* COMMENT */
{COMMENT}
	{
		/* EMPTY */
	}

	
/* SPECIAL CHARACTERS */
{NL}
	{
		return Parser.NL;
	}
		
	
/* whitespace */
[ \t]+ 			{ }

/* backspace */
\b    { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]   { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }