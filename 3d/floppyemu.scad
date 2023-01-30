led_w = 40;
led_h = 8;
led_z = 2;

sd_w = 24;
sd_h = 2.8;
sd_d = 32 - 4;
sd_z = 5.7;

sd_stop_d = 1.5;

sd_pin_d = 6;

body_w = 125;
body_d = 96;

pcb_w = 83.0580;
pcb_d = 34.9200;

pcb_off_x = 2;
pcb_off_y = 8.5;

pcb_front_standoff_w = 6.6040;
pcb_back_standoff_x = 11.6000;
pcb_back_standoff_w = 4.0000;

pcb_h1_x = 21.3360;
pcb_h1_y = 3.6360;

pcb_h2_x = pcb_w - 6.6040;
pcb_h2_y = pcb_d - 13.9700;

dpcb_cutout_x = 32;
dpcb_cutout_w = 31;
dpcb_cutout_h = 43;

dpcb_screw_x = 46.5;
dpcb_screw_y = 27;

$fn = 64;

module maincutout() {
	difference() {
		union() {
			translate([2, 2, 1]) cube([body_w - 4, body_d - 4, 12.51]);
			translate([17, -.01, 3]) cube([body_w - 17 - 52, 2.02, 12.51]);
			translate([dpcb_cutout_x + dpcb_cutout_w - .01, -.01, 1]) cube([(body_w - dpcb_cutout_x - dpcb_cutout_w) - 51.99, 2.02, 10]);
		}
		children();
	}
	
/*	difference() {
		for(i = [0 : 10]) hull() {
			translate([10, 8 + i * (body_d - 16) / 10]) cylinder(h = 2.01, d = 5, center = true);
			
			translate([body_w - 8, 8 + i * (body_d - 16) / 10]) cylinder(h = 2.01, d = 5, center = true);
		}
		
		children();
	}*/
}
/*

translate([pcb_off_x, body_d - pcb_off_y - pcb_d, 3.75]) difference() {
	cube([pcb_w, pcb_d, 1.6]);
	translate([pcb_h1_x, pcb_h1_y]) cylinder(d = 3.2, h = 4, center = true);
	translate([pcb_h2_x, pcb_h2_y]) cylinder(d = 3.2, h = 4, center = true);
}
*/

difference() {
	cube([body_w, body_d, 12.5]);
	
	// PCB cutout
	translate([-.01, body_d - pcb_off_y - pcb_d - 2, 2]) cube([2.02, pcb_d + 4, 20]);

	// Daughter PCB cutout (otherwise it wouldn't fit)
	translate([dpcb_cutout_x, -.01, -.01]) cube([dpcb_cutout_w, dpcb_cutout_h, 12.51]);
	
	maincutout() {
		// PCB front standoff
		translate([pcb_off_x, body_d - pcb_off_y - pcb_d]) cube([pcb_front_standoff_w, pcb_d, 7.5 / 2]);

		// PCB back standoff
		translate([pcb_off_x + pcb_w - pcb_back_standoff_x - pcb_back_standoff_w, body_d - pcb_off_y - pcb_d]) cube([pcb_back_standoff_w, pcb_d, 7.5 / 2]);
		
		// PCB screw posts
		translate([pcb_off_x + pcb_h1_x, body_d - pcb_off_y - pcb_d + pcb_h1_y]) cylinder(d1 = 12, d2 = 7, h = 7.5, center = true);
		
		translate([pcb_off_x + pcb_h2_x, body_d - pcb_off_y - pcb_d + pcb_h2_y]) cylinder(d1 = 12, d2 = 7, h = 7.5, center = true);
		
		// Daughter PCB screw post
		translate([body_w - dpcb_screw_x, dpcb_screw_y]) cylinder(d1 = 15, d2 = 7, h = (8 - 1.6) * 2, center = true);
		
		// SD bottom plate
		translate([body_w - sd_d + sd_pin_d, body_d - 2 - sd_w, 0]) cube([sd_d - sd_pin_d, sd_w, sd_z]);
		
		// SD back wall
		translate([body_w - sd_d - sd_stop_d, body_d - 2 - sd_w, 0]) cube([sd_stop_d, sd_w, sd_z + sd_h]);
		
		// SD side wall
		translate([body_w - sd_d + sd_pin_d, body_d - 2 - sd_w - sd_stop_d, 0]) difference() {
			cube([sd_d - sd_pin_d, sd_stop_d, sd_z + sd_h]);

			// Wire cutout

//			translate([sd_stop_d, -.01, 0]) cube([sd_pin_d, (body_d - 2 - sd_w) - (body_d / 2 + 40 / 2) + .02, sd_z]);
		}
		
		// SD lock notch
		translate([body_w - sd_d + 10.9, body_d - 2 - sd_w, 0]) cube([3.75, .5, sd_z + sd_h]);
	}
	
	// PCB screw holes
	translate([pcb_off_x + pcb_h1_x, body_d - pcb_off_y - pcb_d + pcb_h1_y]) {
		cylinder(d = 3.2, h = 7.51, center = true);
		cylinder(d = 6.5, $fn = 6, h = 5.5, center = true);
	}
	
	translate([pcb_off_x + pcb_h2_x, body_d - pcb_off_y - pcb_d + pcb_h2_y]) {
		cylinder(d = 3.2, h = 7.51, center = true);
		cylinder(d = 6.5, $fn = 6, h = 5.5, center = true);		
	}

	// Daughter PCB screw hole
	translate([body_w - dpcb_screw_x, dpcb_screw_y]) {
		cylinder(d = 3.2, h = (8 - 1.6) * 2.01, center = true);
		cylinder(d = 6.5, $fn = 6, h = 10, center = true);		
	}
	
	// LED display front cutout
	translate([body_w - 2.01, body_d / 2 - led_w / 2, led_z]) cube([2.02, led_w, led_h]);
	
	// SD card front cutout
	translate([body_w - 2.01, body_d - 2 - sd_w, sd_z]) cube([2.02, sd_w, sd_h]);
	
	// Button front cutout
	for(i = [0 : 4]) translate([body_w - 1, 5 + i * 2.54 * 2, sd_z + sd_h / 2]) rotate([0, 90, 0]) cylinder(h = 2.01, center = true, d = 3);
	
//	cube([94, body_d, 13]);
//	cube([120, 65, 13]);
}
