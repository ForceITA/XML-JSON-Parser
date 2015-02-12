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
		String xml_intro = "<?xml version='1.0' encoding='UTF-8'?>";	
		String xml_doc = "<!DOCTYPE book SYSTEM \"book.dtd\">";
		String output = xml_intro + System.lineSeparator() + xml_doc + System.lineSeparator() + formatXML($1);	
		try{
			check();
			System.out.print(output);
		}
		catch (IOException e) {
			System.err.println("IO error :" + e);
		}
	};

book:
OBJ_OPEN TAG ATT_SEPARATOR BOOK COMMA edition CONTENT ATT_SEPARATOR ARRAY_OPEN content ARRAY_CLOSE OBJ_CLOSE
	{	
		$$ = "<" + $4.substring(1, $4.length() - 1) + " " + $6 + ">" + $10 +  "</" + $4.substring(1, $4.length() - 1) + ">";
	};

edition:
EDITION ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1.substring(2, $1.length() - 1) + "=" + $3;
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
		$$ = "<" + $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">"; 
	};

pcdata:
PCDATA
	{
		$$ = $1.substring(1, $1.length() - 1).trim().replaceAll("(\\\\r\\\\n|\\\\r|\\\\n)+", System.lineSeparator()).replace("\\\\", "\\");
	};
	
preface:
OBJ_OPEN TAG ATT_SEPARATOR PREFACE COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" +  $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
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
		$$ = "<" + $4.substring(1, $4.length() - 1) + " " + $6 + " " + $7 + ">" + $11 + "</" + $4.substring(1, $4.length() - 1) + ">";
	}
	|
OBJ_OPEN TAG ATT_SEPARATOR PART COMMA id CONTENT ATT_SEPARATOR ARRAY_OPEN part_cont ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4.substring(1, $4.length() - 1) + " " + $6 + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
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
		if(idMap.containsKey($3)){
			yyerror("Rilevato ID doppio: " + $3);
		}else{
			idMap.put($3, $3);
		}
		$$ = $1.substring(2, $1.length() - 1) + "=" + $3;
	};

title:
TITLE ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1.substring(2, $1.length() - 1) + "=" + $3;
	};
	
toc:
OBJ_OPEN TAG ATT_SEPARATOR TOC COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN items ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
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
		$$ = "<" + $4.substring(1, $4.length() - 1) + " " + $6 + ">" + $10 + "</" + $4.substring(1, $4.length() - 1) + ">";
	};
	
id_ref:
ID ATT_SEPARATOR VALUE COMMA
	{
		idRef.push($3);
		$$ = $1.substring(2, $1.length() - 1) + "=" + $3;
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
		$$ = "<" + $4.substring(1, $4.length() - 1) + " " + $6 + " " + $7 + ">" + $11 + "</" + $4.substring(1, $4.length() - 1) + ">";
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
		$$ = "<" + $4.substring(1, $4.length() - 1) +  " " + $6 + " " + $7 + ">" + $11 + "</" + $4.substring(1, $4.length() - 1) + ">";
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
		$$ = "<" + $4.substring(1, $4.length() - 1) + " " + $6 + " " + $7 + " " + $8 + "/>";
	};

caption:
CAPTION ATT_SEPARATOR VALUE COMMA
	{
		$$ = $1.substring(2, $1.length() - 1) + "=" + $3;
	};

path:
PATH ATT_SEPARATOR VALUE
	{
		$$ = $1.substring(2, $1.length() - 1) + "=" + $3;
	};
	
table:
OBJ_OPEN TAG ATT_SEPARATOR TABLE COMMA id caption CONTENT ATT_SEPARATOR ARRAY_OPEN rows ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4.substring(1, $4.length() - 1) + " " + $6 + " " + $7 + ">" + $11 + "</" + $4.substring(1, $4.length() - 1) + ">";
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
		$$ = "<" + $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
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
		$$ = "<" + $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
	};
	
lof:
OBJ_OPEN TAG ATT_SEPARATOR LOF COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN items ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
	};
	
lot:
OBJ_OPEN TAG ATT_SEPARATOR LOT COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN items ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
	};
	
author_notes:
	{
		$$ = "";
	}
	|
COMMA OBJ_OPEN TAG ATT_SEPARATOR AUTHOR_NOTES COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN notes ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $5.substring(1, $5.length() - 1) + ">" + $10 + "</" + $5.substring(1, $5.length() - 1) + ">";
	};
	
notes:
note
	{
		$$ = $1;
	}
	|
notes COMMA note
	{
		$$ = $1 + $3;
	};
	
note:
OBJ_OPEN TAG ATT_SEPARATOR NOTE COMMA CONTENT ATT_SEPARATOR ARRAY_OPEN pcdata ARRAY_CLOSE OBJ_CLOSE
	{
		$$ = "<" + $4.substring(1, $4.length() - 1) + ">" + $9 + "</" + $4.substring(1, $4.length() - 1) + ">";
	};

	
%%

  private Yylex lexer;
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
  
  public String formatXML(String input){
		String output = new String();
		int indenta = 0;
		for(int i = 0; i < input.length(); i++){
			switch(input.charAt(i))
			{
				case '<':
					if(input.charAt(i + 1) == '/'){
						i++;
						output += System.lineSeparator();
						indenta--;
						for(int j = 0; j < indenta; j++){
							output += "\t"; 
						}
						output += "</";
					}else{
						output += System.lineSeparator();
						for(int j = 0; j < indenta; j++){
							output += "\t";
						}
						indenta++;
						output += "<";
					}
					break;
				case '>':
					if(i + 1 < input.length() && input.charAt(i + 1) != '<'){
						output += ">" + System.lineSeparator();
						for(int j = 0; j < indenta; j++){
							output += "\t";
						}
					}else{
						output += ">";
					}
					break;
				case '/':
					if(input.charAt(i + 1) == '>'){
						i++;
						output += "/>";
						indenta--;
					}
					break;
				case 13:
				case 10:
					if(input.charAt(i) == 13 && input.charAt(i + 1) == 10 ){
						i++;
					}
					output += System.lineSeparator();
					for(int j = 0; j < indenta; j++){
						output += "\t";
					}
					break;
				default:
					output += input.charAt(i);
			}
		}
		return output.trim();
	}