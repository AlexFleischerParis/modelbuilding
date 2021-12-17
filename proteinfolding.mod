// Protein folding : Problem 28 in H.P. Williams Model Building
// https://www.amazon.fr/Model-Building-Mathematical-Programming-Williams/dp/1118443330?cm_mc_uid=56329990040415039023459&cm_mc_sid_50200000=1507305800&cm_mc_sid_52640000=


{int} hydrophobic={
2,4,5,6,11,12,17,20,21, 
25,27,28,30,31,33,37,44 ,46};

tuple t
{
  int i;
  int j;
}

{t} pairs={<i,j> | ordered i,j in hydrophobic};

int nbacids=50;
range acids=1..nbacids;

// hydrophobic acid i is matched with acid j
dvar boolean extramatch[pairs];
// a fold occurs between the i th and (i +1)st acids in the chain.
dvar boolean fold[acids];

maximize sum(p in pairs) extramatch[p];

subject to
{
  
  // extramatch[<33,44>]==0; // to get the HP Williams solution

forall(i,j in hydrophobic,k in acids:(i<=k<j) && (<i,j> in pairs) && (k!=(i+j-1)/2))
   extramatch[<i,j>]+fold[k]<=1;
forall(<i,j> in pairs:(i+j) mod 2 ==1) 
   extramatch[<i,j>]==fold[(i+j-1) div 2];
forall(<i,j> in pairs:(i+j) mod 2 ==0) 
   extramatch[<i,j>]==0;

}

execute display
{
  
  var xmove=0;
  var s="";
  
  var oddline=1;
  for(var i in acids)
  {
    if (oddline==1)
    {
      if (hydrophobic.contains(i)) s=s+"X";
      else s=s+"-";
      
    } 
    else
    {
      if (hydrophobic.contains(i)) s="X"+s;
      else s="-"+s;
     
    }     
    
    if ((fold[i]==1) || (i==nbacids))
    {
      if (oddline==1)
      {
        for(var j=1;j<=20+xmove;j++) write(" ");
      }
      else
      {
        for(var j=1;j<=20+xmove-s.length;j++) write(" ");
      }
      writeln(s);
      
      if (oddline==1) xmove+=s.length;
      else xmove-=s.length;
     
      s="";
      oddline=1-oddline;
    }    
   }
     
}  
  
  

{t} extramatches={i | i in pairs:extramatch[i]==1};

execute
{
  writeln();
  writeln("extra matches = ",extramatches);
}

/*

// solution (optimal) with objective 8
                    -X-
                  --XXX
                  --XX----X--XX-
                -X---X-XX-XX-X--
                -----X-X----

extra matches =  {<2 5> <5 12> <6 11> <12 33> <17 28> <20 25> <31 46> <33 44>}


*/