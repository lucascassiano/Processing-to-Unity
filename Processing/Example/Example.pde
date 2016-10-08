
PImage imgbg;
byte[] output;
PImage img;

boolean showImg = true;
/**
 * init
 */

ScreenBroadcast sb;
 
void setup() {
  sb = new ScreenBroadcast();
  size(1000, 1000);
  imgbg = loadImage("taxi.jpg");

  // create a new datagram connection on port 6000
  // and wait for incomming message
  // Setting up the DatagramSocket, requires try/catch
 
}
boolean a = true;

//process events
void draw() {
  background(0);
  if (showImg == true)
    image(imgbg, 0, 0, 2000, 800);
 
  if (Button("On/Off", 0, 0, 100, 20)) {
    showImg = !showImg;
  }
  
  //loadPixels();
  sb.BroadcastSplit(get());
  delay(20);
  //delay(1);
}





 void keyPressed() {
 keyPressed_UI();
 }
 