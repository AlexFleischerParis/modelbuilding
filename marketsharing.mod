// Market Sharing : Problem 13 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=


    {string} retailers=...;

    int region[retailers]=...;
    int oilMarket[retailers]=...;
    int deliveryPoints[retailers]=...;
    int spiritMarket[retailers]=...;
    string growthCategory[retailers]=...;

    float D1percentage=...;
    float toleranceMax=...;

    {int} regions={region[r] | r in retailers};
    {string} cats={growthCategory[r] | r in retailers};

    int nbConstraints=2+card(regions)+card(cats);

    dvar boolean x[retailers]; // is the retailer for D1 ?
    dvar float tolerance[1..nbConstraints] in -toleranceMax..toleranceMax;

    dvar float obj1;
    dvar float obj2;

    //minimize obj1*1000+obj2; // without staticLex
    minimize staticLex(obj1,obj2);  // with staticLex

    subject to
    {
    obj1==sum(i in 1..nbConstraints) abs(tolerance[i]); // First objective
    obj2==max(i in 1..nbConstraints) abs(tolerance[i]); // Second objective

     

    tolerance[1]==-D1percentage+100*sum(r in retailers) x[r]*deliveryPoints[r]/(sum(r in retailers) deliveryPoints[r]);            

    tolerance[2]==-D1percentage+100*sum(r in retailers) x[r]*spiritMarket[r]/(sum(r in retailers) spiritMarket[r]);

    forall(reg in regions)
      tolerance[3+ord(regions,reg)]==
         -D1percentage+100*sum(r in retailers:region[r]==reg)
             x[r]*oilMarket[r]/(sum(r in retailers:region[r]==reg) oilMarket[r]);
             
    forall(cat in cats)
      tolerance[3+card(regions)+ord(cats,cat)]==
         -D1percentage+100*sum(r in retailers:growthCategory[r]==cat)
             x[r]/(sum(r in retailers:growthCategory[r]==cat) 1);
    }

    {string} retailersD1={r | r in retailers : x[r]==1};

    execute
    {
    writeln("Retailer for D1 : ",retailersD1);
    }

