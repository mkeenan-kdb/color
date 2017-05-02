//========================STEP-IN==========================//
system["d .color"]
system["c 20 200"]
//========================GLOBALS==========================//
OPERATORS:enlist each("+-*><.@#$%^&!_',\/=|~?/")
SPLITS:enlist each("{([;:])}")
QSQL:("select";"delete";"update";"from";"where";"by")
NSPACE_VARS:string raze{.Q.dd[`,x;]each(key` sv`,x)except`}each `q`Q`h`j`o
TOKEN_MAP:ungroup flip`token`color!((OPERATORS;SPLITS;QSQL;NSPACE_VARS);`RED`LIGHTBLUE`BOLDYELLOW`BOLDBLUE)
TOKEN_MAP,:select token:last each "."vs'token,color:`YELLOW from .color.TOKEN_MAP where token like".q*"
TOKEN_MAP,:select token:string[.Q.res],color:`YELLOW from 0#TOKEN_MAP
TYPE_MAP:(10h,neg[101 1 4 5 6 7 8 9 10 11 12 14 18 19h])!`UNDERRED`DEFAULT,(7#`ORANGE),`UNDERRED`DEFAULT`GREY`WHITE`BOLDYELLOW`LIGHTPINK
COLOR_CODES:(!). flip 2 cut(
 `YELLOW;     "\033[33m";
 `MAD;        "\033[1;45m";
 `ORANGE;     "\033[1;31m";
 `LIGHTBLUE;  "\033[36m";
 `BOLDBLUE;   "\033[1;34m";
 `BLUE;       "\033[34m";
 `UNDERRED;   "\033[31;4m";
 `GREEN;      "\033[32m";
 `RED;        "\033[31m";
 `LIGHTPINK;  "\033[35m";
 `GREY;       "\033[37m";
 `WHITE;      "\033[1m";
 `BOLDYELLOW; "\033[1;33m";
 `PINK;       "\033[1;35m";
 `DEFAULT;    "\033[0m";
 `KPROMPT;    "\033[1;41m";
 `ENDC;       "\033[0m")
KPROMPT:"k)"sv COLOR_CODES`KPROMPT`ENDC
//======================UTIL FUNCS=========================//
try2token:{@[-4!;x;y]}
color4keyword:{first where x~\:y}[exec color!token from TOKEN_MAP;]
color4type:{@[x;where null x;:;{@[{TYPE_MAP type parse x};x;`DEFAULT]}each y where null x]}
tagit:{$[y~".special.k";KPROMPT;y sv COLOR_CODES[x,`DEFAULT]]}
specialtag:{[clrs;splt;clr;str] $[all null id:where null clrs;clrs;@[clrs;where str~/:{@[first;x;0b]}each splt;:;clr]]}
off:{system["x .z.pi"];};
on:{`.z.pi set zpi;}
//======================MAIN LOGIC=========================//
tokenover:{try2token[x;{[d;e] count d}[x;]]}
tokenise:{
 if[0b~split:try2token[x;0b];
    split:tokenover each(-2_2+til count x)#\:x;
    pre:split@(a:first where -7h=type each split)-1;
    split:pre,enlist(a+1)_x;];
 :split;
 }
colorise:{
 /raw:ssr[;"\n";" .special.n "]ssr[x;"k)";" .special.k "];
 raw:ssr[-1_x;"k)";".special.k "];
 split:$[0b~split:try2token[raw;0b];
         raze -1_(tokenise each"\n"vs raw),\:enlist"\n";
         split];
 /color all namespace refs, operators, splits and QSQL
 colors:color4keyword each split;
 colors:color4type[colors;split];
 colors:specialtag[colors;split;`GREEN;"`"];
 res:tagit ./:flip(colors;split);
 -1 raze res;
 }
//====================INITIALISATION=======================//
zpi:{
 x:-1_x;
 if[x~"lf[]";`.[`lf][];-1"Script reloaded.";:();];
 r:@[value;x;{(".color.ERROR";x)}];
 if[".color.ERROR"~first r;'r[1];];
 if[r~(::);:(::);];
 colorise .Q.s r;
 :r;
 }
{`.z.pi set zpi;}[]
//=======================STEP-OUT==========================//
system["d ."]
