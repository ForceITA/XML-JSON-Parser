%{
  import java.io.*;
%}

/*
	TOKEN - TERMINALI
	TYPE - Non Terminali
*/
%token <sval> 
	INTRO_XML INTRO_DOC
	BOOK DEDICATION PREFACE PART TOC LOF LOT ITEM CHAPTER 
	SECTION FIGURE TABLE ROW CELL AUTHOR_NOTES NOTE
	EDITION ID TITLE CAPTION PATH
	TAG_OPEN TAG_CLOSE CLOSE_TAG_OPEN CLOSE_TAG_CLOSE ATT_SEPARATOR
	VALUE ACCENT SYMBOLS CONTENT
	COMMENT
	NL

%type <sval>
	doc book content
	dedication 
	edition pcdata

%%

/*
	Produzioni
*/

doc: 
INTRO_XML INTRO_DOC book
	{
		System.out.println($3);
	};

book: 
TAG_OPEN BOOK edition TAG_CLOSE content CLOSE_TAG_OPEN BOOK TAG_CLOSE
	{
		$$ = $2 + $3 + $5;
	};

edition:
/* epsilon */
	{
		$$ = "";
	}
	|
EDITION ATT_SEPARATOR VALUE
	{
		$$ = $1;
	};

content: 
dedication /* preface part author_notes */
	{
		$$ = $1 /* + $2 + $3 + $4 */;
	};

dedication:
/* epsilon */
	{
		$$ = "";
	}
	|
TAG_OPEN DEDICATION TAG_CLOSE pcdata CLOSE_TAG_OPEN DEDICATION TAG_CLOSE
	{
		$$ = $2 + $4;
	};
	
pcdata:
CONTENT
	{
		$$ = $1;
	};


%%
  private Yylex lexer;

  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }

  public static void main(String args[]) throws IOException {
    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
    }
    else {
      System.out.println("ERROR: Provide an input file as Parser argument");
    }
  }
     