use <lib.scad>;

// create a bar
// u: units 
module bar(u){
    
    
 l=u*8-1;   
 rotate([90,45,0])
    union(){
 t=1.8-0.4;
 d=4.7-0.2;   
 r=0.5;   
 rounded_cube(t,d,l,r);
 translate([+t/2-d/2,-t/2+d/2])
 rounded_cube(d,t,l,r);
    
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
}

// --  test --
bar(6);
translate([10,0,0])
bar(6);
translate([20,0,0])
bar(6);
