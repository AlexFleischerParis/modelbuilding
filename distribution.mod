// Distribution : Problem 19 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=


    {string} factories=...;
    {string} depots=...;
    {string} customers=...;

    int monthlyCapacity[factories]=...;
    int monthlyMaxThroughput[depots]=...;
    int monthlyRequirement[customers]=...;

    tuple cost
    {
    key string origin;
    key string destination;
    float price;
    }

    tuple preference
    {

    string origin;
    string destination;
    }

    {cost} costFactoryToDepot with origin in factories,destination in depots=...;
    {cost} costDepotToCustomer with origin in depots,destination in customers=...;
    {cost} costFactoryToCustomer with origin in factories,destination in customers=...;

    {string} origins=factories union depots;

    {preference} preferences with origin in origins=...;

    {string} customersWithPreferences={p.destination | p in preferences};

    dvar float+ x[factories][depots];
    dvar float+ y[factories][customers];
    dvar float+ z[depots][customers];

    dvar float totalCost;
    dvar float unmetPreferences;

    minimize totalCost;
    subject to
    {

     


    totalCost==
    sum(c in costFactoryToDepot) c.price*x[c.origin][c.destination]
    +sum(c in costDepotToCustomer) c.price*z[c.origin][c.destination]
    +sum(c in costFactoryToCustomer) c.price*y[c.origin][c.destination]
    ;

    // Links with no cost do not exist
    forall(o in factories,d in depots:0== (<o,d>  in costFactoryToDepot)) x[o][d]==0;
    forall(o in factories,d in customers: 0 == (<o,d> in costFactoryToCustomer)) y[o][d]==0;
    forall(o in depots,d in customers: (0==<o,d>  in costDepotToCustomer)) z[o][d]==0;

    forall(i in factories)
        ctFactoryCapacity:
            sum(j in depots) x[i][j]+sum(k in customers) y[i][k]<=monthlyCapacity[i];
            
    forall(j in depots)        
        ctInDepots:
            sum(i in factories) x[i][j]<=monthlyMaxThroughput[j];
            
    forall(j in depots)        
        ctOutDepots:
            sum(i in factories) x[i][j]==sum(k in customers) z[j][k];
            
    forall(k in customers)
          ctCustomerRequirement:
              sum(i in factories) y[i][k] + sum(j in depots) z[j][k] == monthlyRequirement[k];    
              
    ctUnMetPrefs:unmetPreferences==sum(k in customersWithPreferences)
     
        (monthlyRequirement[k]
            -sum(p in preferences:p.destination==k && p.origin in factories)    y[p.origin][k]    -    
            sum(p in preferences:p.destination==k && p.origin in depots)    z[p.origin][k])    ;
            

            
    }

    execute
    {
    writeln("total cost = ",totalCost);

    for(var f in factories) for(var d in depots) if (x[f][d]>0) writeln(f," --> ",d," : ",x[f][d]);
    for(var f in factories) for(var c in customers) if (y[f][c]>0) writeln(f," --> ",c," : ",y[f][c]);
    for(var d in depots) for(var c in customers) if (z[d][c]>0) writeln(d," --> ",c," : ",z[d][c]);
    }

    main
    {
    thisOplModel.generate();
    cplex.solve();
    thisOplModel.postProcess();

    writeln();
    writeln("And now with taking into account preferences as much as possible");
    writeln();

    cplex.setObjCoef(thisOplModel.unmetPreferences,1000000);
    cplex.solve();
    thisOplModel.postProcess();

    }

