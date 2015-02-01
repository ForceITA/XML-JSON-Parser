%{
  import java.io.*;
%}

/*
	TOKEN - TERMINALI
	TYPE - Non Terminali
*/

%token <sval> TAG_OPEN TAG_CLOSE NL CLOSE_TAG_OPEN
%token <sval> BOOK TEXT
%type <sval> tag doc


%%

/*
	Produzioni
*/

doc: tag		{ System.out.println($1); }
	;

tag: TAG_OPEN BOOK TAG_CLOSE TEXT CLOSE_TAG_OPEN BOOK TAG_CLOSE 
	{ 
		$$ = 	'{' + System.lineSeparator() + 
				'\t' + '\"' + "tag" + '\"' + ": " + '\"' + $2 + '\"' + ',' + System.lineSeparator() +
				'\t' + '\"' + "content" + '\"' + ": " + '[' + '\"' + $4.trim() + '\"' + ']'+ System.lineSeparator() +'}';
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
     