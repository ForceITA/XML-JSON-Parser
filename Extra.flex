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
BOOK = "\"book\""
DEDICATION = "\"dedication\""
PREFACE = "\"preface\""
PART = "\"part\""
TOC = "\"toc\""
LOF = "\"lof\""
LOT = "\"lot\""
ITEM = "\"item\""
CHAPTER = "\"chapter\""
SECTION = "\"section\""
FIGURE = "\"figure\""
TABLE = "\"table\""
ROW = "\"row\""
CELL = "\"cell\""
AUTHOR_NOTES = "\"authornotes\""
NOTE = "\"note\""
TAG = "\"tag\""
CONTENT = "\"content\""

/* ATTRIBUTES */
EDITION = "\"@edition\""
ID = "\"@id\""
TITLE = "\"@title\""
CAPTION = "\"@caption\""
PATH = "\"@path\""

/* SYMBOLS */
OBJ_OPEN = "{"
OBJ_CLOSE = "}"
ARRAY_OPEN = "["
ARRAY_CLOSE = "]"
ATT_SEPARATOR = ":"
COMMA = ","

/* VALUES */
/* VALUE - Usato per i valori CDATA */
VALUE = \"[ a-zA-Z0-9\-\_\.]*\"

ACCENT = (è|é|ò|à|ù|ç|ì)
SYMBOLS = (\,|\.|\;|\:|\?|\^|\!|\'|\"|\$|\&|\£|\%|\(|\)|\=|\*|\\|\+|\-|\_|§|°|#|@)
/* CONTENT - Usato come PCDATA - DA VERIFICARE */
PCDATA = \"([ \t]*({ACCENT}|{SYMBOLS}|[a-zA-Z0-9])+[ \t]*)*\"

/* SPECIAL CHARACTERS */
NL = \r\n|\r|\n

/* START CONDITIONS */
%x IN_OBJ IN_ARRAY

%%

/*
	Regole di traduzione
*/

/* ELEMENTS */
<IN_OBJ> {
	{TAG}
		{
			yyparser.yylval = new ParserVal(yytext()); 
			return Parser.TAG;
		}
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
	
	{CONTENT}
		{
			yyparser.yylval = new ParserVal(yytext()); 
			return Parser.CONTENT; 
		}
 }

/* ATTRIBUTES */
<IN_OBJ> { 
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
<YYINITIAL, IN_ARRAY> {OBJ_OPEN}
	{
		yybegin(IN_OBJ);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.OBJ_OPEN;
	}
	
<IN_OBJ> {OBJ_CLOSE}
	{
		yybegin(IN_ARRAY);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.OBJ_CLOSE;
	}

<IN_OBJ> {ARRAY_OPEN}
	{
		yybegin(IN_ARRAY);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ARRAY_OPEN; 
	}
	
<IN_ARRAY> {ARRAY_CLOSE}
	{
		yybegin(IN_OBJ);
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ARRAY_CLOSE; 
	}
	
<IN_OBJ> {ATT_SEPARATOR}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.ATT_SEPARATOR; 
	}
<IN_OBJ, IN_ARRAY> {COMMA}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.COMMA; 
	}
/* VALUES */
<IN_OBJ> {VALUE}
	{
		yyparser.yylval = new ParserVal(yytext()); 
		return Parser.VALUE; 
	}
	
<IN_ARRAY> {
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

	{PCDATA}
		{
			yyparser.yylval = new ParserVal(yytext()); 
			return Parser.PCDATA; 
		}
}

/* SPECIAL CHARACTERS */
<YYINITIAL, IN_OBJ, IN_ARRAY> {
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