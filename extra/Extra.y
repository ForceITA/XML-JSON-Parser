%{
  import java.io.*;
%}

/*
	TOKEN - TERMINALI
	TYPE - Non Terminali
*/

%token <sval> 
	TAG BOOK DEDICATION PREFACE PART TOC LOF LOT ITEM CHAPTER 
	SECTION FIGURE TABLE ROW CELL AUTHOR_NOTES NOTE COMMA
	EDITION ID TITLE CAPTION PATH 
	OBJ_OPEN OBJ_CLOSE ARRAY_OPEN ARRAY_CLOSE ATT_SEPARATOR 
	VALUE ACCENT SYMBOLS CONTENT NL

%type <sval>
	doc book edition content dedication preface parts author_notes pcdata 
	preface dedication part parts part_cont toc chapters lof_lot
	
%%
/*
	Produzioni
*/

doc:
book
	{
		$$ = $1;
	};

book:
OBJ_OPEN TAG ATT_SEPARATOR BOOK COMMA edition CONTENT ATT_SEPARATOR ARRAY_OPEN content ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $2 + " "+ $3 + ">" + $4 +  "</" + $2 + ">";
	};

edition:
/* epsilon*/
	{
		$$ = "";
	}
	|
EDITION ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1.subStrig(1, $1.length() - 1) + "=" + $3;
	};
	
content:
dedication preface COMMA parts author_notes 
	{
		$$ = $1 + $2 + $3 + $4;
	}
	|
preface COMMA parts author_notes
	{
		$$ = $1 + $2 + $3;
	};

dedication:
OBJ_OPEN TAG ATT_SEPARATOR DEDICATION CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE COMMA
	{
		$$ = "<" + $4 + ">" + $8 + "</" + $4 + ">"; 
	};

pcdata:
CONTENT
	{
		$$ = $1.subStrig(1, $1.length() - 1);
	};
preface:
OBJ_OPEN TAG ATT_SEPARATOR PREFACE COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = $3;
	};
	
parts:
part
	{
		$$ = $1;
	}
	|
parts COMMA part
	{
		$$ = $1 + $2;
	};
	
part:
OBJ_OPEN TAG ATT_SEPARATOR PART COMMA id title CONTENT ATT_SEPARATOR ARRAY_OPEN part_cont ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $2 + ">" + "</" + $2 ">";
	}
	|
OBJ_OPEN TAG PART COMMA id CONTENT ATT_SEPARATOR ARRAY_OPEN part_cont ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $2 + ">" + "</" + $2 ">";
	};

part_cont:
toc chapters lof_lot 
	{
		$$ = $1 + $2 + $3;
	};
	
lof_lot:
/* epsilon */
	{
		$$ = "";
	}
	|
lof_lot
	{
		$$ $1 + $2;
	}
	|
lot
	{
		$$ = $1;
	}
	|
lof
	{
		$$ = $1;
	};

id:
ID ATT_SEPARATOR VALUE
	{
		$$ = "BOH " + $1;
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