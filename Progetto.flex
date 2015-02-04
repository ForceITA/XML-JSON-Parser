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

/* HEADERS */
INTRO_XML = "<?xml version='1.0' encoding='UTF-8'?>"
INTRO_DOC = "<!DOCTYPE book SYSTEM \"book.dtd\">"

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
/* VALUE - Usato per i valori CDATA */ 
VALUE = \"[ a-zA-Z0-9\-\_\.]+\"

ACCENT = (è|é|ò|à|ù|ç|ì)
SYMBOLS = (\.|\,|\;|\:|\?|\^|\!|\"|\'|\$|\&|\£|\%|\(|\)|\=|\*|\[|\]|\\|\+|\-|\_|§|°|#|@)
/* CONTENT - Usato come PCDATA - DA VERIFICARE */
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

/* HEADERS */
{INTRO_XML}
	{
		/* EMPTY */
	}

{INTRO_DOC}
	{
		/* EMPTY */
	}

/* ELEMENTS */
<IN_TAG> {
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
			return Parser.PART; 
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
 }

/* ATTRIBUTES */
<IN_TAG> { 
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
}

/* SYMBOLS */
<YYINITIAL, IN_CONTENT> {TAG_OPEN}
	{
		yybegin(IN_TAG);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.TAG_OPEN;
	}
	
<IN_TAG> {TAG_CLOSE}
	{
		yybegin(IN_CONTENT);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.TAG_CLOSE;
	}

<IN_CONTENT> {CLOSE_TAG_OPEN}
	{
		yybegin(IN_TAG);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CLOSE_TAG_OPEN; 
	}
	
<IN_TAG> {CLOSE_TAG_CLOSE}
	{
		yybegin(IN_CONTENT);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.CLOSE_TAG_CLOSE; 
	}
	
<IN_TAG> {ATT_SEPARATOR}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ATT_SEPARATOR; 
	}

/* VALUES */
<IN_TAG> {VALUE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.VALUE; 
	}
	
<IN_CONTENT> {
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
}

/* COMMENT */
<IN_CONTENT> {COMMENT}
	{
		/* EMPTY */
	}

/* SPECIAL CHARACTERS */
<YYINITIAL, IN_TAG, IN_CONTENT> {
	{NL}
		{
			/* EMPTY */
		}
	
	/* whitespace */
	[ \t]+ 
		{
			/* EMPTY */
		}

	/* backspace */
	\b    
		{ 
			System.err.println("Sorry, backspace doesn't work");
		}

	/* error fallback */
	[^] 
		{ 
			System.err.println("Error: unexpected character '" + yytext() + "'"); 
			return -1; 
		}
}