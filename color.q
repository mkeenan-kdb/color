.cf.OPERATOR:("+-*><.@#$%^&!_',\/=|~?/")
.cf.SPLIT:("{([;:])}")
.cf.QSQL:("select";"from";"where";"by")
.cf.COLOR_CODE:(!). flip 2 cut(
 `BOLDWHITE;  "\033[0m";
 `YELLOW;     "\033[33m";
 `ORANGE;     "\033[1;31m";
 `BLUE;       "\033[1;34m";
 `UNDERRED;   "\033[31;4m";
 `GREEN;      "\033[32m";
 `RED;        "\033[31m";
 `PINK;       "\033[1;35m";
 `DEFAULT;    "\033[36m";
 `KPROMPT;    "\033[1;41m";
 `ENDC;       "\033[0m")
/map colours and keywords
.cf.COLOR_MAP:ungroup flip `color`keyword!(`BLUE;{` sv'`,/:x,/:(key ` sv `,x)except`}each `q`Q`h`j`o)
.cf.COLOR_MAP:.cf.COLOR_MAP uj select color:`YELLOW,`$3_'string[keyword]from .cf.COLOR_MAP where keyword like".q.*"
.cf.COLOR_MAP:.cf.COLOR_MAP uj uj/[{[clr;wrd] flip select color:clr,keyword:`$'.cf[wrd] from (0#`)!()}./:flip(`RED`BOLDWHITE`YELLOW;`OPERATOR`SPLIT`QSQL)]
.cf.COLOR_MAP:update string[keyword]from .cf.COLOR_MAP
.cf.colorWrap:{[color;str]
 :str sv .cf.COLOR_CODE[color,`ENDC];
 }
.cf.tagit:{[clrs;splt;clr;str] $[all null id:where null clrs;clrs;@[clrs;where str~/:{@[first;x;0b]}each splt;:;clr]]}
/parse colours
.cf.colorise:{[d;qt]
 /if this is a table - use the logic from .h.jx
 sdata:$[qt;$["\n.."~-3#r:"\n"sv .Q.S[value"\\c";0j]d;-3_r;r];-1_.Q.s d];
 /handle the k) - tokeniser will complain - looking for the missing bracket
 sdata:ssr[sdata;"k)";" .special.kprompt "];
 /if the data can be tokenised, do it - otherwise tokenise as much as we can
 split:$[last split:@[{(-4!ssr[x;"\n";" .special.newline "];1b)};sdata;(();0b)];first split;-3_raze({r:$[all bl:10h=abs type@/:first@/:y;y;raze({x last where y}[y;];{enlist each x where not y}[x;])@\:bl];r,-4!" .special.newline "})./:{(x;@[-4!;x;{[d;e] args:flip(c;(c:1+til count d)#\:d);{$[1~count y;y;@[-4!;y;x]]}./:args}[x;]])}each"\n"vs sdata];
 /make note of k) and "\n" - replace when we are done
 nlines:{$[1~count x;first x;x]}where split~\:".special.newline";
 klines:{$[1~count x;first x;x]}where split~\:".special.kprompt";
 /add colours for all keywords, seperators and operators
 colors:{.cf.COLOR_MAP[first where y~/:x]`color}[(flip .cf.COLOR_MAP)`keyword;]each split;
 /add colours for strings and symbols
 colors:.cf.tagit[.cf.tagit[colors;split;`UNDERRED;"\""];split;`GREEN;"`"];
 /add colours for numbers & times/dates otherwise just leave
 if[not all null where null colors;
    colors:@[colors;where null colors;:;?[{@[{(type value x)in(`short$neg[1 4 5 6 7 8 9])};x;0b]}each split where null colors;`ORANGE;`]];];
 if[not all null where null colors;
    colors:@[colors;where null colors;:;?[{@[{(type value x)in(`short$neg[12 13 14 15 16 17 18 19])};x;0b]}each split where null colors;`PINK;`DEFAULT]];];
 /add all ansi escape sequences
 res:.cf.colorWrap ./:flip(colors;split);
 /keep only the indices referenced in 'keep'
 keep:til count res;
 if[not all null nlines;res:@[res;nlines;:;"\n"];keep:keep except raze{(x-1;x+1)}each nlines;];
 /if[not all null klines;res:@[res;klines;:;.cf.colorWrap[`KPROMPT;"k)"]];keep:keep except raze{(x-1;x+1)}each klines;];
 keep:keep except raze{(x-1;x+1)}each klines;
 :$[not all null klines;ssr[;".special.kprompt";.cf.colorWrap[`KPROMPT;"k)"]]raze res keep;raze res keep];
 }
/user input handler
-1("Turn colors off with .cf.off[] and on with .cf.on[]")sv .cf.COLOR_CODE`UNDERRED`ENDC;
.cf.on:{ `.z.pi set .cf.zpi;}
.cf.off:{value"\\x .z.pi";}
.cf.zpi:.z.pi:{
 x:-1_x;
 res:@[value;x;{-1"'",x;:".cf.ERROR";}];
 if[res~".cf.ERROR";value x;];
 if[res~(::);-1@0#res;:res;];
 qt:any 98 99h in type res;
 sres:.cf.colorise[res;qt];
 if[sres~".cf.ERROR";-1 .Q.s[res];:res;];
 -1 sres;
 :res;
 }
