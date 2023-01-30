$fn = 64;

sizes = [7.5, 22.6, 34, 45.5, 57.2];

for(i = [0 : len(sizes) - 1]) translate([i * 20, 0]) {
	difference() {
//		cylinder(h = sizes[i], d = 5);
		cylinder(h = 3.5, d = 5);
		translate([0, 0, -.01]) cylinder(h = 2.5, d = 3.75);
	}
	
	translate([0, 0, sizes[i] - 5]) cylinder(h = 5, d1 = 2.7, d2 = 4);
	
	translate([0, 0, 3.5]) cylinder(h = sizes[i] + 3.5, d = 2.7);
}

//translate([0, 0, 3.5]) cylinder(h = 59 + 1.5, d = 2.8);
//translate([0, 0, 3.5]) cylinder(h = 35.4 + 1.5, d = 2.8);
