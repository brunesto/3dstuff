


roundedsquaretube(20,10,2,1,3,fill=false);
// params:
// width
// length
// thickness of wall
// height
// radius of rounded corner

module roundedsquaretube(w,l,h,t,r,fill=false){

  
  roundedcorner(r,h,t,fill=fill);
    
  translate([w,0,0]) mirror([1,0,0]) roundedcorner(r,h,t,fill=fill);
    
  translate([0,l,0]) mirror([0,1,0]) roundedcorner(r,h,t,fill=fill);
  translate([w,l,0]) mirror([1,1,0]) roundedcorner(r,h,t,fill=fill);
    
  if (fill){
    translate([r,0,0]) cube([w-r-r,l,h]);
    translate([0,r,0]) cube([w,l-r-r,h]);
  } else {
    translate([0,r,0]) cube([t,l-r-r,h]);
    translate([w-t,r,0]) cube([t,l-r-r,h]);
    translate([r,0,0]) cube([w-r-r,t,h]);
    translate([r,l-t,0]) cube([w-r-r,t,h]);
  }
}

module roundedcorner(r,h,t,fill=false){
  intersection(){
    cube([r,r,h]);
    translate([r,r,0]){
      difference(){
        cylinder(d=r+r,h=h,$fn=24);
        if (!fill)
            translate([0,0,-1]) cylinder(d=r+r-t-t,h=h+2,$fn=24);
      }
    }
  }
}