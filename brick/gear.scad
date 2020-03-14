
module bar_hole(l){
  t=1.8+0.4;
  d=4.7+0.4;   
  rotate([90,0,0])
  translate([-t/2,-d/2,0])
  union(){
  cube([t,d,l]);
  translate([+t/2-d/2,-t/2+d/2])
  cube([d,t,l]);
}
}



module gear(){
//    color("blue")
//translate([-150,16,90])
//rotate([90,0,0])
//import("/home/bc/Downloads/New Model.stl");

// used in differences
epsilon=1;

d=34;
h=3.5;
    
 // center hole   
difference(){    
  cylinder(d=8,h=h,$fn=36); 
  translate([0,0,h]) rotate([90,0,0])    bar_hole(h);
}

// gear crown
difference(){    
  cylinder(d=d,h=h,$fn=36); 
  cylinder(d=d-2,h=h,$fn=36); 
  // cylinder(d=8,h=h,$fn=36);  // for round
}

// mantisse
translate([0,0,0])
difference(){    
  cylinder(d=d,h=3.5,$fn=36); 
 
  for(x=[floor(-d/16)+2:floor(d/16)-1])  
      for(y=[floor(-d/16)+2:floor(d/16)-1])
          translate([x*8,y*8,0])
          cylinder(d=5,h=20,$fn=36); 
}

    
  //union(){
//    translate([0,0,h]) rotate([90,0,0])    bar_hole(h);
    
    //translate([10,0,0])  
       //cylinder(d=5,h=h,$fn=36); 
//}
//}


for(a=[0:360/16:360])
rotate([0,0,a])

translate([22,0,0])
union(){
rotate([0,0,90])
tooth(h);
}

}

module tooth(h){
linear_extrude(height=h)
 polygon( points=[[0,0],[1,0],[2,3],[2,6],[-2,6],[-2,3],[-1,0]] );
}

gear();