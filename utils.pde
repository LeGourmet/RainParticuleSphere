void translate(PVector p){ translate(p.x,p.y,p.z); }
void line(PVector a, PVector b){line(a.x,a.y,a.z,b.x,b.y,b.z);}
void vertex(PVector p){ vertex(p.x,p.y,p.z); }

float sign(float a){
  if(a<0.) return -1.;
  if(a>0.) return 1.;
  return 0.;
}

float PVector_distSq(PVector a, PVector b){
  PVector x = PVector.sub(a,b);
  return PVector.dot(x,x);
}

float getLambda(){ return 4.1f*pow(RAIN_INTENSITY,-0.21f); }

float getNbDropsNeeded(){
  float lambda = getLambda();
  float area_sphere = 4.f/3.* PI*DROPS_SPHERE_RADIUS*DROPS_SPHERE_RADIUS*DROPS_SPHERE_RADIUS;
  return (RAIN_INTENSITY < 0.01f) ? 0 : floor(area_sphere * 8000.f/lambda * exp(-lambda*DROPS_SIZE_MIN));
}

PVector sampleAreaDropsSphere(PVector p_ray){
  float theta = random(0,PI*2.f);
  float phi   = random(0,PI*2.f);
  float rho   = random(0,DROPS_SPHERE_RADIUS);
  
  return new PVector( rho*sin(theta)*cos(phi), rho*sin(theta)*sin(phi), rho*cos(theta) );
}

PVector sampleSurfaceDropsSphere(PVector p_ray){
  float theta = random(0,PI*2.f);
  float phi   = random(0,PI*2.f);
  
  PVector res = new PVector(
                      DROPS_SPHERE_RADIUS*sin(theta)*cos(phi),
                      DROPS_SPHERE_RADIUS*sin(theta)*sin(phi),
                      DROPS_SPHERE_RADIUS*cos(theta)
                      );
  
  if(PVector.dot(p_ray,res)>0.f) res.mult(-1.f);
  res.add(PVector.mult(p_ray.normalize(),random(0.01f,p_ray.mag())));
  //res.add(PVector.mult(p_ray.normalize(),random(0.01f,PVector.dot(p_ray,res))));    // offset
  res.add(DROPS_SPHERE_CENTER);                                      // translate
  
  return res;
}
