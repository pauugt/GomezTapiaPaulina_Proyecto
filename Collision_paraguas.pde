import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


Box2DProcessing box2d;


ArrayList<Particle> particles;

Boundary wall;

PImage bg;
PShape bot;
int x,y;

Minim minim;
AudioPlayer player; //para que se reproduzca automaticamente

void setup() {
  size(800, 700, P3D);
  smooth();
  bg=loadImage("fondo_noche.jpg");
  bot=loadShape("silueta_mujer.svg");
  
  minim = new Minim(this);
  
  player = minim.loadFile("cancion.mp3");
//  song.play();//para que se reproduzca
player.play ();

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();


  box2d.listenForCollisions();

  // Create the empty list
  particles = new ArrayList<Particle>();

  wall = new Boundary(width/2, height-5, width, 10);
}

void lluvia(){
    fill(random(255),random(255),random(255));
    ellipse(random(width), random(height),10,10);
}
void draw() {
  background(255);
  image(bg,0,0);
  shape(bot,220+x,400+y, 200,245);
  
  if (keyPressed)
  {
    if (keyCode==LEFT)
    {
      x-=5;
      lluvia();
      }
      else if (keyCode==RIGHT)
      {
        x+=5;
              lluvia();

        }}

  if (random(1) < 0.15) {
    float sz = random(4, 8);
    particles.add(new Particle(random(width), 20, sz));
  }


  // We must always step through time!
  box2d.step();

  // Look at all particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
   
    if (p.done()) {
      particles.remove(i);
    }
  }

  wall.display();
}


// Collision event functions!
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Particle.class && o2.getClass() == Particle.class) {
    Particle p1 = (Particle) o1;
    p1.change();
    Particle p2 = (Particle) o2;
    p2.change();
  }

}

// Objects stop touching each other
void endContact(Contact cp) {
}