// Customizable Mausritter item card

/* [Card Details] */
// Thickness of card in millimeters
card_thickness = 2; //[5] is best
// Thickness of the embossed areas in mm
emboss_level = .6;
// Width of card border in millimeters
border_width = 1; 
// How many inventory squares wide should the card be?
squares_wide = 1;
// How many inventory squares tall should the card be?
squares_tall = 1;
// Title text for card
card_title = "Dagger"; 
// Number of use pips
number_of_uses = 3; //[3, 6]
// Text for item type
card_type = "Light";
// Text for item effect (dmg/def)
detail_text = "d6";
// Filename of card image in SVG format
card_image = ""; 
// Card shape (1, 2h, 2w)
// card_shape = "1"; // [1, 2w, 2t]
// Define card image dimensions and position
// Width of card image in millimeters (use square images if possible)
image_width = 15; 
// Image rotation in degrees
image_rotation = 0;//[-360:360]

// Image offset horizontal
image_offset_x = 0; 
// Image offset vertical
image_offset_y = -1;

flip_image = false;

// Title font
title_font = "Bookman Old Style:style=Bold Italic"; //["Bookman Old Style:style=Bold Italic":"Bookman", "Brokenscript\\-BoldCond:style=Regular":"Brokenscript"]

/* [Advanced] */
// Title font height
title_size = 3;
// Title offset horizontal
title_offset_x = 1.0;
// Title offset vertical
title_offset_y = 1.5;

// Type font height
type_size = 2;
// Type text offset horizontal
type_offset_x = 0;
// Type text offset vertical
type_offset_y = 0;

// Effect font height
detail_size = 2;
// Effect offset horizontal
detail_padding_x = 1;
// Effect offset vertical
detail_padding_y = 1;
// Amount added to the base card height to adjust fit in printed character sheets
print_tolerance = -0.25;


// Height of the header area in millimeters
header_height = 6.5;

// Diameter for use holes
pip_hole_diameter = 1.5;

// Padding to add for difference operations
/* [Hidden] */
diff_padding = .5;
// Define card height and width
// Height of card in millimeters
base_card_height = 25; 
// Width of card in millimeters
base_card_width = 25; 
$fn = 100;

card_height = base_card_height * squares_tall + print_tolerance;
  // (card_shape == "1") ? base_card_height + print_tolerance:
  // (card_shape == "2t") ? base_card_height * 2 + print_tolerance: 
  // (card_shape == "2w") ? base_card_height:base_card_height + print_tolerance;

card_width = base_card_width * squares_wide + print_tolerance;
  // (card_shape == "1") ? base_card_width + print_tolerance:
  // (card_shape == "2t") ? base_card_width + print_tolerance:
  // (card_shape == "2w") ? base_card_width * 2: base_card_width + print_tolerance;



module card_body(){
  // Create card base
  color("green") linear_extrude(height = card_thickness) {
    polygon(points = [
      [0, 0],
      [card_width, 0],
      [card_width, card_height],
      [0, card_height]
    ]);
  }
}

module body_border(){
  translate([0, 0, card_thickness]){
    linear_extrude(height = emboss_level) {
      square([border_width, card_height - header_height]);
    }
  }
  translate([card_width - border_width, 0, card_thickness]){
    linear_extrude(height = emboss_level) {
      square([border_width, card_height - header_height]);
    }
  }
  translate([0, 0, card_thickness]){
    linear_extrude(height = emboss_level) {
      square([card_width, border_width]);
    }
  }
  translate([0, card_height - header_height, card_thickness]){
    linear_extrude(height = emboss_level) {
      square([card_width, border_width]);
    }
  }
}
 

module card_image(){
  card_image_path = str("../icons/", card_image, ".svg");
  // y_rotation = flip_image ? 180 : 0;
  // Create card image
  translate([card_width / 2 - image_width / 2 + image_offset_x, (card_height - header_height) / 2 - image_width / 2 + image_offset_y, card_thickness]) 
    translate([image_width / 2, image_width / 2, 0]) 
      rotate([0,0,image_rotation]) 
        if(flip_image){
          mirror([1,0,0])
          translate([-image_width / 2, -image_width / 2, 0]) 
              linear_extrude(height=emboss_level){
                resize(newsize=[image_width, 0, 0], auto=true) 
                  offset(0.01)
                    import(card_image_path);
              }
        }
        else{
          translate([-image_width / 2, -image_width / 2, 0]) 
              linear_extrude(height=emboss_level){
                resize(newsize=[image_width, 0, 0], auto=true) 
                  offset(0.01)
                    import(card_image_path);
              }
        }
}

