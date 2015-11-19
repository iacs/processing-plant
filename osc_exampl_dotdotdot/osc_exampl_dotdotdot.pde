/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

int diamX, diamY;
int posx, posy;

void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  diamX = 50;
  diamY = 50;
  posx = height/2;
  posy = width/2;
}


void draw() {
  background(0);
  noStroke();
  fill(255,192,56);
  ellipse(posx, posy, diamX, diamY);
}

//void mousePressed() {
//  /* in the following different ways of creating osc messages are shown by example */
//  OscMessage myMessage = new OscMessage("/test");
  
//  myMessage.add(123); /* add an int to the osc message */

//  /* send the message */
//  oscP5.send(myMessage, myRemoteLocation); 
//}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  if (theOscMessage.checkAddrPattern("/mrmr/slider/horizontal/24/iPad-de-Iago") == true) {
    int value = 0;
    if (theOscMessage.checkTypetag("i")) {
      value = theOscMessage.get(0).intValue();
      posy = int(map(value, 0, 1000, height, 0));
    }
    println("valor: " + value);
  }
  
  if (theOscMessage.checkAddrPattern("/mrmr/slider/horizontal/25/iPad-de-Iago") == true) {
    int value = 0;
    if (theOscMessage.checkTypetag("i")) {
      value = theOscMessage.get(0).intValue();
      posx = int(map(value, 0, 1000, 0, width));
    }
    println("valor: " + value);
  }
}