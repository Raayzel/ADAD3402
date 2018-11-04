/**
 This is out particle class - it first defines member variables, thena constructor, and then
 it defines methods.
 */


class growingFish
{

  // member variables
  PVector pos;    // pos.x pos.y pos.z
  PVector vel;    // vel.x vel.y vel.z
  PVector acc;    // acc.x acc.y acc.z

  float s = random(-100, 100);
  float d = random(0.08, 0.1);

  boolean attract;    // true is particles should move toward the mouse, false otherwise

  /**
   Constructor method - used with new, as in
   Particle p = new Particle( x, y, z );
   */
  growingFish( float x, float y, float z )
  {
    // instantiate the vectors so we don't get null pointer exceptions
    pos = new PVector(random(width), random(height));   // set the position based on parameters 
    vel = new PVector(random(-1, 1), random(-1, 1));
    acc = new PVector();
    attract = true;
  }  

  /**
   update() - call once each frame to update the position of the particle
   */
  void update()
  {
    
    mouseAttract();               // change acc to make particles accelerate toward the mouse
    vel.add( acc );               // apply acceleration to velocity
    pos.add( vel );               // add velocity to positon (move particle)
    vel.mult( 0.99f );            // apply friction (otherwise particles end up moving too fast)
    acc.set( 0, 0, 0 );           // reset acceleration - we calculate is fresh each loop
  }  // end of Particle.update()

  /**
   draw() - call once each frame to draw the particle on the screen
   */
  void draw()
  {

    pos.add(vel);
    pushMatrix();
    translate(pos.x, pos.y);
    scale(d);
    /* Get the direction and add 90 degrees. */
    rotate(vel.heading2D()-radians(90));
    beginShape();
    for (int i = 0; i <= 180; i+=20) {
      float x = sin(radians(i)) * i/3;
      float angle = sin(radians(i+s+frameCount*16)) * 70;
      vertex(x-angle, i*2);
      vertex(x-angle, i*2);
    }  // end of Particle.draw()

    for (int i = 180; i >= 0; i-=20) {
      //for (int i = 0; i < 180; i+=20){
      float x = sin(radians(i)) * i/3;
      float angle = sin(radians(i+s+frameCount*16)) * 70;
      vertex(-x-angle, i*2);
      vertex(-x-angle, i*2);
    }
    endShape();
    popMatrix();
  }


  /**
   mouseAttract()
   Move particles towards or away from the mouse
   by doing some basic vector math to determine the 
   relationship between the particle and the mouse
   and based on that, calcuating an appropriate acceleration to
   move the particle either away from or to the mouse
   */
  void mouseAttract() {

    PVector f1 = tracker.getPos();


    float magnetism;          // magnetism factor - +tve values attract

    if ( attract == true )     // check if this particle should be attracted or repulsed
    {
      magnetism = 3.0f;      // make particles be attracted to the mouse
    } else
    {
      magnetism = 1.0f;    // make particles be repulsed by the mouse
    }

    PVector mouse = new PVector( f1.x, f1.y ); // create mouse pos as a vector
    mouse.sub( pos );                              // subtract mouse pos from particle pos
    // mouse now contains the difference vector between this particle
    // and the mouse
    float magnitude = mouse.mag();  // find out how far the particle is from the mouse
    acc.set( mouse );               // store this as the acceleration vector

    acc.mult( magnetism / (magnitude * magnitude) );  // scale the attraction/repuse effect using
    // an inverse square
  }  // end of mouseAttract()





  void boundaries() {
    /* Instead of changing the velocity when the fish  */
    if (pos.x < -100) pos.x = width+100;
    if (pos.x > width+100) pos.x = -100;
    if (pos.y < -100) pos.y = height+100;
    if (pos.y > height+100) pos.y = -100;
  }
}
