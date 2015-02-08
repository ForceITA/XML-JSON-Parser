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
		System.out.println($1);
	};

book: 
TAG_OPEN BOOK edition TAG_CLOSE content CLOSE_TAG_OPEN BOOK TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"" +
				$3 + System.lineSeparator() + 
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $5 + System.lineSeparator() + 
				"]" + System.lineSeparator() +
				"}";
	};

edition:
/* epsilon */
	{
		$$ = ",";
	}
	|
EDITION ATT_SEPARATOR VALUE
	{
		$$ =	"," + System.lineSeparator() +
				"\t" + "\"@" + $1 + "\": " + $3 + ",";
	};

content: 
dedication preface parts author_notes 
	{
		$$ = 	$1 + $2 + $3 + $4;
	}
	|
preface parts author_notes
	{
		$$ = 	$1 + $2 + $3;
	};

dedication:
TAG_OPEN DEDICATION TAG_CLOSE pcdata CLOSE_TAG_OPEN DEDICATION TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}," + System.lineSeparator();
	};
	
pcdata:
CONTENT
	{
		$$ = "\"" + $1.trim().replaceAll("\\t", "").replaceAll("(\\r|\\n|\\r\\n)+", " \\\\n ") + "\"";
	};
	
preface:
TAG_OPEN PREFACE TAG_CLOSE pcdata CLOSE_TAG_OPEN PREFACE TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}," + System.lineSeparator(); 
	};
	
parts:
part 
	{
		$$ = $1;
	}
	|
parts part
	{
		$$ = 	$1 + "," + System.lineSeparator() + 
				$2;	
	};

part:
TAG_OPEN PART id title TAG_CLOSE part_cont CLOSE_TAG_OPEN PART TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + $3 + System.lineSeparator() +
				"\t" + $4 + System.lineSeparator() + 				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $6 + "]" + System.lineSeparator() +
				"}";
	}
	|
TAG_OPEN PART id TAG_CLOSE part_cont CLOSE_TAG_OPEN PART TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + $3 + System.lineSeparator() + 				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $5 + "]" + System.lineSeparator() +
				"}";
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
lof lot
	{
		$$ = $1 + $2;
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
	
//implementare gestione uncita'
id:
ID ATT_SEPARATOR VALUE
	{
		$$= 	"\"@" + $1 + "\": " + $3 + ",";
	};

title:
TITLE ATT_SEPARATOR VALUE
	{
		$$ = 	"\"@" + $1 + "\": " + $3 + ",";
	};

toc:
TAG_OPEN TOC TAG_CLOSE items CLOSE_TAG_OPEN TOC TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}," + System.lineSeparator();
	};

items:
item
	{
		$$ = $1;
	}
	|
items item
	{
		$$ = 	$1 + "," + System.lineSeparator() +
				$2;
	};

item:
TAG_OPEN ITEM id_ref TAG_CLOSE pcdata CLOSE_TAG_OPEN ITEM TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +				
				"\t" + $3 + System.lineSeparator() + 
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $5 + "]" + System.lineSeparator() +
				"}";
	};

// implementare verifica esistenza	
id_ref:
ID ATT_SEPARATOR VALUE
	{  
		$$ = 	"\"@" + $1 + "\": " + $3 + ",";
	};

chapters:
chapter
	{
		$$ = 	$1;
	}
	|
chapters chapter
	{
		$$ = 	$1 + "," + System.lineSeparator() + 
				$2;
	};

chapter:
TAG_OPEN CHAPTER id title TAG_CLOSE sections CLOSE_TAG_OPEN CHAPTER TAG_CLOSE 
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + $3 + System.lineSeparator() +
				"\t" + $4 + System.lineSeparator() + 				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $6 + "]" + System.lineSeparator() +
				"}";
	};

sections:
section
	{
		$$ = 	$1;
	}
	|
sections section
	{
		$$ = 	$1 + "," + System.lineSeparator() +
				$2;
	};
	
section:
TAG_OPEN SECTION id title TAG_CLOSE section_content CLOSE_TAG_OPEN SECTION TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + $3 + System.lineSeparator() +
				"\t" + $4 + System.lineSeparator() + 				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $6 + "]" + System.lineSeparator() +
				"}";
	};
	
section_content:
section_content pcdata
	{
		$$ = 	$1 + "," + System.lineSeparator() + 
				$2;
	}
	|
section_content section 
	{
		$$ = 	$1 + "," + System.lineSeparator() + 
				$2;
	}
	|
section_content figure 
	{
		$$ = 	$1 + "," + System.lineSeparator() + 
				$2;
	}
	|
section_content table
	{
		$$ = 	$1 + "," + System.lineSeparator() + 
				$2;
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
TAG_OPEN FIGURE id caption path CLOSE_TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + $3 + System.lineSeparator() +
				"\t" + $4 + System.lineSeparator() +
				"\t" + $5 + System.lineSeparator() + 
				"}";
	};
	
caption:
CAPTION ATT_SEPARATOR VALUE
	{
		$$ = 	"\"@" + $1 + "\": " + $3 + ",";
	};

path:
PATH ATT_SEPARATOR VALUE
	{
		$$ = 	"\"@" + $1 + "\": " + $3;
	};

table:
TAG_OPEN TABLE id caption TAG_CLOSE rows CLOSE_TAG_OPEN TABLE TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +
				"\t" + $3 + System.lineSeparator() +
				"\t" + $4 + System.lineSeparator() + 				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $6 + "]" + System.lineSeparator() +
				"}";
	};

rows:
row
	{
		$$ = 	$1;
	}
	|
rows row
	{
		$$ = 	$1 + "," + System.lineSeparator() +  
				$2;
	};

row:
TAG_OPEN ROW TAG_CLOSE cells CLOSE_TAG_OPEN ROW TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() + 				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}";
	};
	
cells:
cell
	{
		$$ = 	$1;
	}
	|
cells cell
	{
		$$ = 	$1 + "," + System.lineSeparator() + $2;
	};
	
cell:
TAG_OPEN CELL TAG_CLOSE pcdata CLOSE_TAG_OPEN CELL TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() + 				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}";
	};
	
lof:
TAG_OPEN LOF TAG_CLOSE items CLOSE_TAG_OPEN LOF TAG_CLOSE
	{
		$$ = 	"," + System.lineSeparator() +
				"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}";
	};
	
lot:
TAG_OPEN LOT TAG_CLOSE items CLOSE_TAG_OPEN LOT TAG_CLOSE
	{
		$$ = 	"," + System.lineSeparator() +
				"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +				
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}";
	};

author_notes:
/* epsilon */
	{
		$$ = 	"";
	}
	|
TAG_OPEN AUTHOR_NOTES TAG_CLOSE notes CLOSE_TAG_OPEN AUTHOR_NOTES TAG_CLOSE
	{
		$$ = 	"," + System.lineSeparator() +
				"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +			
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}";
	};

notes:
note
	{
		$$ = 	$1;
	}
	|
notes note
	{
		$$ = 	$1 + "," + System.lineSeparator() +
				$2;
	};
	
note:
TAG_OPEN NOTE TAG_CLOSE pcdata CLOSE_TAG_OPEN NOTE TAG_CLOSE
	{
		$$ = 	"{" + System.lineSeparator() + 
				"\t" + "\"tag\": " + "\"" + $2 + "\"," + System.lineSeparator() +			
				"\t" + "\"content\": [" + System.lineSeparator() +
				"\t\t" + $4 + "]" + System.lineSeparator() +
				"}";
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