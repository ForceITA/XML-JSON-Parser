%{
  import java.io.*;
  import java.util.HashMap;
  import java.util.Stack;
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
INTRO_XML INTRO_DOC book
	{
		String output = formatJSON($3);
		try{
			check();
			System.out.print(output);
		}
		catch (IOException e) {
			System.err.println("IO error :" + e);
		}
	};

book: 
TAG_OPEN BOOK edition TAG_CLOSE content CLOSE_TAG_OPEN BOOK TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"" +
				$3 +
				"\"content\": [" +
				$5 +
				"]" +
				"}";
	};

edition:
/* epsilon */
	{
		$$ = 	",\"@edition\": \"\",";
	}
	|
EDITION ATT_SEPARATOR VALUE
	{
		$$ =	"," +
				"\"@" + $1 + "\": " + $3 + ",";
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
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				"\"content\": [" +
				$4 + "]" +
				"},";
	};
	
pcdata:
CONTENT
	{
		$$ = 	recordSeparator + "\"" + $1.trim().replace("\t", "").replace("\\", "\\\\").replaceAll("(\\n|\\r|\\r\\n)+", "\\\\r\\\\n") + "\"" + recordSeparator;
	};
	
preface:
TAG_OPEN PREFACE TAG_CLOSE pcdata CLOSE_TAG_OPEN PREFACE TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				"\"content\": [" +
				$4 + "]" +
				"},"; 
	};
	
parts:
part 
	{
		$$ = 	$1;
	}
	|
parts part
	{
		$$ = 	$1 + "," +
				$2;	
	};

part:
TAG_OPEN PART id title TAG_CLOSE part_cont CLOSE_TAG_OPEN PART TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				$4 +				
				"\"content\": [" +
				$6 + "]" +
				"}";
	}
	|
TAG_OPEN PART id TAG_CLOSE part_cont CLOSE_TAG_OPEN PART TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				"\"@title\" : \"\"," +
				"\"content\": [" +
				$5 + "]" +
				"}";
	};
	
part_cont:
toc chapters lof_lot
	{
		$$ = 	$1 + $2 + $3;
	};
	
lof_lot:
/* epsilon */
	{
		$$ = 	"";
	}
	|
lof lot
	{
		$$ = 	$1 + $2;
	}
	|
lot
	{
		$$ = 	$1;
	}
	|
lof
	{
		$$ = 	$1;
	};
	
id:
ID ATT_SEPARATOR VALUE
	{
		if(idMap.containsKey($3)){
			yyerror("Rilevato ID doppio: " + $3);
		}else{
			idMap.put($3, $3);
		}
		$$ = 	"\"@" + $1 + "\": " + $3 + ",";
	};

title:
TITLE ATT_SEPARATOR VALUE
	{
		$$ = 	"\"@" + $1 + "\": " + $3 + ",";
	};

toc:
TAG_OPEN TOC TAG_CLOSE items CLOSE_TAG_OPEN TOC TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				"\"content\": [" +
				$4 + "]" +
				"},";
	};

items:
item
	{
		$$ = 	$1;
	}
	|
items item
	{
		$$ = 	$1 + "," +
				$2;
	};

item:
TAG_OPEN ITEM id_ref TAG_CLOSE pcdata CLOSE_TAG_OPEN ITEM TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +				
				$3 +
				"\"content\": [" +
				$5 + "]" +
				"}";
	};

id_ref:
ID ATT_SEPARATOR VALUE
	{
		idRef.push($3);
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
		$$ = 	$1 + "," +
				$2;
	};

chapter:
TAG_OPEN CHAPTER id title TAG_CLOSE sections CLOSE_TAG_OPEN CHAPTER TAG_CLOSE 
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				$4 +				
				"\"content\": [" +
				$6 + "]" +
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
		$$ = 	$1 + "," +
				$2;
	};
	
section:
TAG_OPEN SECTION id title TAG_CLOSE section_content CLOSE_TAG_OPEN SECTION TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				$4 +				
				"\"content\": [" +
				$6 + "]" +
				"}";
	}
	|
TAG_OPEN SECTION id title CLOSE_TAG_CLOSE
	{
		$$ = 	"{" + 
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				$4.substring(0, $4.length() - 1) +
				"}";
	};
	
section_content:
section_content pcdata
	{
		$$ = 	$1 + "," +
				$2;
	}
	|
section_content section 
	{
		$$ = 	$1 + "," +
				$2;
	}
	|
section_content figure 
	{
		$$ = 	$1 + "," +
				$2;
	}
	|
section_content table
	{
		$$ = 	$1 + "," +
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
TAG_OPEN FIGURE id caption path TAG_CLOSE CLOSE_TAG_OPEN FIGURE TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				$4 +
				$5 +
				"}";
	}
	|
