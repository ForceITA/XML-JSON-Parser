/*
	User-defined
*/
%%

%byaccj

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

/*
	Espressioni Regolari
*/

/*
	Elements
*/
OPEN_BRACE = "{"
CLOSE_BRACE = "}"
TAG = "tag"
INTRODUCE = "\:"
NAME_TAG = "\"[^\"]\""

/* SPECIAL CHARACTERS */
NL = \r\n|\r|\n

%%

/*
	Regole di traduzione
*/

{OPEN_BRACE}
	{
		yyparser.yylval = new ParserVal(yytext());
		return Parser.OPEN_BRACE;
	}; 
	
{CLOSE_BRACE}
	{
		yyparser.yylval = new ParserVal(yytext());
		return Parser.CLOSE_BRACE;
	};

{TAG}
	{
	yyparser.yylval = new ParserVal(yytext());
	return Parser.TAG;	
	};	

{OPEN_NAME_TAG}
	{
	yyparser.yylval = new ParserVal(yytext());
	return Parser.OPEN_NAME_TAG;	
	};	
	
{NAME_TAG}
	{
		return Parser.NAME_TAG;
	};
	
{CLOSE_NAME_TAG}
	{
	yyparser.yylval = new ParserVal(yytext());
	return Parser.CLOSE_NAME_TAG;	
	};

{INTRODUCE}
	{
		yyparser.yylval = new ParserVal(yytext());
		return Parser.INTRODUCE;
	};