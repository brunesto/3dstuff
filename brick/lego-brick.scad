/*
 batch  param
 1  tdg=0.3
 2  tdg=0.2
 3  tdg=0.1

*/


// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick

use <lib.scad>;
use <lego-lib.scad>;


e=1; // epsilon, used only to improve preview

// wall thickness
t=0.5;

// stud height
sh=1.95;

// under skin thickness
skin_t=t;  

 
// base top thickness 
bt=0.4;


// under tube diameter . higher value == tighter grip
tdg=0.1;
td=6.51-tdg;//6.51;


// transversal holes diameter
hd=5.1;

// base round corner radius
basercr=1;

// x,y, lowth: dimensions in mm
// lowts transitions steps
// dx and dy : total difference in x and y after transition
// t: thickness
module __base_transition(x,y,lowth,lowts,dx,dy,t,fill){
     for(by=[0:lowth/lowts:lowth])
            translate([by*(dx/lowth)/2,by*(dy/lowth)/2,lowth-by])
            rounded_square_tube(w=x-by*(dx/lowth),l=y-by*(dy/lowth),h=lowth/lowts,t=t,r=basercr,fill=fill);   
        
}
module __base_body(xmax,ymax,brick_h,fill){
    x=xmax*8-0.2;
    y=ymax*8-0.2;
    h=brick_h;
    r=0.2;

    lowth=0;   
    lowts=2;
    lowtw=0.1;   
    translate([-3.9,-4+0.1,0]){
         translate([0,0,-h+lowth])
     rounded_square_tube(w=x,l=y,h=brick_h-lowth-bt,t=t,r=basercr,fill=fill);
     translate([0,0,-h])
     __base_transition(x,y,lowth,lowts,lowtw,lowtw,t,fill);
     
      
    }
}
module base(xmax,ymax,brick_h){
    
    // walls
    __base_body(xmax,ymax,brick_h,fill=false);
    
    x=xmax*8-0.2;
    y=ymax*8-0.2;
    h=brick_h;
    r=0.2;

  
     translate([-3.9,-4+0.1,-bt]){
     // base top    
   // translate([0,0,-bt])
         
         // base transition
         for(by=[0:bt/4:bt])
            translate([by/2,by/2,by])
           rounded_square_tube(w=x-by,l=y-by,h=bt/4,t=t,r=basercr,fill=true);
    //roundedcube(x,y,bt,r);
     }
 
}

module base_stud_holes(xmax,ymax){
    // studs    
//translate([0,0,1])
  for(x=[0:1:xmax-1])
    for(y=[0:1:ymax-1])
      translate([x*8,y*8,-2])
      cylinder(d=3,$fn=36,h=8);

}

 


//studs();
//base();

// -- studs -----------------------------------------------------------------------------------

// create a single stud
// sh: height in mm
module __stud(sh){
  difference(){
    union(){
      rounded_cylinder(d=4.8,fn=36,h=sh,rt=0.2,rtw=0.2,rb=0,rbw=0);
      translate([0,0,sh-0.5-0.2]) cylinder(d=4.8+tdg,$fn=36,h=0.5);
    }
    translate([0,0,sh-sh-e]) cylinder(d=3,$fn=36,h=sh+e+e);
  }  
}
    
// create a square carpet of studs
// xmax: width in units 
// ymax: lenght in units
module studs(xmax,ymax){
  for(x=[0:1:xmax-1]) for(y=[0:1:ymax-1]) translate([x*8,y*8,0]) __stud(sh);
}


// -- mesh -----------------------------------------------------------------------------------

// create a mesh of skins
// the 'skin' are the thin walls that join the tubes inside the mesh
// xmax: in units
// ymax: in units
// brick_h: height in mm

module __mesh_skin(xmax,ymax,brick_h){    
  
  depth=brick_h-0;      
  if (depth>0){      
    for(y=[1:1:ymax-1])
      translate([-4+t,y*8-8/2-skin_t/2,-depth]) cube([xmax*8-t*2,skin_t,depth]);
    for(x=[1:1:xmax-1])
      translate([x*8-8/2-skin_t/2,-4+t,-depth]) cube([skin_t,ymax*8-t*2,depth]);
  }
}


