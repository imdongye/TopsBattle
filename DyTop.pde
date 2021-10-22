class DyTop {
  final int id;
  PGraphics topImg = null;
  PVector pos = new PVector();
  PVector vel = new PVector();
  PVector acc = new PVector();
  PVector userForce = new PVector();
  int topRad = 50;
  float accMag = 1.4;
  float velMagLimit = 10;
  float dashVelMag = 1500;
  float risistance = 1;
  float dashTime = 0.15;
  float rot = 0;
  float mass = 1;
  float rotSpd = 0.21;

  DyTop(int _id, PVector _pos) {
    id = _id;
    topImg = createGraphics(topRad*2, topRad*2);
    //set top image
    TopTools.setTopGrapics01(topImg);
    pos.set(_pos);
  }
  
  void posUpdate() {
    vel.add(acc);
    if (vel.mag() > velMagLimit) {
      vel.setMag(velMagLimit);
    }
    rot += rotSpd;
    pos.add(vel);
    fencingPos();
  }
  
  void collidesWidth(DyTop top2) {
    PVector cV = top2.pos.copy();
    cV.sub(pos);
    PVector cUV = cV.normalize().copy();
    PVector rV = cUV.mult(cUV.dot(vel));
    rV.mult(2);
    println(rV);
    vel.add(rV.mult(2));
  }
  
  private void fencingPos() {
    float boardFence = boardRad - topRad/2;
    
    PVector dirVec = pos.copy();
    dirVec.sub(centerPos);
    
    if(dirVec.mag() > boardFence) {
      dirVec.setMag(boardFence);
      dirVec.add(centerPos);
      pos = dirVec.copy();
    } 
    
    //pos.x = constrain(pos.x, topRad, width-topRad);
    //pos.y = constrain(pos.y, topRad, height-topRad);
  }
  void drawUpdate() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rot);
    imageMode(CENTER);
    image(topImg, 0, 0);

    popMatrix();
  }
  void update() {
    posUpdate();
    drawUpdate();
  }
  void dash() {
    println(id);
  }
  void setUserForce(float x, float y) {
    acc.x = x;
    acc.y = y;
    acc.setMag(accMag);
  }
}
