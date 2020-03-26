use <lego-lib.scad>;

// creates a washer 
// h:height
// h: hole type (bar or round)
module washer(h,hole,support=false){
  difference(){
    if (h>1) {
      cylinder(d=6.4,h=h,$fn=36);    
      cylinder(d=7.4,h=1,$fn=36);
      translate([0,0,h-1]) cylinder(d=7.4,h=1,$fn=36);    
   } else {
      cylinder(d=7.4,h=h,$fn=36);
   }
        
        
   translate([0,0,-1]){
     if (hole=="round")
       cylinder(d=5.2,h=h+2,$fn=36);
     if (hole=="bar")
        bar_hole(h+2);
    }
  }
    
  if (support){
    translate([-5,3,0])
      cube([10,2,0.2]);
    translate([-5,-5,0])
      cube([10,2,0.2]);
  }
}


// not very useful...
module washer_set(hole){
  washer(4*1.9,hole=hole);
  translate([8,0,0])
  washer(3*1.9,hole=hole);
  translate([16,0,0])
  washer(2*1.9,hole=hole);
  translate([24,0,0])
  washer(1*1.9,hole=hole);
}
washer(h=4,hole="bar");
translate([0,8,0])washer_set("round");