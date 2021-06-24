$fn = 32;

jars_deep = 7;
jars_wide = 6;

jar_dia = 1.85;
jar_clearance = 0.035;
jar_clearance_dia = jar_dia + jar_clearance;
jar_height = 4.135;
jar_lid_dia = 1.96;
jar_lid_height = 0.485;
plastic_thickness = 0.177;

wall_spacing = jar_clearance_dia + plastic_thickness;

side_height = 1.375;

*projection()
    translate([0,0,plastic_thickness])
        rotate([270,0,0]) 
            latitude_panel(jars_deep, endcap=true);

*projection()
    translate([0,0,plastic_thickness])
        rotate([270,0,0]) 
            latitude_panel(jars_deep, endcap=false);

*projection()
  translate([0,0,plastic_thickness])
    rotate([0,270,270]) 
        longitude_panel(jars_deep);


color("red") {
    longitude_panel(jars_deep);
    translate([wall_spacing * jars_wide, 0, 0]) longitude_panel(jars_deep);
}
color("green") {
    latitude_panel(jars_wide, endcap=true);
    for (i = [1:jars_deep-1]) {
        translate([0, wall_spacing * i, 0]) latitude_panel(jars_wide);
    }
    translate([0, wall_spacing * jars_deep, 0]) latitude_panel(jars_wide, endcap=true);
}

color("blue") {
    for (i = [1:jars_wide-1]) {
        rotate([0, 180, -90])
            translate([0, wall_spacing*i, -side_height]) 
                latitude_panel(jars_deep, endcap=false);
    }
}

color("grey") {
    for(i=[0:jars_deep-1]) {
        for(j=[0:jars_wide-1]) {
            translate([
                (jar_clearance_dia/2)+(jar_clearance_dia*j)+(plastic_thickness*(j+1)),
                (jar_clearance_dia/2)+(jar_clearance_dia*i)+(plastic_thickness*(i+1)),
                0
            ]) spice_jar();
        }
    }
}

module longitude_panel(num_jars) {
    longitude_depth = num_jars * jar_clearance_dia + (plastic_thickness * (jars_deep - 1)) + (plastic_thickness * 2);
    difference() {
        cube([plastic_thickness, longitude_depth, side_height]);
        translate([-plastic_thickness, -plastic_thickness, (side_height/4)]) {
            cube([plastic_thickness*3, plastic_thickness*2, side_height/2]);
        }
        for(i = [1:num_jars-1]) {
            translate([-plastic_thickness, wall_spacing * i, (side_height/4)]) {
                cube([plastic_thickness*3, plastic_thickness, side_height/2]);
            }
        }
        translate([-plastic_thickness, wall_spacing * num_jars, (side_height/4)]) {
            cube([plastic_thickness*3, plastic_thickness*2, side_height/2]);
        }

    }
}

module latitude_panel(num_jars, endcap=false) {
    latitude_width = (num_jars * jar_clearance_dia) + (plastic_thickness * (num_jars-1));
    difference() {
        union() {
            translate([plastic_thickness, 0, 0]) 
                cube([latitude_width, plastic_thickness, side_height]);
            translate([0, 0, (side_height/4)])
                cube([plastic_thickness, plastic_thickness, side_height/2]);
            translate([latitude_width+plastic_thickness, 0, (side_height/4)])
                cube([plastic_thickness, plastic_thickness, side_height/2]);
        }
        
        for(i = [1:num_jars-1]) {
            translate([wall_spacing*i, -plastic_thickness, (endcap ? side_height / 4 : side_height / 2)])
                cube([plastic_thickness, plastic_thickness*3, (endcap ? side_height / 2 : side_height)]);
        }
    }
}


module spice_jar() {
    cylinder(h=jar_height, d=jar_dia, center=false);
    translate([0, 0, jar_height-jar_lid_height]) cylinder(h=jar_lid_height, d=jar_lid_dia, center=false);
}