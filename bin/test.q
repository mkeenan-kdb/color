k)testFunc:{[symbol;price]
 a:`a`b`c,"S"$"Hello";
 show a;
 .Q.en;
 show .Q.fmt;
 .h.htc[`a;"hello"];
 testTable:([] syms:10?`aa`bb`cc;prices:10?til 20;times:10?.z.T);
 res:select from testTable where syms=symbol,prices>price;
 $[1>10;`yes;`no];
 `list set "thisIsAString";
 @[list;0;:;"1"];
 :res;
 }

tf2:{[symbol;price]
 a:`a`b`c,"S"$"Hello";
 .Q.en;
 t:([] syms:10?`aa`bb`cc;prices:10?til 20);
 select max prices by syms from t;
 }

test:(``str`symlist`sym`dict`func`num`numlist!(::;"Hello";`a`b`c;`e;`k1`k2`k3!`v1`v2`v3;{2+x};10;1 2 3f))
