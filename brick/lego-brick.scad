// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick


//brick_h=9.7;

// wall thickness
 t=0.5;
 
// base top thickness 
 bt=0.4;


// -- helpers ----------------------------------------------------------
// rounded cylinder
module rounded_cylinder(d,h,rt,rb,fn){
    cylinder(d2=d,d1=d-rb,h=rb,$fn=fn);
    translate([0,0,rb])
    cylinder(d=d,h=h-rb-rt,$fn=fn);
    translate([0,0,h-rt])
    cylinder(d1=d,d2=d-rt,h=rt,$fn=fn);    
}

//rounded_cylinder(d=10,h=20,radius=2);

// rounded cube --
// original idea:
// https://stackoverflow.com/questions/33146741/way-to-round-edges-of-objects-openscad


module neg_round_edge(height,radius){
    difference(){
        translate([-.5,-.5,0])
        cube([radius+.5,radius+.5,height]);

        translate([radius,radius,height/2+1])
        cylinder(height+3,radius,radius,true);
    }
}


module neg_round_edges(xx,yy,zz,radius,cf=[1,1,1,1]){
  if(cf[0]>0) 
    neg_round_edge(zz,cf[0]*radius);  
  if(cf[1]>0) 
    translate([xx,0,0])  
    rotate([0,0,90])
    neg_round_edge(zz,cf[1]*radius);  
  if(cf[2]>0) 
     translate([xx,yy,0])  
     rotate([0,0,180])
     neg_round_edge(zz,cf[2]*radius);  
  if(cf[3]>0) 
     translate([0,yy,0])  
     rotate([0,0,270])
     neg_round_edge(zz,cf[3]*radius);  
    
}

module neg_roundedcube(xx, yy, zz, radius,top=true,bottom=true,x=[1,1,1,1],y=[1,1,1,1],z=[1,1,1,1]) {
neg_round_edges(xx,yy,zz,radius,x);
    translate([0,yy,0])
    rotate([90,0,0])
    neg_round_edges(xx,zz,yy,radius,y);
    
    
    translate([0,0,zz])
    rotate([0,90,0])
    neg_round_edges(zz,yy,xx,radius,x);
    
    
}



module roundedcube(xx, yy, zz, radius,x=[1,1,1,1],y=[1,1,1,1],z=[1,1,1,1]) {
    difference(){
        cube([xx,yy,zz]);
        neg_roundedcube(xx,yy,zz,radius,x,y,z);
    }

}

//roundedcube(20,40,60,5);

// -- end of helpers ----------------------------------------------------------


module base2(xmax,ymax,brick_h){
   
    x=xmax*8-0.2;
    y=ymax*8-0.2;
    h=brick_h;
    r=0.2;
     difference(){    
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
      translate([0,0,-t])
base_stud_holes();    
 }
    
    
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
    

    

module studs(xmax,ymax){
        
// studs    
//translate([0,0,1])
for(x=[0:1:xmax-1])
    for(y=[0:1:ymax-1])
        translate([x*8,y*8,0])
        difference(){
        rounded_cylinder(d=4.8,fn=36,h=1.7,rt=0.2,rb=0);
        cylinder(d=3,$fn=36,h=0.7);
        }
}




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

module under_tubes_tubes(xmax,ymax,brick_h){
for(x=[0:1:xmax])
    for(y=[0:1:ymax])
        translate([x*8-8/2,y*8-8/2,-brick_h])
        rounded_cylinder(d=6.51,fn=36,h=brick_h,rb=0,rt=0);

}


module under_tubes_hollow(xmax,ymax,brick_h){

for(x=[0:1:xmax])
    for(y=[0:1:ymax])
        translate([x*8-8/2,y*8-8/2,-brick_h])
        cylinder(d=6.51-t*2,$fn=36,h=brick_h-1);
}
module under_tubes(xmax,ymax,brick_h){
    
x=xmax*8-0.2;
    y=ymax*8-0.2;
    
    m=0.5;
   
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
    
module brick(xmax,ymax,brick_h,studs=true){
under_tubes(xmax,ymax,brick_h);
under_rails(xmax,ymax,brick_h);
    if (studs)
studs(xmax,ymax);
base2(xmax,ymax,brick_h);
}


//base();
//base2();


STANDARD_H=9.7;
PLATE_H=3.1;

brick(4,2,PLATE_H,studs=false);


//roundedcube(10,20,30,3);