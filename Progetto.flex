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

/* ELEMENT */
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
VALUE = \"[ a-zA-Z0-9\-\_\.]+\"
ACCENT = (è|é|ò|à|ù|ç|ì)
SYMBOLS = (\.|\,|\;|\:|\?|\^|\!|\"|\'|\$|\&|\£|\%|\(|\)|\=|\*|\[|\]|\\|\+|\-|\_|§|°|#|@)
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


/* whitespace */
<YYINITIAL,IN_TAG> [ \t]+ 			{ }

/* backspace */
<YYINITIAL,IN_TAG,IN_CONTENT> \b    { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
<YYINITIAL,IN_TAG,IN_CONTENT> [^]   { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }