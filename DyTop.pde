enum TopState {
  MOVE, DASH
}

class DyTop {
  TopState tState;
  final int id;
  PGraphics topImg = null;
  PVector pos = new PVector();
  PVector vel = new PVector();
  PVector acc = new PVector();
  PVector force = new PVector();
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
  int dashStartTime = -1;

  DyTop(int _id, PVector _pos) {
    tState = TopState.MOVE;
    id = _id;
    topImg = createGraphics(topRad*2, topRad*2);
    //set top image
    TopTools.setTopGrapics01(topImg);
    pos.set(_pos);
  }
  void setImage(int n) {
    switch(n) {
      case 1:
      TopTools.setTopGrapics01(topImg);
      break;
      case 2:
      TopTools.setTopGrapics02(topImg);
      break;
      case 3:
      TopTools.setTopGrapics03(topImg);
      break;
      case 4:
      TopTools.setTopGrapics04(topImg);
      break;
    }
  }
  private void fencingPos() {
    float boardFence = boardRad - topRad/2;

    PVector dirVec = pos.copy();
    dirVec.sub(centerPos);

    if (dirVec.mag() > boardFence) {
      dirVec.setMag(boardFence);
      dirVec.add(centerPos);
      pos = dirVec.copy();

      dirVec.normalize();
      dirVec.mult(dirVec.dot(vel));
      vel.sub(dirVec);
    }
  }
  
  void collidesWidth(DyTop top2) {
    PVector fp = pos.copy();
    PVector sp = top2.pos.copy();
    PVector stof = PVector.sub(fp, sp);
    println(sp);
    stof.normalize();
    stof.mult(5);
    println(stof);
    vel.add(stof);
  }
  
  void physicsUpdate() {
    addCenterForce();
    acc = force.div(mass).copy();
    force.mult(0);
    acc.setMag(accMag);
    
    vel.add(acc);
    if (vel.mag() > velMagLimit) {
      vel.setMag(velMagLimit);
    }
    rot += rotSpd;
    pos.add(vel);

    fencingPos();
  }
  void addCenterForce() {
    PVector d = PVector.sub(centerPos, pos).copy();
    d.normalize();
    d.mult(1.2);
    force.add(d);
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
    physicsUpdate();
    drawUpdate();
  }
  void dash() {
    dashStartTime = millis();
  }
  void addForce(float x, float y) {
    force.x += x;
    force.y += y;
  }
  void dirInput(float x, float y) {
    force.x += x;
    force.y += y;
  }
}
