%{
  import java.io.*;
%}

/*
	TOKEN - TERMINALI
	TYPE - Non Terminali
*/

%token <sval> 
	OPEN_BRACE CLOSE_BRACE OPEN_NAME_TAG CLOSE_NAME_TAG TAG INTRODUCE STRING 


%type <sval>
	open_tag 
%%
/*
	Produzioni
*/
open_tag:
OPEN_BRACE tag contenuto
{
		$$ = "<" + $2 + ">" + "</"+ $2+ ">";
};

tag:
	TAG INTRODUCE OPEN_NAME_TAG TAG CLOSE_NAME_TAG
{
	$$ = ;
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
      System.err.println("IO error :" + e);
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
      // Parse a file
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
    }
    else {
      System.out.println("ERROR: Provide an input file as Parser argument");
    }
  }