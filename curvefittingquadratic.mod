// Curve fitting is the problem 11 in Model Building by H. Paul Williams
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=
// The goal is to find the best straight line or the best quadratic curve for n given points. 



    int n=...;
    range points=1..n;
    float x[points]=...;
    float y[points]=...;

    // y== c*x*x+b*x+a

    dvar float a;
    dvar float b;
    dvar float c;

    minimize sum(i in points) abs(c*x[i]*x[i]+b*x[i]+a-y[i]);
    //minimize max(i in points) abs(c*x[i]*x[i]+b*x[i]+a-y[i]);
    subject to
    {

    }

    execute
    {
    writeln("c=",c);
    writeln("b=",b);
    writeln("a=",a);
    }

