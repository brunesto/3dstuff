use <lib.scad>;

// modules used by other pieces

module bar_hole(l){
  t=1.8+0.3;
  d=4.7+0.3;   

  translate([-t/2,-d/2,0])
  union(){
  cube([t,d,l]);
  translate([+t/2-d/2,-t/2+d/2])
  cube([d,t,l]);
}
}


bar_hole(2);