%{
  import java.io.*;
%}

/*
	TOKEN - TERMINALI
	TYPE - Non Terminali
*/
%token <sval> INTRO_XML INTRO_DOC
%token <sval>  TAG_CLOSE CLOSE_TAG_OPEN UGUALE NL
%token <sval> BOOK EDITION VALUE TEXT DEDICATION TAG_OPEN
%type <sval> doc book edition content text tags dedication


%%

/*
	Produzioni
*/

doc:
INTRO_XML NL INTRO_DOC book	
	{ 
		System.out.print($3);
	};

book:
TAG_OPEN BOOK edition TAG_CLOSE content CLOSE_TAG_OPEN BOOK TAG_CLOSE
	{
		$$ =	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"" +
				$3 +
				$5 + 
				"}"
				;
	};
	
edition:
/* epsilon */
	{
		$$ = 	"," + System.lineSeparator();
	}
	|
EDITION UGUALE VALUE
	{
		$$ =	"," + System.lineSeparator() +
				"\"@" + $1 + "\": " + $3
				;				
	};

content:
text tags
	{
		$$ = 	"," + System.lineSeparator() +
				"\"content\": [" + 
				$1 +
				$2 + "]"
				;
	};

text:
/* epsilon */
	{
		$$ = 	"";
	}
	|
TEXT
	{
		$$ = 	System.lineSeparator() +
				"\"" + $1 + "\"," +  System.lineSeparator()
				;
	};

tags:
/* epsilon */
	{
		$$ = "";
	}
	|
dedication
	{
		$$ =	$1;
	};
	
dedication:
TAG_OPEN DEDICATION TAG_CLOSE TEXT CLOSE_TAG_OPEN DEDICATION TAG_CLOSE
	{
		$$ =	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"" +
				"\t" + "\"content\": [" +  System.lineSeparator() + 
				"\t\t" + $4 + System.lineSeparator() + 
				"\t" + "]" +
				"}"
				;
	}
	
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
     