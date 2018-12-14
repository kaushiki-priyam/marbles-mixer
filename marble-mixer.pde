import cc.arduino.*;
import org.firmata.*;

 //global variables
import processing.serial.*; 

Arduino arduino; 
//assign pin values
int xPin = 3; //Assign pin A3 to x 
int yPin = 4; //Assign pin A4 to y
int x1, y1;
//marbles color related
int redFSRpin = 0;
int greenFSRpin = 1; 
int blueFSRpin = 2;
int redPin = 11; 
int greenPin = 10;
int bluePin = 9;
int redPin2 = 3;
int greenPin2 = 5;
int bluePin2 = 6;
int redColor, greenColor, blueColor;
color marbles_color = color(0,0,0);
String rgb_string;
PFont f; // Global font variable
PVector location; // Location of shape
PVector velocity; // Velocity of shape
PVector reference_acceleration;  // Gravity acts at the shape's acceleration
int topspeed = 20;
int radius = 70;
int border = 0; 
//fading effect
boolean clear_button = false;
float clearspeed = 0.75;
float inkhue = 0;
int bright = 99;
int brght2 = 0;
int sat = 25;
int clearing = 0;
void setup(){
 size(3240, 2100); //overall screen size 
 background(255);
 println(Arduino.list());
 
 //Calibrate the next two lines based on the currently running setup
 //arduino = new Arduino(this,"/dev/tty.usbmodem14101",57600);
 arduino = new Arduino(this,"COM3",57600);  
 reference_acceleration = new PVector(330,330);
 
 velocity = new PVector(0,0); 
 location = new PVector(100,100);
 
 arduino.pinMode(redPin, Arduino.OUTPUT);
 arduino.pinMode(greenPin, Arduino.OUTPUT);
 arduino.pinMode(bluePin, Arduino.OUTPUT);
 arduino.pinMode(redPin2, Arduino.OUTPUT);
 arduino.pinMode(greenPin2, Arduino.OUTPUT);
 arduino.pinMode(bluePin2, Arduino.OUTPUT);

}
void draw() {
 marbles_color = refresh_color();
 //textFont(f,24);
 //rgb_string = "R: " + redColor + ", G: "+ greenColor +" B: " + blueColor;
 //text(rgb_string, border, height); 
 //drawborders_long();
 
 //SENSOR acceleration
 x1 = arduino.analogRead(xPin);
 y1 = arduino.analogRead(yPin);
 //println("x1:",x1," y1:",y1);
 
 PVector acceleration = PVector.sub(new PVector(x1,y1),reference_acceleration);
 // Set magnitude of acceleration
 acceleration.setMag(25);
 
 // Velocity changes according to acceleration
 velocity.add(acceleration);
 // Limit the velocity by topspeed
 velocity.limit(topspeed);
 // Location changes by velocity
 location.add(velocity);
 
 // Bounce off edges
 if (location.x > width-radius-border) {
  location.x = width-radius-border;
  velocity.x = velocity.x * -1;
 }
 else if (location.x < radius+border) {
  location.x = radius+border;
  velocity.x = velocity.x * -1;
 }
 if (location.y > height-radius-border) {
  location.y = height-radius-border;
  velocity.y = velocity.y * -1; 
 }
 else if(location.y < radius+border) {
  location.y = radius+border;
  velocity.y = velocity.y * -1; 
 }
 //brushstrokes by Jefferson Lam
 colorMode(RGB, 255, 255, 255, 99);
 //DRAWING WITH MOUSE----- 
 //create transparent rect for fade effect
 noStroke();
 fill(255, 255, 255, clearspeed);
 rectMode(CENTER);
 rect(width/2,height/2,width-2*border,height-2*border);
 
 // Display circle at location vector 
 //color and width of inkhue
 fill(marbles_color, bright);
 stroke(marbles_color, bright);
 strokeWeight(0);
 ellipse(location.x,location.y, radius, radius);
 
 //clear screen when square button is pressed
 if (clear_button) {
  clearspeed = 25;
  clearing = clearing+1;
  if (clearing==20) {
   clear_button = !clear_button;
   clearspeed = 0.75;
   clearing = 0;
  }
 }
}
void keyPressed(){
 if (keyCode==ENTER) clear_button = !clear_button;
 if (keyCode == 83) saveFrame("art-######.jpg"); // save frame when S is pressed
}
void mousePressed(){
 if(mouseX > width/2) clear_button = !clear_button;
 else saveFrame("art-######.jpg");
}
void setColor(int red, int green, int blue)
{
 red = 255 - red;
 green = 255 - green;
 blue = 255 - blue;
 arduino.analogWrite(redPin, red);
 arduino.analogWrite(greenPin, green);
 arduino.analogWrite(bluePin, blue); 
 arduino.analogWrite(redPin2, red);
 arduino.analogWrite(greenPin2, green);
 arduino.analogWrite(bluePin2, blue); 
}
color refresh_color() {
 int redFSR = arduino.analogRead(redFSRpin);
 int greenFSR = arduino.analogRead(greenFSRpin);
 int blueFSR = arduino.analogRead(blueFSRpin);
 
 //println("redFSR: ", redFSR," greenFSR: ", greenFSR, " blueFSR: ", blueFSR);
 
 if (redFSR > 200) redColor = 255;
 else if (redFSR > 180 ) redColor = 240;
 else if (redFSR > 160 ) redColor = 220;
 else if (redFSR > 140 ) redColor = 200;
 else if (redFSR > 120 ) redColor = 180;
 else if (redFSR > 100 ) redColor = 160; 
 else if (redFSR > 80 ) redColor = 140;
 else if (redFSR > 60 ) redColor = 120;
 else if (redFSR > 50 ) redColor = 100;
 else if (redFSR > 40 ) redColor = 80;
 else if (redFSR > 35 ) redColor = 60;
 else if (redFSR > 30 ) redColor = 40;
 else if (redFSR > 25 ) redColor = 20; 
 else redColor = 0;
 
 if (greenFSR > 150) greenColor = 255;  
 else if (greenFSR > 140 ) greenColor = 240;
 else if (greenFSR > 130 ) greenColor = 220;
 else if (greenFSR > 125 ) greenColor = 200;
 else if (greenFSR > 120 ) greenColor = 180;
 else if (greenFSR > 100 ) greenColor = 160;
 else if (greenFSR > 80 ) greenColor = 140;
 else if (greenFSR > 60 ) greenColor = 120;
 else if (greenFSR > 50 ) greenColor = 100;
 else if (greenFSR > 40 ) greenColor = 80;
 else if (greenFSR > 30 ) greenColor = 60; 
 else if (greenFSR > 25 ) greenColor = 40;
 else if (greenFSR > 20 ) greenColor = 20;
 else greenColor = 0;
 
 if (blueFSR > 700) blueColor = 255; 
 else if (blueFSR > 650 ) blueColor = 240;
 else if (blueFSR > 600 ) blueColor = 220;
 else if (blueFSR > 550 ) blueColor = 200;
 else if (blueFSR > 500 ) blueColor = 180;
 else if (blueFSR > 450 ) blueColor = 160;
 else if (blueFSR > 400 ) blueColor = 140; 
 else if (blueFSR > 350 ) blueColor = 120;
 else if (blueFSR > 300 ) blueColor = 100; 
 else if (blueFSR > 250 ) blueColor = 80; 
 else if (blueFSR > 200 ) blueColor = 60; 
 else if (blueFSR > 150 ) blueColor = 40; 
 else if (blueFSR > 90 ) blueColor = 20;
 else blueColor = 0;
 setColor(redColor, greenColor, blueColor);
 color new_color = color(redColor, greenColor, blueColor);
 return new_color;
}
