// Optimizing a constraint : Problem 18 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=



    int n=...;

    {int} s=asSet(1..n);

    // computing all the subsets
    range r=1.. ftoi(pow(2,card(s)));
    {int} s2 [k in r] = {i | i in s: ((k div (ftoi(pow(2,(ord(s,i))))) mod 2) == 1)};
     
    // initial constraint
    int coef[s]=...;
    int rhs=...;

    // result constraint
    dvar int coef2[i in s] in ((coef[i]>=0)?0:-maxint)..((coef[i]>=0)?maxint:0);
    dvar int rhs2;

    minimize abs(rhs2);
    subject to
    {
    forall(i in r)
     (sum(j in s2[i]) coef2[j]<=rhs2)
     ==
     (sum(j in s2[i]) coef[j]<=rhs);
    }

    execute display
    {
    for(var i in s)
    {
      write(coef2[i],"x",i);
      if (i!=n) if (coef2[i+1]>=0) write("+");
    }
    writeln("<=",rhs2);
    }

