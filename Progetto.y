%{
  import java.io.*;
%}

/*
	TOKEN - TERMINALI
	TYPE - Non Terminali
*/

%token <sval> 
	BOOK DEDICATION PREFACE PART TOC LOF LOT ITEM CHAPTER 
	SECTION FIGURE TABLE ROW CELL AUTHOR_NOTES NOTE
	EDITION ID TITLE CAPTION PATH
	TAG_OPEN TAG_CLOSE CLOSE_TAG_OPEN CLOSE_TAG_CLOSE ATT_SEPARATOR
	VALUE ACCENT SYMBOLS CONTENT NL


%type <sval>
	doc book content
	dedication preface part parts author_notes note notes toc item items
	chapter chapters section sections section_content section_contents figure 
	table row rows cell cells lof lot 
	id id_ref edition pcdata title caption path
	

%%

/*
	Produzioni
*/

doc: 
book
	{
		System.out.println($1);
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
dedication preface parts author_notes 
	{
		$$ = $1 + $2 + $3 + $4;
	}
	|
preface parts author_notes
	{
		$$ = $1 + $2 + $3;
	};

dedication:
TAG_OPEN DEDICATION TAG_CLOSE pcdata CLOSE_TAG_OPEN DEDICATION TAG_CLOSE
	{
		$$ = $2 + $4;
	};
	
pcdata:
CONTENT
	{
		$$ = $1.replaceAll("\\t", "").replaceAll("(\\r|\\n|\\r\\n)+", " \\\\n ");
	};
	
preface:
TAG_OPEN PREFACE TAG_CLOSE pcdata CLOSE_TAG_OPEN PREFACE TAG_CLOSE
	{
		$$ = $2 + $4; 
	};
	
parts:
part 
	{
		$$ = $1;
	}
	|
part parts
	{
		$$ = $1 + $2;	
	};

part:
TAG_OPEN PART id title TAG_CLOSE toc chapters lof lot CLOSE_TAG_OPEN PART TAG_CLOSE
	{
		$$ = $2 + $3 + $4 + $6 + $7 + $8 + $9; 
	}
	|
TAG_OPEN PART id TAG_CLOSE toc chapters lof lot CLOSE_TAG_OPEN PART TAG_CLOSE
	{
		$$ = $2 + $3 + $5 + $6 + $7 + $8; 
	};
	
//implementare gestione uncita'
id:
ID ATT_SEPARATOR VALUE
	{
		$$= $1 + $3;
	};

title:
TITLE ATT_SEPARATOR VALUE
	{
		$$ =  $1 + $3; 
	};

toc:
TAG_OPEN TOC TAG_CLOSE items CLOSE_TAG_OPEN TOC TAG_CLOSE
	{
		$$ = $2 + $4;
	};

items:
item
	{
		$$ = $1;
	}
	|
item items
	{
		$$ = $1 + $2;
	};

item:
TAG_OPEN ITEM id_ref TAG_CLOSE pcdata CLOSE_TAG_OPEN ITEM TAG_CLOSE
	{
		$$ = $2 + $3 + $5;
	};

// implementare verifica esistenza	
id_ref:
ID ATT_SEPARATOR VALUE
	{
		$$ = $1 + $3;
	};

chapters:
chapter
	{
		$$ = $1;
	}
	|
chapter chapters
	{
		$$ = $1 + $2;
	};

chapter:
TAG_OPEN CHAPTER id title TAG_CLOSE sections CLOSE_TAG_OPEN CHAPTER TAG_CLOSE 
	{
		$$ = $2 + $3 + $4 + $6;
	};

sections:
section
	{
		$$ = $1;
	}
	|
section sections
	{
		$$ = $1 + $2;
	};
	
section:
TAG_OPEN SECTION id title TAG_CLOSE section_contents CLOSE_TAG_OPEN SECTION TAG_CLOSE
	{
		$$ = $2 + $3 + $4 + $6; 
	};
	
section_contents:
section_content
	{
		$$ = $1;
	}
	|
section_content section_contents
	{
		$$ = $1 + $2;
	}

section_content:
/* epsilon */
	{
		$$ = "";
	}
	|
pcdata
	{
		$$ = $1;
	}
	|
section
	{
		$$ = $1;
	}
	|
figure 
	{
		$$ = $1;
	}
	|
table 
	{
		$$ = $1;
	};
	
figure:
TAG_OPEN FIGURE id caption path CLOSE_TAG_CLOSE
	{
		$$ = $2 + $3 + $4 + $5;
	};
	
caption:
CAPTION ATT_SEPARATOR VALUE
	{
		$$ = $1 + $3;
	};

path:
PATH ATT_SEPARATOR VALUE
	{
		$$ = $1 + $3;
	};

table:
TAG_OPEN TABLE id caption TAG_CLOSE rows CLOSE_TAG_OPEN TABLE TAG_CLOSE
	{
		$$ = $2 + $3 + $4 + $6;
	};

rows:
row
	{
		$$ = $1;
	}
	|
row rows
	{
		$$ = $1 + $2;
	};

row:
TAG_OPEN ROW TAG_CLOSE cells CLOSE_TAG_OPEN ROW TAG_CLOSE
	{
		$$ = $2 + $4;
	};
	
cells:
cell
	{
		$$ = $1;
	}
	|
cell cells
	{
		$$ = $1 + $2;
	};
	
cell:
TAG_OPEN CELL TAG_CLOSE pcdata CLOSE_TAG_OPEN CELL TAG_CLOSE
	{
		$$ = $1 + $3;
	};
	
lof:
/* epsilon */
	{
		$$ = "";
	}
	|
TAG_OPEN LOF TAG_CLOSE items CLOSE_TAG_OPEN LOF TAG_CLOSE
	{
		$$ = $2 + $4;
	};
	
lot:
/* epsilon */
	{
		$$ = "";
	}
	|
TAG_OPEN LOT TAG_CLOSE items CLOSE_TAG_OPEN LOT TAG_CLOSE
	{
		$$ = $2 + $4;
	};

author_notes:
/* epsilon */
	{
		$$ = "";
	}
	|
TAG_OPEN AUTHOR_NOTES TAG_CLOSE notes CLOSE_TAG_OPEN AUTHOR_NOTES TAG_CLOSE
	{
		$$ = $2 + $4;
	};

notes:
note
	{
		$$ = $1;
	}
	|
note notes
	{
		$$ = $1 + $2;
	};
	
note:
TAG_OPEN NOTE TAG_CLOSE pcdata CLOSE_TAG_OPEN NOTE TAG_CLOSE
	{
		$$ = $2 + $4;
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
      // Parse a file
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
    }
    else {
      System.out.println("ERROR: Provide an input file as Parser argument");
    }
  }