import peasy.*;
import java.util.Collections;

float   RAIN_INTENSITY        = 0.2;     // mm/h
float   DELTA_TIME            = 0.02;   // s

float   DROPS_SPHERE_RADIUS   = 300.f;   // m
PVector DROPS_SPHERE_CENTER   = new PVector(0.f,0.f,0.f); // unitless

int     DROPS_NB_MAX          = 50000;  // uniteless
float   DROPS_SIZE_MIN        = 2.f;    // mm
float   DROPS_SIZE_MAX        = 8.f;    // mm
float   DROPS_CX              = 0.47;

PVector WIND                  = new PVector(-100.f,30.f,50.f);  // m/s
PVector GRAVITY               = new PVector(0.f,9.81f,0.f);     // m/s
PVector CAMERA_TRANSLATION    = new PVector(0.f,0.f,0.f);

PeasyCam camera;
Drop[] drops = new Drop[DROPS_NB_MAX];
ArrayList<Object> obstacles = new ArrayList<>();

void setup(){
  size(1200,800,P3D);
  
  textSize(50.);
  textAlign(CENTER);
  
  camera = new PeasyCam(this,3*DROPS_SPHERE_RADIUS);
  camera.setMinimumDistance(0.001f);
  camera.setMaximumDistance(1000.f);
  
  obstacles.add(new Object(new PVector(0.f,0.f,0.f),color(0,127,127),10.f,"./assets/cube.obj"));
  obstacles.add(new Object(new PVector(0.f,0.f,0.f),color(0,127,127),500.f ,"./assets/plane.obj"));

  for(int i=0; i<DROPS_NB_MAX ;i++) drops[i] = new Drop();
}


void draw(){  
  float dropsNeed = min(getNbDropsNeeded(),DROPS_NB_MAX);
  PVector oldCameraPos = CAMERA_TRANSLATION.copy();
  
  CAMERA_TRANSLATION.set(100.f*cos(0.1*frameCount),0.f,0.f);
  DROPS_SPHERE_CENTER.add(CAMERA_TRANSLATION);
  
  /*****************************************************************************************
   *****************                        DISPLAY                        *****************
   *****************************************************************************************/
  background(0.);
  lights();
  
  // ------ DISPLAY DROPS SPHERE ------
  noFill();
  stroke(255);
  strokeWeight(0.1);
  sphereDetail(36);
  pushMatrix();
  translate(DROPS_SPHERE_CENTER);
  sphere(DROPS_SPHERE_RADIUS);
  popMatrix();
  
  
  // ------ DISPLAY DROPS ------
  stroke(0,0,255);
  for(int i=0; i<DROPS_NB_MAX ;i++) drops[i].display();
  
  // ------ DISPLAY OBSTACLES ------
  beginShape(TRIANGLES);
  noStroke();
  for(Object o : obstacles) o.vertices();
  endShape(CLOSE);
  
  // ------ DISPLAY HUD ------
  camera.beginHUD();
  fill(255);
  text("Number drops : " + (int) dropsNeed, width*0.5,height*0.1,0);
  camera.endHUD();
  
  /*****************************************************************************************
   *****************                         UPDATE                        *****************
   *****************************************************************************************/
  for(int i=0; i<dropsNeed ;i++) drops[i].recycle(PVector.sub(CAMERA_TRANSLATION,oldCameraPos));
  
  for(int i=0; i<DROPS_NB_MAX ;i++) {
    drops[i].updatePosition();
    drops[i].updateIntersection();  
  }
  
  DROPS_SPHERE_CENTER.sub(CAMERA_TRANSLATION);
}

void keyPressed(){
  switch(key){
    case CODED : switch(keyCode){
      case UP : RAIN_INTENSITY += 0.1; break;
      case DOWN : RAIN_INTENSITY -= 0.1; break; 
      case RIGHT : RAIN_INTENSITY += 0.01; break;
      case LEFT : RAIN_INTENSITY -= 0.01; break;
    } break;
    case 'i' : 
      println("frameRate: "+frameRate);
      println("intensity rain: "+RAIN_INTENSITY); 
      break;
  }
}
