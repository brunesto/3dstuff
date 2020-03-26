// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick

use <base3.scad>;


e=1; // epsilon
/*
 batch  param
 1  tdg=0.3
 2  tdg=0.2
 3  tdg=0.1

*/
//brick_h=9.7;

// wall thickness
 t=0.5;
 
// base top thickness 
 bt=0.4;


// under tube diameter . higher value == tighter grip
tdg=0.1;
td=6.51-tdg;//6.51;


// base round corner radius
basercr=1;

// x,y, lowth: dimensions in mm
// lowts transitions steps
// dx and dy : total difference in x and y after transition
// t: thickness
module base3transition(x,y,lowth,lowts,dx,dy,t,fill){
     for(by=[0:lowth/lowts:lowth])
            translate([by*(dx/lowth)/2,by*(dy/lowth)/2,lowth-by])
            rounded_square_tube(w=x-by*(dx/lowth),l=y-by*(dy/lowth),h=lowth/lowts,t=t,r=basercr,fill=fill);   
        
}
module base3body(xmax,ymax,brick_h,fill){
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
     base3transition(x,y,lowth,lowts,lowtw,lowtw,t,fill);
     
      
    }
}
module base3(xmax,ymax,brick_h){
    
    // walls
    base3body(xmax,ymax,brick_h,fill=false);
    
    x=xmax*8-0.2;
    y=ymax*8-0.2;
    h=brick_h;
    r=0.2;

  
     translate([-3.9,-4+0.1,-bt]){
     // base top    
   // translate([0,0,-bt])
         
         for(by=[0:bt/4:bt])
            translate([by/2,by/2,by])
           rounded_square_tube(w=x-by,l=y-by,h=bt/4,t=t,r=basercr,fill=true);
    //roundedcube(x,y,bt,r);
     }
 
}
/*
module base2(xmax,ymax,brick_h){
   
    x=xmax*8-0.2;
    y=ymax*8-0.2;
    h=brick_h;
    r=0.2;
    // difference(){    
    translate([-3.9,-4+0.1,-h]){
        
    // walls    
    roundedcube(x,t,h,r);
        //cube([x,t,h]);
    translate([0,y-t,0])
    roundedcube(x,t,h,r);
    roundedcube(t,y,h,r);
    translate([x-t,0])
    roundedcube(t,y,h,r);
    
    
    // base top    
    translate([0,0,h-bt])
    roundedcube(x,y,bt,r);
      
   }
      //translate([0,0,-t])
//base_stud_holes();    
 //}
    
    
}
module base(xmax,ymax){


  // plate
  difference(){
    translate([-(8-0.2)/2,-(8-0.2)/2,-brick_h])
    difference(){

     // cube([xmax*8-0.2,ymax*8-0.2,brick_h]);
      roundedcube(xmax*8-0.2,ymax*8-0.2,brick_h,0.5);
    
      translate([1.2,1.2,-1])
      cube([xmax*8-0.2-1.2*2,ymax*8-0.2-1.2*2,brick_h]);
    }
base_stud_holes(xmax,ymax);    
}


  
}
*/

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
    
module stud(sh){
    difference(){
            
    union(){
        rounded_cylinder(d=4.8,fn=36,h=sh,rt=0.2,rtw=0.2,rb=0,rbw=0);
          translate([0,0,sh-0.5-0.2])   cylinder(d=4.8+tdg,$fn=36,h=0.5);
    }
            
             translate([0,0,sh-sh-e])
             cylinder(d=3,$fn=36,h=sh+e+e);
        }
    
}
    

module studs(xmax,ymax){
        
