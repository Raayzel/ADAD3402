// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

import processing.opengl.*;

float reScale;
float minThresh = 400;
float maxThresh = 1000;

int kinectWidth = 640;
int kinectHeight = 480;

float total = 0;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;
Fish f;
scaledFish sF;
growingFish gF;
Fish[] pFish;   
scaledFish[] sFish;
growingFish[] gFish;

void setup() {

  fullScreen();


  noStroke();
  //  strokeJoin(ROUND);
  //  strokeWeight(1);
  //  stroke(255, 255, 255);
  smooth(3);  


  //tryint to rescale kinect


  reScale = (float) width / kinectWidth;

  kinect = new Kinect(this);
  tracker = new KinectTracker();
  f = new Fish(random( width ), random( height ), 0);
  sF = new scaledFish(random( width ), random( height ), 0);
  gF = new growingFish(random( width ), random( height ), 0);

  pFish = new Fish[100];    //normal fish
  sFish = new scaledFish[30];    // fish that changes size
  gFish = new growingFish[210];    // fish that grows in numbers

  for ( int i=0; i<pFish.length; i++ )
  {
    pFish[i] = new Fish( random(width), random(height), 0 ); 
    pFish[i].vel.set( random(-1, 1), random(-1, 1), 0 );
  }


  for ( int i=0; i<sFish.length; i++ )
  {
    sFish[i] = new scaledFish( random(width), random(height), 0 ); 
    sFish[i].vel.set( random(-1, 1), random(-1, 1), 0 );
  }


  for ( int i=0; i<gFish.length; i++ )
  {
    gFish[i] = new growingFish( random(width), random(height), 0 ); 
    gFish[i].vel.set( random(-1, 1), random(-1, 1), 0 );
  }
}




void draw() {

  translate(0, (height-kinectHeight*reScale)/2);
  scale(reScale);

  tracker.track();
  //tracker.display();



  PVector v1 = tracker.getPos();
  fill(0, 25, 69, 140);
  rect(-30, -30, width+40, height+40);
  fill(255, 255, 255);



  for ( int i=0; i < pFish.length; i++ )
  {
    pFish[i].update();    // update the particle
    pFish[i].draw();               // draw the particle
  }


  for ( int i=0; i < sFish.length; i++ )
  {
    sFish[i].update();    // update the particle
    sFish[i].draw();               // draw the particle
  }

  for ( int i=0; i < total; i++ )
  {
    gFish[i].update();    // update the particle
    gFish[i].draw();               // draw the particle
  }



  int gRecord = 1000;
  int rx = 0;
  int ry = 0;
  int sum = 0;


  int[] depthValues = kinect.getRawDepth();

  for (int x = 0; x < kinect.width; x++) {
    for (int y = 0; y < kinect.height; y++) {

      int o =  x + y*kinect.width;
      // Grabbing the raw depth
      int rawDepth = depthValues[o];

      if (rawDepth < gRecord) {
        gRecord = rawDepth;
        rx = x;
        ry = y;
      }



      float g = map(gRecord, minThresh, maxThresh, 0, 190);
      total = g;
    }
    //    //disperse fish
    //    
    //    if (gRecord < 500) {
    //      for ( int i=0; i<pFish.length; i++ )          // loop through all particles, and for each one...
    //      {
    //        pFish[i].attract = !pFish[i].attract;  // ...use NOT (!) to flip true to false and vice versa
    //        // eg: !true == false
    //        // so, if attract == true then !attract == false (note the exclamation mark)
    //      }
    //println(gRecord);
    //    }
  }
}
