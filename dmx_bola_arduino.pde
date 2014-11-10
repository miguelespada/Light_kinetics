import fisica.*;
FCircle b, bb;
FWorld world;
int v, c, cc;
float acc;


import codeanticode.prodmx.*;
import processing.serial.*;

DMX dmx;
float g;
 
 Serial myPort;        // The serial port
 int vv = 0;

float delta = 0;
void setup() {
  size(400, 400);
  smooth();

  Fisica.init(this);

  world = new FWorld();
  world.setEdges();
  world.setEdgesRestitution(1);
  world.setEdgesFriction(0);
  
  b = new FCircle(25);
  b.setNoStroke();
  b.setFill(60, 80, 120);
  b.setPosition(width/2, height/2);
  b.setDamping(1);
    
  world.add(b);
   
 println(Serial.list());
 
 dmx = new DMX(this, "/dev/tty.usbserial-EN082513", 115200, 27);
 
  println(Serial.list());
 // I know that the first port in the serial list on my mac
 // is always my  Arduino, so I open Serial.list()[0].
 // Open whatever port is the one you're using.
 myPort = new Serial(this, "/dev/tty.usbmodem24111", 9600);
 // don't generate a serialEvent() unless you get a newline character:
 myPort.bufferUntil('\n');
 // set inital background:
}

void draw() {
  background(255);
  fill(0);
  text(g, 10, 20);
  
  text(v, 10, 40);
  int prevC = c;
  c = int(map(b.getY(), 0, height, 0, 29) - 1);
  if(prevC != c) dmx.setDMXChannel(prevC,0);
  
  v = int(map(b.getY(), 0, height, 255, 0)); 
  v = 150;
  if(c < 4) v -= 25;
  v = constrain(v, 0, 255);
  dmx.setDMXChannel(c,v);
    
  world.step();
  world.draw();
  
  if(b.getVelocityY() == 0){
    if(b.getY() > 6*height/8)
      b.setVelocity(0, -1);
    if(b.getY() < height/8)
      b.setVelocity(0, 1);
  }
  
}

 
 void serialEvent (Serial myPort) {
 // get the ASCII string:
   String inString = myPort.readStringUntil('\n');
 
   if (inString != null) {
   // trim off any whitespace:
     inString = trim(inString);
    
     // convert to an int and map to the screen height:
     float inByte = float(inString); 
     inByte = map(inByte, -512, 512, 0, height);
     vv = (int)lerp(inByte, vv, 0.95);
     println(vv);
     g = map(vv, 234, 159, -400, 400) ;
   
         world.setGravity(0, g );

    }
 }
