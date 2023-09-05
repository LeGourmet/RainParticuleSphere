import peasy.*;
import java.util.Collections;

float   RAIN_INTENSITY        = 0.2f;   // mm/h
float   DELTA_TIME            = 0.02f;  // s

float   DROPS_SPHERE_RADIUS  = 50.f;   // m

int     DROPS_NB_MAX          = 50000;  // uniteless
float   DROPS_SIZE_MIN        = 2.f;    // mm
float   DROPS_SIZE_MAX        = 8.f;    // mm
float   DROPS_CX              = 0.47f;

PVector WIND                  = new PVector(-50.f, 25.f,5.f);  // m/s
PVector GRAVITY               = new PVector(  0.f,9.81f,0.f);  // m/s 

PeasyCam camera;
Drop[] drops = new Drop[DROPS_NB_MAX];
ArrayList<Object> obstacles = new ArrayList<>();
DropsSphere dropsSphere = new DropsSphere(new PVector(0.f,0.f,0.f), DROPS_SPHERE_RADIUS);

void setup(){
  size(1200,800,P3D);
  
  textSize(50.);
  textAlign(CENTER);
  
  camera = new PeasyCam(this,2.5*DROPS_SPHERE_RADIUS);
  camera.setMinimumDistance(0.001f);
  camera.setMaximumDistance(1000.f);
  
  //obstacles.add(new Object(new PVector(0.f,0.f,0.f),color(0,127,127),500.f ,"./assets/plane.obj"));
  //obstacles.add(new Object(new PVector(0.f,0.f,0.f),color(0,127,127),2.f*DROPS_SPHERE_RADIUS*0.1f ,"./assets/cube.obj"));

  for(int i=0; i<DROPS_NB_MAX ;i++) drops[i] = new Drop();
}


void draw(){  
  float dropsNeed = min(getNbDropsNeeded(),DROPS_NB_MAX);
  //WIND = PVector.mult(new PVector(10.f,0.f,0.f),3.*cos(frameCount*0.01));
  
  /*****************************************************************************************
   *****************                        DISPLAY                        *****************
   *****************************************************************************************/
  background(0.);
  lights();
  
  // ------ DISPLAY DROPS SPHERE ------
  //dropsSphere.display();
  
  // ------ DISPLAY OBSTACLES ------
  beginShape(TRIANGLES);
  noStroke();
  obstacles.forEach(o -> o.vertices());
  endShape(CLOSE);
  
  // ------ DISPLAY DROPS ------
  stroke(0,0,255);
  for(int i=0; i<DROPS_NB_MAX ;i++) drops[i].display();
  
  // ------ DISPLAY HUD ------
  /*camera.beginHUD();
  fill(255);
  text("Number drops : " + (int) dropsNeed, width*0.5f,height*0.1f,0.f);
  camera.endHUD();*/
  
  /*****************************************************************************************
   *****************                         UPDATE                        *****************
   *****************************************************************************************/
  for(int i=0; i<dropsNeed ;i++) drops[i].recycle(dropsSphere.getMovement());
  
  for(int i=0; i<DROPS_NB_MAX ;i++) {
    drops[i].updatePosition();
    drops[i].updateIntersection();  
  }
  
  //dropsSphere.update(new PVector(100.f*cos(0.1*frameCount),0.f,0.f));
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
