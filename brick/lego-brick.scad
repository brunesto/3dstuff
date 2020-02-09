// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick

xmax=4;
ymax=2;
brick_h=9.7;
 t=1;
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


module neg_round_edges(xx,yy,zz,radius){
  neg_round_edge(zz,radius);  
  translate([xx,0,0])  
  rotate([0,0,90])
  neg_round_edge(zz,radius);  
  translate([xx,yy,0])  
  rotate([0,0,180])
  neg_round_edge(zz,radius);  
  translate([0,yy,0])  
  rotate([0,0,270])
  neg_round_edge(zz,radius);  
    
}

module neg_roundedcube(xx, yy, zz, radius) {
neg_round_edges(xx,yy,zz,radius);
    translate([0,yy,0])
    rotate([90,0,0])
    neg_round_edges(xx,zz,yy,radius);
    
    
    translate([0,0,zz])
    rotate([0,90,0])
    neg_round_edges(zz,yy,xx,radius);
    
    
}



module roundedcube(xx, yy, zz, radius) {
    difference(){
        cube([xx,yy,zz]);
        neg_roundedcube(xx,yy,zz,radius);
    }

}

//roundedcube(20,40,60,5);


// end of rounded cube


module base2(){
   
    x=xmax*8-0.2;
    y=ymax*8-0.2;
    h=brick_h;
    r=0.4;
     difference(){    
    translate([-3.9,-4+0.1,-h]){
        
        
    roundedcube(x,1,h,r);
    translate([0,y-t,0])
    roundedcube(x,1,h,r);
    roundedcube(1,y,h,r);
    translate([x-t,0])
    roundedcube(1,y,h,r);
        
    translate([0,0,h-t])
    roundedcube(x,y,1,r);
      
    }
      translate([0,0,-t])
base_stud_holes();    
 }
    
    
}
module base(){


  // plate
  difference(){
    translate([-(8-0.2)/2,-(8-0.2)/2,-brick_h])
    difference(){

     // cube([xmax*8-0.2,ymax*8-0.2,brick_h]);
      roundedcube(xmax*8-0.2,ymax*8-0.2,brick_h,0.5);
    
      translate([1.2,1.2,-1])
      cube([xmax*8-0.2-1.2*2,ymax*8-0.2-1.2*2,brick_h]);
    }
base_stud_holes();    
}


  
}

module base_stud_holes(){
    // studs    
//translate([0,0,1])
  for(x=[0:1:xmax-1])
    for(y=[0:1:ymax-1])
      translate([x*8,y*8,-2])
      cylinder(d=3,$fn=36,h=8);

}

 


//studs();
//base();
    

    

module studs(){
        
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




module under_tubes_skin(){    
  skin_t=0.5;
  for(y=[2:4:ymax-1]){
    translate([-4+t,y*8-8/2-skin_t/2,-7])
      cube([xmax*8-t*2,skin_t,7]);
  }
  
  for(x=[2:4:xmax-1]){
    translate([x*8-8/2-skin_t/2,-4+t,-7])
      cube([skin_t,ymax*8-t*2,7]);
  }

}

module under_tubes_tubes(){
for(x=[1:1:xmax-1])
    for(y=[1:1:ymax-1])
        translate([x*8-8/2,y*8-8/2,-brick_h])
        rounded_cylinder(d=6.51,fn=36,h=brick_h,rb=0.5,rt=0);

}


module under_tubes_hollow(){

for(x=[1:1:xmax-1])
    for(y=[1:1:ymax-1])
        translate([x*8-8/2,y*8-8/2,-brick_h])
        cylinder(d=6.51-t,$fn=36,h=brick_h-1);
}
module under_tubes(){
    

    difference(){
    union(){

under_tubes_tubes();
under_tubes_skin();

}
under_tubes_hollow();
}
}
    



module under_rails(){    
    
    rw=0.4;
    rd=0.4;
    
for(x=[0:1:xmax-1]){    
    translate([x*8-rw/2,0*8-4+t,-brick_h])
    cube([rw,rd,brick_h]);
    translate([x*8-rw/2,(ymax-1)*8+4-t-rd,-brick_h])
    cube([rw,rd,brick_h]);
}
    


for(y=[0:1:ymax-1]){    
    translate([0*8-4+t,y*8-rw/4,-brick_h])
    cube([rd,rw,brick_h]);
    translate([(xmax-1)*8+4-t-rd,y*8-rw/4,-brick_h])
    cube([rd,rw,brick_h]);
}
}
    
module brick(){
under_tubes();
under_rails();
studs();
base2();
}


//base();
//base2();
brick();