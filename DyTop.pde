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
    pos.x = constrain(pos.x + vel.x, topRad, width-topRad);
    pos.y = constrain(pos.y + vel.y, topRad, height- topRad);
    rot += rotSpd;
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