    // stud height
    sh=1.95;
// studs    
//translate([0,0,1])
for(x=[0:1:xmax-1])
    for(y=[0:1:ymax-1])
        translate([x*8,y*8,0]){
            
              //if (ymax==1){
//                if (x==0 && y==0) translate([-0.95,-1,1.6])  scale([0.2,0.2,0.2]) linear_extrude(height=1)   text("B",font = "Liberation Sans:style=Bold");   
                    //if (x==1 && y==0) translate([-0.95,-1,1.6])   scale([0.2,0.2,0.2]) linear_extrude(height=1)   text("C",font = "Liberation Sans:style=Bold");   
                 //} else{
                    //if (x==0 && y==0) translate([-0.95,-1,1.6])  scale([0.2,0.2,0.2]) linear_extrude(height=1)  text("C",font = "Liberation Sans:style=Bold");                   
                     //if (x==0 && y==1) translate([-0.95,-1,1.6]) scale([0.2,0.2,0.2]) linear_extrude(height=1)  text("B",font = "Liberation Sans:style=Bold");   
                //}
                    
        stud(sh);
        }
}


// -- under_tubes -----------------------------------------------------------------------------------

module under_tubes_skin(xmax,ymax,brick_h){    
  skin_t=t;
  
  depth=brick_h-0;  
    
  if (depth>0){  
    
  for(y=[1:1:ymax-1]){
    translate([-4+t,y*8-8/2-skin_t/2,-depth])
      cube([xmax*8-t*2,skin_t,depth]);
  }
  
  for(x=[1:1:xmax-1]){
    translate([x*8-8/2-skin_t/2,-4+t,-depth])
      cube([skin_t,ymax*8-t*2,depth]);
  }
  }

}

//module under_tubes_tube(d,h){
        //rounded_cylinder(d=d,fn=36,h=h,rb=1,rbw=-0.2,rt=0,rtw=0);
//}

module under_tubes_tubes(xmax,ymax,brick_h){
for(x=[0:1:xmax])
    for(y=[0:1:ymax])
        translate([x*8-8/2,y*8-8/2,-brick_h]){

        cylinder(d=td,$fn=36,h=brick_h);
        cylinder(d=td+tdg,$fn=36,h=0.3);
        }
  //  under_tubes_tube(d=td,h=brick_h);
}


module under_tubes_hollow(xmax,ymax,brick_h){

for(x=[0:1:xmax])
    for(y=[0:1:ymax])
        translate([x*8-8/2,y*8-8/2,-brick_h-1])
        cylinder(d=td-t*2,$fn=36,h=brick_h+2);        
}
module under_tubes(xmax,ymax,brick_h){
    
x=xmax*8-0.2;
    y=ymax*8-0.2;
    
    m=0.25;
   
intersection(){
  
    translate([-3.9+m,-4+0.1+m,-brick_h])
     cube([x-2*m,y-2*m,brick_h]);
    
    difference(){
    union(){

under_tubes_tubes(xmax,ymax,brick_h);
under_tubes_skin(xmax,ymax,brick_h);

}
under_tubes_hollow(xmax,ymax,brick_h);
}
}
  
}
    


/*
module under_rails(xmax,ymax,brick_h){    
    
    rt=0.4;
    rd=0.4;
    
for(x=[0:1:xmax-1]){    
    translate([x*8-rt/2,0*8-4+t,-brick_h])
    cube([rt,rd,brick_h]);
    translate([x*8-rt/2,(ymax-1)*8+4-t-rd,-brick_h])
    cube([rt,rd,brick_h]);
}
    


for(y=[0:1:ymax-1]){    
    translate([0*8-4+t,y*8-rt/4,-brick_h])
    cube([rd,rt,brick_h]);
    translate([(xmax-1)*8+4-t-rd,y*8-rt/4,-brick_h])
    cube([rd,rt,brick_h]);
}
}
*/  
  
