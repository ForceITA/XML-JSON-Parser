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
	EDITION ID TITLE CAPTION PATH PCDATA
	OBJ_OPEN OBJ_CLOSE ARRAY_OPEN ARRAY_CLOSE ATT_SEPARATOR 
	VALUE ACCENT SYMBOLS CONTENT

%type <sval>
	doc book content
	dedication preface part parts author_notes note notes toc item items
	chapter chapters section sections section_content figure 
	table row rows cell cells lof lot part_cont lof_lot
	id id_ref edition pcdata title caption path
	
%%
/*
	Produzioni
*/

doc:
book
	{
		System.out.print($1);
	};

book:
OBJ_OPEN TAG ATT_SEPARATOR BOOK COMMA edition CONTENT ATT_SEPARATOR ARRAY_OPEN content ARRAY_CLOSE OBJ_CLOSE
	{	
		$$ = "<" + $4 + " " + $6 + ">" + $10 +  "</" + $4 + ">";
	};

edition:
EDITION ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1 + "=" + $3;
	};
	
content:
dedication COMMA preface COMMA parts author_notes 
	{
		$$ = $1 + $3 + $5 + $6;
	}
	|
preface COMMA parts author_notes
	{
		$$ = $1 + $3 + $4;
	};

dedication:
OBJ_OPEN TAG ATT_SEPARATOR DEDICATION COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + ">" + $9 + "</" + $4 + ">"; 
	};

pcdata:
PCDATA
	{
		$$ = $1;
	};
	
preface:
OBJ_OPEN TAG ATT_SEPARATOR PREFACE COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" +  $4 + ">" + $9 + "</" + $4 + ">";
	};
	
parts:
part
	{
		$$ = $1;
	}
	|
parts COMMA part
	{
		$$ = $1 + $3;
	};
	
part:
OBJ_OPEN TAG ATT_SEPARATOR PART COMMA id title CONTENT ATT_SEPARATOR ARRAY_OPEN part_cont ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + " " + $6 + " " + $7 + ">" + $11 + "</" + $4 + ">";
	}
	|
OBJ_OPEN TAG ATT_SEPARATOR PART COMMA id CONTENT ATT_SEPARATOR ARRAY_OPEN part_cont ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + " " + $6 + ">" + $9 + "</" + $4 + ">";
	};

part_cont:
toc COMMA chapters lof_lot 
	{
		$$ = $1 + $3 + $4;
	};

lof_lot:
/* epsilon */
	{
		$$ = "";
	}
	|
COMMA lof COMMA lot
	{
		$$ = $2 + $4;
	}
	|
COMMA lot
	{
		$$ = $2;
	}
	|
COMMA lof
	{
		$$ = $2;
	};

id:
ID ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1 + "=" + $3;
	};

title:
TITLE ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1 + "=" + $3;
	};
	
toc:
OBJ_OPEN TAG ATT_SEPARATOR TOC COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN items ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + ">" + $9 + "</" + $4 + ">";
	};

items:
item
	{
		$$ = $1;
	}
	|
items COMMA item 
	{
		$$ = $1 + $3;
	}
	
item:
OBJ_OPEN TAG ATT_SEPARATOR ITEM COMMA id_ref CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + " " + $6 + ">" + $10 + "</" + $4 + ">";
	};
	
id_ref:
ID ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1 + "=" + $3;
	};
	
chapters:
chapter
	{
		$$ = $1;
	}
	|
chapters COMMA chapter
	{
		$$ = $1 + $3;
	};
	
chapter:
OBJ_OPEN TAG ATT_SEPARATOR CHAPTER COMMA id title CONTENT ATT_SEPARATOR ARRAY_OPEN sections ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + " " + $6 + " " + $7 + ">" + $11 + "</" + $4 + ">";
	};
	
sections:
section
	{
		$$ = $1;
	}
	|
sections COMMA section
	{
		$$ = $1 + $3;
	};
	
section:
OBJ_OPEN TAG ATT_SEPARATOR SECTION COMMA id title CONTENT ATT_SEPARATOR ARRAY_OPEN section_content ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 +  " " + $6 + " " + $7 + ">" + $11 + "</" + $4 + ">";
	};

section_content:
section_content COMMA pcdata
	{
		$$ = $1 + $3;
	}
	|
section_content COMMA section
	{
		$$ = $1 + $3;
	}
	|
section_content COMMA figure
	{
		$$ = $1 + $3;
	}
	|
section_content COMMA table
	{
		$$ = $1 + $3;
	}
	|
pcdata
	{
		$$ = 	$1;
	}
	|
section 
	{
		$$ = 	$1;
	}
	|
figure 
	{
		$$ = 	$1;
	}
	|
table
	{
		$$ = 	$1;
	};
	
	
figure:
OBJ_OPEN TAG ATT_SEPARATOR FIGURE COMMA id caption path OBJ_CLOSE
	{
		$$ = "<" + $4 + " " + $6 + " " + $7 + " " + $8 + "/>";
	};

caption:
CAPTION ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1 + "=" + $3;
	};

path:
PATH ATT_SEPARATOR VALUE
	{
		$$ = $1 + "=" + $3;
	};
	
table:
OBJ_OPEN TAG ATT_SEPARATOR TABLE COMMA id caption CONTENT ATT_SEPARATOR ARRAY_OPEN rows ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + " " + $6 + " " + $7 + ">" + $11 + "</" + $4 + ">";
	};
	
rows:
row
	{
		$$ = $1;
	}
	|
rows COMMA row
	{
		$$ = $1 + $3; 
	};

row:
OBJ_OPEN TAG ATT_SEPARATOR ROW COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN cells ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + ">" + $9 + "</" + $4 + ">";
	};

cells:
cell
	{
		$$ = $1;
	}
	|
cells COMMA cell
	{
		$$ = $1 + $3;
	};
	
cell:
OBJ_OPEN TAG ATT_SEPARATOR CELL COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + ">" + $9 + "</" + $4 + ">";
	};
	
lof:
OBJ_OPEN TAG ATT_SEPARATOR LOF COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN items ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + ">" + $9 + "</" + $4 + ">";
	};
	
lot:
OBJ_OPEN TAG ATT_SEPARATOR LOT COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN items ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + ">" + $9 + "</" + $4 + ">";
	};
	
author_notes:
	{
		$$ = "";
	}
	|
COMMA OBJ_OPEN TAG ATT_SEPARATOR AUTHOR_NOTES COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN notes ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $5 + ">" + $10 + "</" + $5 + ">";
	};
	
notes:
note
	{
		$$ = $1;
	}
	|
notes COMMA note
	{
		$$ = $1 + $2;
	};
	
note:
OBJ_OPEN TAG ATT_SEPARATOR NOTE COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4 + ">" + $8 + "</" + $4 + ">";
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