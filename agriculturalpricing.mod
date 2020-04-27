// Agricultural Pricing  is the problem 21 in Model Building by H. Paul Williams
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=
// Basic revenue management case with both elasticity and cross elasticity 


    execute
     {
     cplex.optimalitytarget=3;
     }
     
    {string} Products=...;
    {string} Components=...;

    float use[Products][Components]=...;

    float domesticConsumption[Products]=...;
    float price[Products]=...;
    float elasticity[Products]=...;
    float crossElasticity[Products][Products]=...;

    float limit[Components]=...;

    dvar float deltaPrice[Products];
    dvar float deltaConsumption[Products];

    dvar float newPrice[p in Products];
    dvar float newConsumption[p in Products];

    maximize sum(p in Products) newPrice[p]*newConsumption[p];
    subject to
    {

    forall(p in Products)
      {
        newPrice[p]==price[p]+deltaPrice[p];
        newConsumption[p]==domesticConsumption[p]+deltaConsumption[p];
    }


    ctPriceIndexLimit:
    sum(p in Products) domesticConsumption[p]*newPrice[p]<=sum(p in Products) domesticConsumption[p]*price[p];


    forall(p in Products)
     {
     ctPositivePrice:newPrice[p]>=0;
     ctPositiveConsumption:newConsumption[p]>=0;
     }


    forall(p in Products)
    ctelasticity:
        deltaConsumption[p]/domesticConsumption[p]==
        -elasticity[p]*deltaPrice[p]/price[p]
        +sum(p2 in Products) crossElasticity[p][p2]*deltaPrice[p2]/price[p2];
        
    forall( c in Components)
    ctLimits:
    1/100*sum(p in Products) use[p][c]*newConsumption[p]<=limit[c];

    }

