class DyTop {
  final int id;

  PVector pos = new PVector();
  PVector vel = new PVector();
  PVector acc = new PVector();
  PVector force = new PVector();
  PVector userForce = new PVector();

  PGraphics topImg = null;
  int topRad = 40;

  // physics const
  final float moveSpeed = 1;
  final float velMagLimit = 8;
  final float dashVelMag = 35;
  final float risistance = 0.01;
  final float mass = 1;
  final float gatherForce = 0.5;
  final float bounceRelativeRate = 0.97;
  final float bounceBasics = 1.1;

  final int dashTime = 130;
  final int coolTime = 2000;
  final float rotSpd = 0.21;
  float rot = 0;
  
  int heart = 3;
  int score = 0;

  // state
  int dashStartTime = -1;
  boolean isBounce = true;
  boolean dashCoolOn = true;
  int coolStartTime = -1;
  
  int imgN = 1;


  DyTop(int _id, PVector _pos) {
    id = _id;
    topImg = createGraphics(topRad*2, topRad*2);
    //set top image
    TopTools.setTopGrapics01(topImg);
    pos.set(_pos);
  }
  
  void setImage(int n) {
    imgN = n;
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
      dirVec.normalize();
      pos = dirVec.copy();
      pos.mult(boardFence);
      pos.add(centerPos);

      dirVec.mult(-1*dirVec.dot(vel));
      vel.add(dirVec);
    }
  }
  
  void bounce(PVector _vel) {
    isBounce = true;
    dashStartTime = -1;
    vel = _vel.copy();
    vel.div(mass);
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

  void physicsUpdate()
  {
    // State : Move
    if (dashStartTime < 0) {
      // cool time update
      if(coolStartTime > 0) {
        if(millis() - coolStartTime > coolTime)
          coolStartTime = -1;
      }
      // -force
      force.mult(0);
      // input
      addForce(userForce.mult(moveSpeed));
      // gather
      PVector gather = PVector.sub(centerPos, pos).copy();
      gather.normalize();
      gather.mult(gatherForce);
      addForce(gather);
      
      // risistance
      PVector ristcV = vel.copy();
      ristcV.normalize();
      ristcV.mult(-1*risistance);
      if (isBounce)
        ristcV.mult(1.6);
      addForce(ristcV);


      acc = force.div(mass).copy();
      vel.add(PVector.mult(acc, 0.035*deltaTime));

      if (isBounce == false && vel.mag() > velMagLimit) {
        vel.setMag(velMagLimit);
      } else if(isBounce == true && vel.mag() < velMagLimit) {
        isBounce = false;
      }

      pos.add(PVector.mult(vel, 0.05*deltaTime));
    }
    // State : Dash
    else {
      if (millis()-dashStartTime > dashTime) {
        dashStartTime = -1;
        vel.mult(0);
      } else {
        pos.add(vel);
      }
    }
    fencingPos();
  }

  void drawUpdate() {
    rot += rotSpd;
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
    if (userForce.magSq() < 0.1 || dashStartTime > 0 || coolStartTime > 0)
      return;
    coolStartTime = millis();
    dashStartTime = millis();
    vel = userForce.normalize().copy();
    vel.mult(dashVelMag);
  }

  void addForce(PVector a) {
    force.add(a);
  }

  void dirInput(float x, float y) {
    userForce.x = x;
    userForce.y = y;
    userForce.normalize();
  }
}
