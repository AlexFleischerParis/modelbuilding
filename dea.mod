// Efficiency Analysis : Problem 22 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=



/*

 DEA is a very useful tool for efficiency analysis : https://en.wikipedia.org/wiki/Data_envelopment_analysis

    "Data envelopment analysis (DEA) is a nonparametric method 
    in operations research and economics for the estimation of
    production frontiers. It is used to empirically measure 
    productive efficiency of decision making units (or DMUs). 
    Although DEA has a strong link to production theory in economics,
    the tool is also used for benchmarking in operations management, 
    where a set of measures is selected to benchmark the performance of 
    manufacturing and service operations."
*/



tuple t
 {
 key int index_garage; 
 string name_garage;
 float input1;
 float input2;
 float input3;
 float input4;
 float input5;
 float input6;
 float output1;
 float output2;
 float output3;
 }
 
 {t} garage=...;
 
 tuple r
 {
 float theta;
 string indexgarage;
 string garage; 
 }
 
 reversed {r} result;
 
 
 
 int nbDMU=card(garage);
 
 int nbInputs= 6;
 int nbOutputs= 3;
 
 range DMU=1..nbDMU;
 range Input=1..nbInputs;
 range Output=1..nbOutputs;
 
 // Input
 float X[d in DMU][i in Input]=
 (i==1)*item(garage,d-1).input1+
 (i==2)*item(garage,d-1).input2+
 (i==3)*item(garage,d-1).input3+
 (i==4)*item(garage,d-1).input4+
 (i==5)*item(garage,d-1).input5+
 (i==6)*item(garage,d-1).input6;
 
 
 // Output
 float Y[d in DMU][o in Output]=
 (o==1)*item(garage,d-1).output1+
 (o==2)*item(garage,d-1).output2+
 (o==3)*item(garage,d-1).output3;
 
 int refDMU=...; // We want to measure efficiency of that DMU
 
 assert refDMU in DMU;
 
 
 dvar float+ lambda[DMU];
 dvar float+ theta;
 
 minimize theta;
 
 subject to
 {
 
 forall(j in Input)  
 	ctInput:
 		sum(i in DMU) (lambda[i]*X[i][j]) <= theta*X[refDMU][j];
 forall(j in Output) 
 	ctOutput:
 		sum(i in DMU) (lambda[i]*Y[i][j]) >= Y[refDMU][j];
 		
 }
 
 execute
 {
 writeln("theta= ",theta); 
 if (theta>=0.9990) writeln("Efficient DMU");
 else writeln("Not efficient DMU");
 writeln("lambda=",lambda);
 writeln();
 } 
 
 // Loop to measure efficiency for all DMU
 main
 {
 thisOplModel.generate(); 
 
 for(var dmu in thisOplModel.DMU)
 {
     writeln("DMU",dmu," Garage ",Opl.item(thisOplModel.garage,dmu-1).name_garage);
     for(j in thisOplModel.Input) thisOplModel.ctInput[j].setCoef(thisOplModel.theta,-thisOplModel.X[dmu][j]);
     for(j in thisOplModel.Output) thisOplModel.ctOutput[j].LB=thisOplModel.Y[dmu][j];
     cplex.solve();
     thisOplModel.postProcess();
     
 }
 
 }
 
