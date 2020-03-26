use <lego-brick.scad>;


function t2d(t) =
  ((12.8/16)/PI)*PI*t;



module gear(t=16,h=3.5,asw=0.2,mh=false,hole="cross"){
    
    d=t2d(t);
    gearbase(d=d,h=h,asw=asw,mh=mh,hole=hole);
    s=d/2+2;
//s=(((3+8.8)/16)/PI)*PI*t;
//s=2+8.8;
for(a=[0:360/t:360])
rotate([0,0,a])
translate([s,0,0])
union(){
rotate([0,0,90])
tooth(h,asw);
}

}
// d: diameter
// h: height
// asw:
// mh: mantisse holes
// mt: mantisse thickness
// hole: center hole type (false,"round","cross")
// gcd: gear crown diameter
module gearbase(d,h=3.5,asw=0.2,mt=2,mh=false,hole="cross",gcd=3){
    /*scale(1/2.5)
    color("blue")
translate([-150,16,90])
rotate([90,0,0])
import("/home/bc/Downloads/New Model.stl");
*/
// used in differences
epsilon=1;

//d=12.8*16/PI

//d=t/4*2.5132741228720;
//d=t2d(t);
//h=3.5;


    
 
difference(){    
  union(){
      
dc=0.5;
// gear crown
difference(){    
  cylinder(d=d-dc,h=h,$fn=360); 
  translate([0,0,-1])
   
    cylinder(d=d-gcd,h=h+2,$fn=36); 

}

// mantisse
translate([0,0,0])
difference(){    
  cylinder(d=d-dc,h=min(h,mt),$fn=36); 
  
   if (mh) {
  for(x=[floor(-d/16)+1:floor(d/16)])  
      for(y=[floor(-d/16)+1:floor(d/16)])
          translate([x*8,y*8,-1])
          cylinder(d=5.1,h=20,$fn=36); 
  }
  
}
      
      
      
  cylinder(d=8,h=h,$fn=36);  // around bar hole
  }
  
  // center hole   
  
 
   if (hole=="cross") 
    translate([0,0,h+1]) rotate([90,0,0])     rotate([90,0,0])    bar_hole(h+2);
   else 
     translate([0,0,-1])  cylinder(d=5.2,h=h+2,$fn=36);  // for round
   

}



    
  //union(){
//    translate([0,0,h]) rotate([90,0,0])    bar_hole(h);
    
    //translate([10,0,0])  
       //cylinder(d=5,h=h,$fn=36); 
//}
//}

}

module tooth(h,asw=0.2){
    // scale
    s=2.5;
    // extra base
    eb=1/s;
    // abs shrink width for printing
    d=asw/s;
linear_extrude(height=h)
 polygon( points=[[0.5/s-d,0],[1/s-d,0.2],[2/s-d,3/s],[2/s-d,eb+5/s],[-2/s+d,eb+5/s],[-2/s+d,3/s],[-1/s+d,0.2],[-0.5/s+d,0]] );
}

//gear(t=12);
//translate([0,20,0])
//gear(t=24);

//gear();
//translate([109,109,0])
//rotate([0,0,0.5])gear(t=360);


STANDARD_H=9.7-0.15;
PLATE_H=3.1;


//translate([-90,-8,10])
//rotate([180,90,90])
//brick(2,2,STANDARD_H,studs=true,holes="bar");


//for(z=[0.1:0.1:0.7])  translate([0,z*175,0]) gear(t=16,h=2,asw=z);



// sandwiched gear
module sgear(t,h,dhb=0,dht=0,mh=false,hole="cross"){

gear(t=t,h=dhb,asw=0.5,mh=mh,hole=hole);
translate([0,0,dhb])
gear(t=t,h=h-dhb-dht,asw=0.5,mh=mh,hole=hole);    
translate([0,0,h-dhb])
gear(t=t,h=dht,asw=0.7,mh=mh,hole=hole);

}




module wheel(d,h=3.5,g=2,hole="cross"){

difference (){    
    gearbase(d,h=h,hole=hole,mt=1,mh=true,gcd=max(g+1.5,3));
    
    //cylinder(d=d,h=10);

rotate_extrude(convexity=10,$fn=24)
  translate([d/2,h/2,0])
    circle(d=g,$fn=100);
}
}


wheel(t2d(32),h=3.5,g=3);
















//sgear(t=24,h=1.7,dhb=0.2,mh=true);
//translate([0,20,0])

//sgear(t=9,h=1.9,dhb=0.2);
/*for (i=[24:36]){
    x=i%4;
    y=floor(i/4);
    translate([x*32,y*30,0])
sgear(t=i,h=0.5,dhb=0.2);
}*/

// 2 gears stuck
/*
sgear(t=38,h=1.9,dhb=0.2,mh=true,hole="round");
sgear(t=16,h=1.9,dhb=0.2,mh=true,hole="round");
translate([0,0,1.9])
sgear(t=16,h=1.9,dhb=0.2,mh=true,hole="round");
*/