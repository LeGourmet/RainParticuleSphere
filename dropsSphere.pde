public class DropsSphere{
  private PVector _positionOld;
  private PVector _position;
  private float   _radius;
  
  public DropsSphere(PVector p_center, float p_radius){
    this._positionOld = new PVector(0.f,0.f,0.f);
    this._position = p_center;
    this._radius = p_radius;
  }
  
  public PVector getMovement(){
    return PVector.sub(_position,_positionOld);
  }
  
  public float getArea(){
    return 4.f/3.f* PI*_radius*_radius*_radius;
  }
  
  public void update(PVector p_newPos){
    _positionOld.set(_position);
    _position.set(p_newPos);
  }
  
  public void display(){
    noFill();
    stroke(255);
    strokeWeight(1.);
    sphereDetail(36);
    pushMatrix();
    translate(_position);
    sphere(_radius);
    popMatrix();
  }
  
  public boolean isOutside(PVector p){
    return (_radius<PVector.dist(_position,p));
  }
  
  PVector sampleArea(PVector p_ray){
    float theta = random(0,PI*2.f);
    float phi   = random(0,PI*2.f);
    float rho   = random(0,_radius);
    
    return new PVector( rho*sin(theta)*cos(phi), rho*sin(theta)*sin(phi), rho*cos(theta) );
  }
  
  PVector sampleSurface(PVector p_ray){
    float theta = random(0,PI*2.f);
    float phi   = random(0,PI*2.f);
    
    PVector res = new PVector(_radius*sin(theta)*cos(phi), _radius*sin(theta)*sin(phi), _radius*cos(theta));
    
    if(PVector.dot(p_ray,res)>0.f) res.mult(-1.f);
    res.add(PVector.mult(p_ray.normalize(),random(0.01f,p_ray.mag())));
    //res.add(PVector.mult(p_ray.normalize(),random(0.01f,PVector.dot(p_ray,res))));    // offset
    res.add(_position);                                      // translate
    
    return res;
  }
}
