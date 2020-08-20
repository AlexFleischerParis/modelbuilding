/*

Lost baggage distribution
Problem 27 in Model Building by H.P. Williams edition 5

*/

using CP;

execute
{
  cp.param.timelimit=20;
}

{string} cities=...;

tuple arc
{
  string origin;
  string destination;
}

{arc} allArcs={<o,d> | ordered o,d in cities};

int traveltime[allArcs]=...;

int allowedhorizon=...;

int n=card(cities);
int airport=1;
range visits=2..n;

int timeMatrix[i in 1..n][j in 1..n]=
  ((j!=1) && (i!=j))?((i<j)
  ?traveltime[<item(cities,i-1),item(cities,j-1)>]
  :traveltime[<item(cities,j-1),item(cities,i-1)>]):0;



// sequences of visits 
dvar int x[visits] in visits;

// Is that visit just after an airport visit ?
dvar boolean starts[visits];

// Delivery time to reach that position
dvar int+ deliveryTime[visits] in 0..allowedhorizon;

// how many vans do we use ?
dvar int+ nbVansUsed; 

// max delivery time
dvar int+ maxDeliverytime;

execute
{
  cp.addKPI(nbVansUsed,"how many vans ?");
  cp.addKPI(maxDeliverytime,"max delivery time");
}

minimize staticLex(nbVansUsed,maxDeliverytime);

subject to
{
  
// KPI definitions  
  nbVansUsed==sum(i in visits) starts[i];
  
  maxDeliverytime==max(i in visits) deliveryTime[i];
    
// all cities should be visited once  
  allDifferent(x);
  
// first we start at the airport  
  starts[2]==1;
 
  // compute delivery time
  forall(i in visits) 
     (starts[i]==1) => (deliveryTime[i]==timeMatrix[1][x[i]]);
  forall(i in visits:i!=2)
     (starts[i]!=1) => (deliveryTime[i]==deliveryTime[i-1]+timeMatrix[x[i-1]][x[i]]);
  
  
  
}

execute
{
  writeln("nb vans used : ",nbVansUsed);
  writeln("max delivery time : ",maxDeliverytime);
  writeln("delivery time : ",deliveryTime);
}

/*

which gives

nb vans used : 2
max delivery time : 100
delivery time :  [35 45 57 77 87 100 20 35 45 53 58 69 84 99]

*/


