// modules not related to bricks

// --  rounded cylinder ---------------------------------------------------------------------------------------

// produces a cylinder in 3 sections
// d: base diameter
// h: total height
// rt: top section height
// rtw: top section diameter difference
// rb: bottom section height
// rbw: bottom section diameter difference
module rounded_cylinder(d,h,rt,rtw,rb,rbw,fn=36){
    cylinder(d2=d,d1=d-rbw,h=rb,$fn=fn);
    translate([0,0,rb])
    cylinder(d=d,h=h-rb-rt,$fn=fn);
    translate([0,0,h-rt])
    cylinder(d1=d,d2=d-rtw,h=rt,$fn=fn);    
}


// -- roundedcube ----------------------------------------------------------------------------------------------



// rounded cube --
// original idea:
// https://stackoverflow.com/questions/33146741/way-to-round-edges-of-objects-openscad


module __neg_round_edge(height,radius,fn=36){
  difference(){
    translate([-.5,-.5,0])
      cube([radius+.5,radius+.5,height]);
      translate([radius,radius,height/2+1]) cylinder(height+3,radius,radius,true,$fn=fn);
   }
}


module __neg_round_edges(xx,yy,zz,radius,cf=[1,1,1,1]){
  if (cf[0]>0) 
    __neg_round_edge(zz,cf[0]*radius);  
  if (cf[1]>0) 
    translate([xx,0,0]) rotate([0,0,90]) __neg_round_edge(zz,cf[1]*radius);  
  if (cf[2]>0) 
     translate([xx,yy,0]) rotate([0,0,180]) __neg_round_edge(zz,cf[2]*radius);  
  if (cf[3]>0) 
     translate([0,yy,0]) rotate([0,0,270]) __neg_round_edge(zz,cf[3]*radius);      
}

module __neg_rounded_cube(xx, yy, zz, radius,top=true,bottom=true,x=[1,1,1,1],y=[1,1,1,1],z=[1,1,1,1]) {
     __neg_round_edges(xx,yy,zz,radius,x);
    translate([0,yy,0]) rotate([90,0,0]) __neg_round_edges(xx,zz,yy,radius,y);
    translate([0,0,zz]) rotate([0,90,0]) __neg_round_edges(zz,yy,xx,radius,x);
}



// produces a cube with round corners
// xx:width
// yy:length
// zz:depth
// radius: radius of the corners
// z,y,z: allow to turn off rounding for some specific corners TODO remove
module rounded_cube(xx, yy, zz, radius,x=[1,1,1,1],y=[1,1,1,1],z=[1,1,1,1]) {
  difference(){
    cube([xx,yy,zz]);
    __neg_rounded_cube(xx,yy,zz,radius,x,y,z);
  }
}



// -- rounded_square_tube -----------------------------------------------------------------------------------

// produces a vertical square tube with rounded corners
// params:
// w:width
// l:length
// h:height
// t:thickness of wall
// r:radius of rounded corner
// fill: whether it is empty or not

module rounded_square_tube(w,l,h,t,r,fill=false){

  
  __roundedcorner(r,h,t,fill=fill);
    
  translate([w,0,0]) mirror([1,0,0]) __roundedcorner(r,h,t,fill=fill);
    
  translate([0,l,0]) mirror([0,1,0]) __roundedcorner(r,h,t,fill=fill);
  translate([w,l,0]) mirror([1,1,0]) __roundedcorner(r,h,t,fill=fill);
    
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

// just a single rounded corner
// r: radiuse
// h:height
// t:thickness
// fill: if true t is ignored and the inner part of the curve is filled
module __roundedcorner(r,h,t,fill=false){

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


// tests
translate([0,0,0]) rounded_cylinder(d=10,h=20,rt=10,rtw=5,rb=2,rbw=2);
translate([10,0,0]) rounded_cube(xx=5,yy=10,zz=20,radius=1);
translate([20,0,0])  rounded_square_tube(20,10,2,1,3,fill=false);