// create a mesh of full tubes
// xmax: in units
// ymax: in units
// brick_h: height in mm
module __mesh_tubes(xmax,ymax,brick_h){
  for(x=[0:1:xmax])
    for(y=[0:1:ymax])
      translate([x*8-8/2,y*8-8/2,-brick_h]){
        cylinder(d=td,$fn=36,h=brick_h);
        cylinder(d=td+tdg,$fn=36,h=0.3);
      }
}

// create a mesh of full tubes that will be used to hollow the skin+tubes
// xmax: in units
// ymax: in units
// brick_h: height in mm
module __mesh_hollow(xmax,ymax,brick_h){
  for(x=[0:1:xmax])
    for(y=[0:1:ymax])
      translate([x*8-8/2,y*8-8/2,-brick_h-1]) cylinder(d=td-t*2,$fn=36,h=brick_h+2);        
}

// create the mesh - note that it will overflow the size specified, so it need to be intersected
// with the desired internal dimensions
// xmax: in units
// ymax: in units
// brick_h: height in mm
module mesh(xmax,ymax,brick_h){
    
  x=xmax*8-0.2;
  y=ymax*8-0.2;
  m=0.25;
   
  //intersection(){
  //    translate([-3.9+m,-4+0.1+m,-brick_h]) cube([x-2*m,y-2*m,brick_h]);
  difference(){
    union(){
      __mesh_tubes(xmax,ymax,brick_h);
      __mesh_skin(xmax,ymax,brick_h);
    }
    __mesh_hollow(xmax,ymax,brick_h);
  //  }
  }  
}
    


// creates a brick
// xmax: units in width
// ymax: units in lenght
// brick_h: height of the brick in mm
// studs: whether to add studs (set to false for a flat top)
// holes:false/"round"/"bar" add holes 
// support: add thin stripes on the floor to improve adherance

module brick(xmax,ymax,brick_h,studs=true,holes=false,support=false){
  
  difference(){ 
    union(){
        
      //under_rails(xmax,ymax,brick_h);
      if (studs)
        studs(xmax,ymax);
  
      // produce the mesh and limmit it to the brick outside dimensions
      intersection(){
        __base_body(xmax,ymax,brick_h,fill=true);
        mesh(xmax,ymax,brick_h);
      }
      
      // produces the base
      base(xmax,ymax,brick_h);
     
      // if holes are required, put full transversal cylinders 
      // as a mantisse for holes
      if (holes!=false) { 
        for(y=[0:1:ymax-2]){    
            translate([-4+0.1,y*8+4,-4]) rotate([0,90,0]) cylinder(d=hd+t*2,h=xmax*8-0.2,$fn=36);
        }
      }
    }
    // transversal holes
    for(y=[0:1:ymax-2]){    
      translate([-4,y*8+4,-4]) {
        if (holes=="round") {    
          rotate([0,90,0]) cylinder(d=hd,h=xmax*8,$fn=36);
          // transform the hole into an oval shape to compensate overhang printing
          translate([0,0,0.5])  rotate([0,90,0]) cylinder(d=hd-0.5,h=xmax*8,$fn=36);
        } else if (holes=="bar") { 
          rotate([90,90,90]) bar_hole(xmax*8);
        }
      }
    }
  }
  
  // thin stripes on the floor to improve adherence during printing
  if (support){
    translate([-3,-4+0.3-10,-brick_h]) cube([0.8,10,0.2]);   
    translate([xmax*8-5,-4+0.3-10,-brick_h]) cube([0.8,10,0.2]);
    translate([-3,-4-0.7+0.3+ymax*8,-brick_h]) cube([0.8,10,0.2]);
    translate([xmax*8-5,-4-0.7+0.3+ymax*8,-brick_h]) cube([0.8,10,0.2]);  
    translate([-3,-4+0.3-10,-brick_h]) cube([xmax*8-1.2,3,0.2]);
    translate([-3,-4-0.7+0.3+ymax*8+10-3,-brick_h]) cube([xmax*8-1.2,3,0.2]);
  }
}

// --  tests -----------------------------

STANDARD_H=9.7-0.15-0.3;
PLATE_H=3.1-0.1; // -0.1 is for margin when stacking plates

brick(2,4,STANDARD_H,studs=true,holes="round",support=false);

translate([0,100,0]) base(2,4,STANDARD_H);
translate([30,100,0]) mesh(2,4,STANDARD_H);
translate([60,100,0]) studs(2,4);