module pip(){
  difference(){
    cylinder(h=emboss_level, r1=(pip_hole_diameter + border_width * 2) / 2, r2=(pip_hole_diameter + border_width * 2) / 2);
    translate([0, 0, -diff_padding/2]){
      cylinder(h=emboss_level + diff_padding, r1=(pip_hole_diameter) / 2, r2=(pip_hole_diameter) / 2);
    }
  }
}

module two_row_array(number, spacing){
  num_in_row_1 = number > 3 ? ceil(number / 2) : 3;
  num_in_row_2 = number > 3 ? floor(number / 2) : undef;
  for(i = [0:num_in_row_1 - 1]){
    translate([i * spacing, 0, 0]) children(0);
  }
  for(i = [0:num_in_row_2 - 1]){
    translate([i * spacing, -spacing, 0]) children(0);
  }
}

module pips(){
  translate([border_width + pip_hole_diameter/2, card_height - header_height - border_width, card_thickness]){
    two_row_array(number_of_uses, (pip_hole_diameter + border_width)) pip();
  }
}

module pips(){
  translate([border_width + pip_hole_diameter/2, card_height - header_height - border_width, card_thickness]){
    two_row_array(number_of_uses, (pip_hole_diameter + border_width)) pip();
  }
}


// Create card text
module card_title(){
  translate([title_offset_x, card_height - header_height + title_offset_y, card_thickness]) {
    // Create card title
    linear_extrude(height=emboss_level){
      text(card_title, size = title_size, halign = "left", valign = "bottom", font=title_font);
    }
  }
}

// Create card text
module card_type(){
  translate([type_offset_x + border_width * 2, type_offset_y + border_width * 2, card_thickness]) {
    // Create card title
    linear_extrude(height=emboss_level){
      text(card_type, size = type_size, halign = "left", valign = "bottom", font="Courier New:style=Bold");
    }
  }
}

module card_atk_def(border){
  if(detail_text){
    translate([card_width, card_height - header_height, card_thickness]){
        translate([-detail_padding_x - border_width, -detail_padding_y,0]) {
        // Create card title
        linear_extrude(height=emboss_level){
          text(detail_text, size = detail_size, halign = "right", valign = "top", font="Courier New:style=Bold");
        }
        text_border(chars = len(detail_text), padding_x = 1, padding_y = 1);
      }
    }
  }
}

// module card_def(){
//   translate([0,0,card_thickness]) {
//     linear_extrude(height=emboss_level){
//       text(defense, size = detail_size, halign = "right", valign = "top", font="Courier New:style=Bold");
//     }
//     text_border(chars = len(defense), padding_x = 1, padding_y = 1);
//   }
// }

module text_border(chars, padding_x = 0, padding_y = 0, char_width_ratio = 0.8, char_height = detail_size){
  char_width = char_height * char_width_ratio;
  outer_width = (chars * char_width) + border_width * 2 + padding_x * 2;
  outer_height = char_height + padding_y * 2 + border_width * 2;
  inner_width = (chars * char_width) + padding_x * 2;
  inner_height = char_height + padding_y * 2;
  translate([-outer_width + padding_x + border_width, -outer_height + padding_y + border_width])
    difference(){
      linear_extrude(height=emboss_level){
        square([outer_width, outer_height]);
      }
      translate([border_width, border_width, -diff_padding / 2]) linear_extrude(height=emboss_level + diff_padding){
        square([inner_width, inner_height]);
      }
    }

}

  // Create card description
  //text(card_description, halign = "left", valign = "top");

  // Create card roll details
  //text(card_roll_details, halign = "right", valign = "bottom");

union(){
  card_body();
  body_border();
  card_title();
  card_type();
  card_image();
  card_atk_def();
  pips();
}