module brick(xmax,ymax,brick_h,studs=true,holes=false,support=false){
    hd=5.1;
   difference(){ 
       union(){
  
  //under_rails(xmax,ymax,brick_h);
  if (studs)
    studs(xmax,ymax);
  
  intersection(){
  base3body(xmax,ymax,brick_h,fill=true);
  under_tubes(xmax,ymax,brick_h);
 }
  base3(xmax,ymax,brick_h);
      if (holes!=false) { 
  for(y=[0:1:ymax-2]){    
    translate([-4+0.1,y*8+4,-4]) rotate([0,90,0]) cylinder(d=hd+t*2,h=xmax*8-0.2,$fn=36);
  }
  }
  }
  for(y=[0:1:ymax-2]){    
    translate([-4,y*8+4,-4]) 
  if (holes=="round") {    
      rotate([0,90,0]) cylinder(d=hd,h=xmax*8,$fn=36);
      // transform the hole into an oval shape to compensate overhang printing
        translate([0,0,0.5])  rotate([0,90,0]) cylinder(d=hd-0.5,h=xmax*8,$fn=36);
  }
  else if (holes=="bar") { 
     translate([0,0,0])    
     rotate([0,90,90]) 
       rotate([90,0,0]) bar_hole(xmax*8);
  }
  
  }
  }
  
if (support){
   translate([-3,-4+0.3-10,-brick_h]) cube([0.8,10,0.2]);   
   translate([xmax*8-5,-4+0.3-10,-brick_h]) cube([0.8,10,0.2]);
   translate([-3,-4-0.7+0.3+ymax*8,-brick_h]) cube([0.8,10,0.2]);
   translate([xmax*8-5,-4-0.7+0.3+ymax*8,-brick_h]) cube([0.8,10,0.2]);
  
  translate([-3,-4+0.3-10,-brick_h]) cube([xmax*8-1.2,3,0.2]);
  translate([-3,-4-0.7+0.3+ymax*8+10-3,-brick_h]) cube([xmax*8-1.2,3,0.2]);
}

}

//base();
//base2();



module bar(u){
    
    
 l=u*8-1;   
 rotate([90,45,0])
    union(){
 t=1.8-0.4;
 d=4.7-0.2;   
 r=0.5;   
 roundedcube(t,d,l,r);
 translate([+t/2-d/2,-t/2+d/2])
 roundedcube(d,t,l,r);
    
 // support 
    rotate([0,0,45])
        translate([0.8,-0.78,0])
    union(){
    translate([0,0,-5]) cube([0.8,0.2,l+10]);
    translate([2,0,-5]) cube([0.8,0.2,l+10]);
    translate([-4,0,-5]) 
        cube([10,0.2,2]);
    translate([-4,0,l+5]) 
        cube([10,0.2,2]);    
    }
}
}//bar(48.4);



 //neg_round_edge(10,5);
//rotate([90,45,0])
//bar(16);
//



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




module washer(h,hole,support=false){
    difference(){
      
            if (h>1) {
    cylinder(d=6.4,h=h,$fn=36);    
    cylinder(d=7.4,h=1,$fn=36);
              translate([0,0,h-1])
             cylinder(d=7.4,h=1,$fn=36);    
        } else {
            cylinder(d=7.4,h=h,$fn=36);
        }
        
        
          translate([0,0,-1])
        if (hole=="round")
        cylinder(d=5.2,h=h+2,$fn=36);
        if (hole=="bar")
        bar_hole(h+2);
    }
    
    if (support){
    translate([-5,3,0])
      cube([10,2,0.2]);
      translate([-5,-5,0])
      cube([10,2,0.2]);
    }
}


// not very useful...
module washerSet(hole){
washer(4*1.9,hole=hole);
translate([8,0,0])
washer(3*1.9,hole=hole);
translate([16,0,0])
washer(2*1.9,hole=hole);
translate([24,0,0])
washer(1*1.9,hole=hole);
}
//washer(h=1,hole="bar");
//translate([0,8,0])washerSet("round");

//stud(10);

//under_tubes_tube(d=td,h=10);
STANDARD_H=9.7-0.15-0.3;
PLATE_H=3.1-0.1; // -0.1 is for margin when stacking plates

//for(z=[0.3:0.1:0.8])
        //translate([z*110,0,0])
brick(2,4,STANDARD_H,studs=true,holes=false,support=false);
/*difference(){
   rotate([90,0,0])
cylinder(d=10,h=1);
    translate([0,1,0])
bar_hole(10,z);
}
*/

/*
bar(6);
translate([10,0,0])
bar(6);
translate([20,0,0])
bar(6);
*/