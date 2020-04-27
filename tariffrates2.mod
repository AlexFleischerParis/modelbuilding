// Tariff rates : Problem 15 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=


    tuple demandproperty
    {
      key int period;
      int start;
      int end;
      float quantity;
    }

    {demandproperty} demand=...;

    assert sum(d in demand) (d.end-d.start)==24;

    tuple powerstationproperty
    {
        key int type;
        int quantity;
        float minLevel;
        float maxLevel;
        float minCostPerHour;
        float marginalCostPerHour;
        float startupCost;
    }

    {powerstationproperty} powerstation=...;

    float extraguarantee=...;

    int value[powerstation][demand];

    dvar int+ nbUnitsOn[p in powerstation][d in demand] in 0..p.quantity; // number of generating units
    dvar int+ nbUnitsStarted[powerstation][demand]; // number of generating units started at that time
    dvar float+ production[powerstation][demand];

    dvar float cost;
    minimize cost;

    subject to
    {

    ctCost:cost==
        sum(d in demand,p in powerstation)
        (
            p.marginalCostPerHour*(d.end-d.start)*(production[p][d]-p.minLevel*nbUnitsOn[p][d])+
            nbUnitsOn[p][d]*(d.end-d.start)*p.minCostPerHour+    
            nbUnitsStarted[p][d]*p.startupCost
        );


    forall(d in demand)
          ctDemand:
              sum(p in powerstation) production[p][d]>=d.quantity;
          
    forall(d in demand,p in powerstation)
      {
          ctGenetatorLimits1: production[p][d]>=nbUnitsOn[p][d]*p.minLevel;
          ctGenetatorLimits2: production[p][d]<=nbUnitsOn[p][d]*p.maxLevel;
      }
     
     forall(d in demand)
        ctGuarantee:
            sum(p in powerstation) nbUnitsOn[p][d]*p.maxLevel>=(1+extraguarantee)*d.quantity;
            
     forall(d in demand,p in powerstation:d!=first(demand))  
         ctStart:
             nbUnitsStarted[p][d]>=nbUnitsOn[p][d]-nbUnitsOn[p][prev(demand,d)];     
    }

// if we want to know the rates, we can use solveFixed
    main {
      var status = 0;
      thisOplModel.generate();
      if (cplex.solve()) {
        writeln("Integer Model");   
        writeln("OBJECTIVE: ",cplex.getObjValue());   
      }
     
      for(var d in thisOplModel.demand) for(var p in thisOplModel.powerstation)
      thisOplModel.value[p][d]=thisOplModel.nbUnitsOn[p][d].solutionValue;
     
      thisOplModel.convertAllIntVars();
     
      for(var d in thisOplModel.demand) for(var p in thisOplModel.powerstation)
      {
        thisOplModel.nbUnitsOn[p][d].UB= thisOplModel.value[p][d];
        thisOplModel.nbUnitsOn[p][d].LB= thisOplModel.value[p][d];
        
        if (cplex.solve()) {
        writeln("Relaxed Model");   
        writeln("OBJECTIVE: ",cplex.getObjValue());  
        
      }
      }
     
      for(var d in thisOplModel.demand)
          writeln("Rate for period ",d.period," = ",
          thisOplModel.ctDemand[d].dual/(d.end-d.start));
     
     
     
     
    }
