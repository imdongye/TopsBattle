class DyTop {
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

  DyTop(PVector _pos) {
    topImg = createGraphics(topRad*2, topRad*2);
    //set top image
    TopTools.setTopGrapics02(topImg);
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

    image(topImg, -topRad, -topRad);

    popMatrix();
  }
  void update() {
    posUpdate();
    drawUpdate();
  }
  void setUserForce(float x, float y) {
    acc.x = x;
    acc.y = y;
    acc.setMag(accMag);
  }
}