TAG_OPEN FIGURE id caption path CLOSE_TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				$4 +
				$5 +
				"}";
	};
	
caption:
CAPTION ATT_SEPARATOR VALUE
	{
		$$ = 	"\"@" + $1 + "\": " + $3 + ",";
	};

path:
/* epsilon */
	{
		$$ = 	"\"@path\": \"placeholder.jpg\",";
	}
	|
PATH ATT_SEPARATOR VALUE
	{
		$$ = 	"\"@" + $1 + "\": " + $3;
	};

table:
TAG_OPEN TABLE id caption TAG_CLOSE rows CLOSE_TAG_OPEN TABLE TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +
				$3 +
				$4 +				
				"\"content\": [" +
				$6 + "]" +
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
		$$ = 	$1 + "," + 
				$2;
	};

row:
TAG_OPEN ROW TAG_CLOSE cells CLOSE_TAG_OPEN ROW TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +				
				"\"content\": [" +
				$4 + "]" +
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
		$$ = 	$1 + "," +$2;
	};
	
cell:
TAG_OPEN CELL TAG_CLOSE pcdata CLOSE_TAG_OPEN CELL TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +				
				"\"content\": [" +
				$4 + "]" +
				"}";
	};
	
lof:
TAG_OPEN LOF TAG_CLOSE items CLOSE_TAG_OPEN LOF TAG_CLOSE
	{
		$$ = 	"," +
				"{" +
				"\"tag\": " + "\"" + $2 + "\"," +				
				"\"content\": [" +
				$4 + "]" +
				"}";
	};
	
lot:
TAG_OPEN LOT TAG_CLOSE items CLOSE_TAG_OPEN LOT TAG_CLOSE
	{
		$$ = 	"," +
				"{" +
				"\"tag\": " + "\"" + $2 + "\"," +				
				"\"content\": [" +
				$4 + "]" +
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
		$$ = 	"," +
				"{" +
				"\"tag\": " + "\"" + $2 + "\"," +			
				"\"content\": [" +
				$4 + "]" +
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
		$$ = 	$1 + "," +
				$2;
	};
	
note:
TAG_OPEN NOTE TAG_CLOSE pcdata CLOSE_TAG_OPEN NOTE TAG_CLOSE
	{
		$$ = 	"{" +
				"\"tag\": " + "\"" + $2 + "\"," +			
				"\"content\": [" +
				$4 + "]" +
				"}";
	};

%%
  private Yylex lexer;
  private char recordSeparator = 0x1e;
  private HashMap<String, String> idMap = new HashMap<String, String>();
  private Stack<String> idRef = new Stack<String>();
  
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
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
    } else {
      System.out.println("ERROR: Provide an input file as Parser argument");
    }
  }
  
  public void check() throws IOException{
	for(String id : idRef){
		if(!idMap.containsKey(id))
		{
			throw new IOException("Riferimento inesistente" + id);
		}
	}
	return;
  }
  
  public String formatJSON(String input){
		String output = new String();
		boolean inTesto = false;
		int indenta = 0;
		for(int i=0; i < input.length(); i++)
		{
			if(input.charAt(i) != 30)
				output += input.charAt(i);
			switch(input.charAt(i))
			{
				case '"':
					if(!inTesto)
					{
						if(i < (input.length() - 1))
							if(input.charAt(i + 1) == '}' || input.charAt(i + 1) == ']')
							{
								indenta--;
								output += System.lineSeparator();
								for(int j = 0; j < indenta; j++)
									output += "\t";
							}
					}
					break;
				case ',':
					if(!inTesto)
					{
						output += System.lineSeparator();
						for(int j = 0; j < indenta; j++)
							output += "\t";
					}
					break;
				case '{':
				case '[':
					if(!inTesto)
					{
						indenta++;
						output += "\r\n";
						for(int j = 0; j < indenta; j++)
							output += "\t";
					}
					break;
				case ']':
				case '}':
					if(!inTesto)
					{	
						if(i < (input.length() - 1))
							if(input.charAt(i + 1) == '}' || input.charAt(i + 1) == ']')
									indenta--;
						if(i < (input.length() - 1))
							if(input.charAt(i + 1) != ',')
							{
								output += System.lineSeparator();
								for(int j = 0; j < indenta; j++)
									output += "\t";
							}
					}
					break;
				case 30:
					if(inTesto)
					{
						
						if(i<(input.length() - 1))
							if(input.charAt(i + 1) == '}' || input.charAt(i+1) == ']')
							{
								indenta--;
								output += System.lineSeparator();
								for(int j = 0; j < indenta; j++)
									output += "\t";
							}	
					}
					inTesto = !inTesto;
					break;
			}
			if(inTesto && input.charAt(i) == (char)10)
			{							
				for(int j = 0; j < indenta; j++)
					output += "\t";
			}
		}
		return output;
  }