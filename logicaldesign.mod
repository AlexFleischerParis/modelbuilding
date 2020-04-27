// Logical design : Problem 12 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=



    int nbMaxNOR=7;
     
    range NOR=1..nbMaxNOR;
     
    tuple arc
    {
    int o;
    int d;
    }

    {arc} arcs={<2,1>,<3,1>,<4,2>,<5,2>,<6,3>,<7,3>};
    int alpha[1..4][1..2]=[[0,0], [0,1], [1,0], [1,1]];

    {int} nonTerminal={1,2,3};
    {int} terminal=asSet(4..7);

    assert forall(i in nonTerminal) card({<j,i>  | j in NOR : <j,i> in arcs})==2;
    assert forall(i in terminal) card({<j,i> | j in NOR : <j,i> in arcs})==0;

    int j[i in nonTerminal]=first({j | j in NOR : <j,i> in arcs});
    int k[i in nonTerminal]=last({j | j in NOR : <j,i> in arcs});

    dvar boolean s[NOR]; // NOR i exists ?
    dvar boolean t[NOR][1..2]; // external output 1 or 1 or 2 is input to NOR i ?
    dvar boolean x[NOR][1..4];


    minimize sum(i in NOR) s[i];
    subject to
    {
    forall(i in NOR)
    {
    s[i]>=t[i][1];
    s[i]>=t[i][2];
    }

    forall(i in nonTerminal)
      s[j[i]]+s[k[i]]+t[i][1]+t[i][2]<=2;

    forall(i in nonTerminal,l in 1..4)
    {
        x[j[i]][l]+x[i][l]<=1;
        x[k[i]][l]+x[i][l]<=1;
    }

    forall(i in NOR,l in 1..4)
    {
        alpha[l][1]*t[i][1]+x[i][l]<=1;
        alpha[l][2]*t[i][2]+x[i][l]<=1;
    }

    forall(i in terminal,l in 1..4)
        alpha[l][1]*t[i][1]+alpha[l][2]*t[i][2]+x[i][l]-s[i]>=0;
        
    forall(i in nonTerminal,l in 1..4)     
        alpha[l][1]*t[i][1]+alpha[l][2]*t[i][2]+x[j[i]][l]+x[k[i]][l]+x[i][l]-s[i]>=0;
        
    // xor    
    x[1][1]==0;    
    x[1][2]==1;    
    x[1][3]==1;    
    x[1][4]==0;    

    // and
    //x[1][1]==0;    
    //x[1][2]==0;    
    //x[1][3]==0;    
    //x[1][4]==1;    

    forall(i in NOR, l in 1..4)
      s[i]>=x[i][l];

    s[1]>=1;    
    }

    {int} activeNOR={i | i in NOR : s[i]==1};

    execute
    {
    writeln("Active NOR = ",activeNOR);
    }

