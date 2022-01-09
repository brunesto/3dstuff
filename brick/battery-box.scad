use <../3dstuff/brick/lib.scad>;
use <../3dstuff/brick/lego-brick.scad>;

/*
module holder(){
e=1;
bt=1;

t=1;
sw=24;
id=25;
difference(){
    union(){
cylinder(d=id+t,h=20+t);
        
        translate([id/2,-sw/2,-4])  cube([bt,sw,id]);
        translate([0,-sw/2,-0])
        
 cube([13,sw,20+t]);
   
        }
    union(){
   
        translate([0,0,-e]) {
          cylinder(d=7,h=20+e+e+t,$fn=36);
        cylinder(d=id,h=19+e+t);    
        }
  
        
        for(a=[0:60:360])
            rotate([0,0,a])
        translate([0,8,0]) cylinder(d=2,h=20+e+e+t,$fn=36);
        
    }
    
}
}
*/

STANDARD_H=9.7-0.15-0.3+0.1;// +0.1 added AFTER 3.1
PLATE_H=3.1-0.1; // -0.1 is for margin when stacking plates

//rotate([0,270,0])
//translate([4-4,-8,-10-1])

brick(3,3,PLATE_H,studs=false,holes=false,support=false);

xmax=3;
ymax=3;

 x=xmax*8-0.2;
 y=ymax*8-0.2;
 h=brick_h;
 r=0.2;
 t=1;
 
 rounded_square_tube(w=x,l=y,h=brick_h-lowth-bt,t=t,r=basercr,fill=fill);
 
  



