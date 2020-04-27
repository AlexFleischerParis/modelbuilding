// Milk collection : Problem 23 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=

//Instead of using MIP  ( opl\examples\opl\models\TravelingSalesmanProblem ) let's use CPOptimizer'

    using CP;

    int scale=1000000;

    range days=1..2;

    int n=...;
    range points=1..n;
    int X[points]=...;
    int Y[points]=...;
    int Vol[points]=...;
    int truckCapacity=...;
    int EveryOtherDay[points]=...;

     

    range   Cities  = 1..n;

    int realCity[i in 1..n+1]=(i<=n)?i:1;

     

    // Edges -- sparse set
    tuple       edge        {int i; int j;}
    setof(edge) Edges       = {<i,j> | ordered i,j in 1..n};
    setof(edge) Edges2       = {<i,j> | i,j in 1..n+1};  // node n+1 is node 1


    int         dist[<i,j> in Edges] = ftoi(ceil(scale*(sqrt(pow(X[i]-X[j],2)+pow(Y[i]-Y[j],2)))));
    int         dist2[<i,j> in Edges2]=(realCity[i]==realCity[j])?0:
    ((realCity[i]<realCity[j])?dist[<realCity[i],realCity[j]>]:dist[<realCity[j],realCity[i]>]);

     

    dvar interval itvs[days][1..n+1] optional size 1;


    dvar sequence seq[d in days] in all(i in 1..n+1) itvs[d][i];

    execute
    {

    cp.param.TimeLimit=10;

    }

    tuple triplet { int c1; int c2; int d; };
    {triplet} Dist = {
          <i-1,j-1,dist2[<i ,j >]>
               |  i,j in 1..n+1};
               
    dexpr float totalDistance= 1/scale*sum(d in days) (endOf(itvs[d][n+1]) - (n+1)) ;         
    minimize totalDistance;           
    subject to
    {
        forall( d in days)
        {
            startOf(itvs[d][1])==0; // break sym
            noOverlap(seq[d],Dist,true);    // nooverlap with a distance matrix
            last(seq[d], itvs[d][n+1]); // last node
            presenceOf(itvs[d][n+1])==1;
        }    
        
        // all days
        forall(d in days) forall(i in 1..n:EveryOtherDay[i]==0) presenceOf(itvs[d][i])==1;
        
        // every other day
        forall(i in 1..n:EveryOtherDay[i]==1) sum(d in days) presenceOf(itvs[d][i])==1;
        
        // Capacity
        
        forall(d in days) sum(i in 1..n) presenceOf(itvs[d][i])*Vol[i]<=truckCapacity;
    }

    execute
    {
    writeln("Total distance = ",totalDistance);
    }

