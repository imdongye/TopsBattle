class DyTop {
  final int id;

  PVector pos = new PVector();
  PVector vel = new PVector();
  PVector acc = new PVector();
  PVector force = new PVector();
  PVector userForce = new PVector();

  PGraphics topImg = null;
  int topRad = 34;
  
  Tail tail;

  // physics const
  final float moveSpeed = 1;
  final float velMagLimit = 8;
  final float dashVelMag = 25;
  final float risistance = 0.01;
  final float mass = 1;
  final float gatherForce = 0.4;
  final float bounceRelativeRate = 1;
  final float bounceBasics = 1.06;

  final int dashTime = 160;
  final int coolTime = 2000;
  final float rotSpd = 0.21;
  float rot = 0;

  PVector collipoint = new PVector();
  int heart = 3;
  int score = 0;

  // state
  int dashStartTime = -1;
  boolean isBounce = true;
  int coolStartTime = -1;
  final float dieTime = 1500;
  float dieStartTime = -1;
  PVector startPos;

  int imgN = 1;
  
  boolean isItemOn = false;


  DyTop(int _id, PVector _pos) {
    startPos = _pos.copy();
    id = _id;
    topImg = createGraphics(topRad*2, topRad*2);
    //set top image
    TopTools.setTopGrapics01(topImg);
    tail = new Tail(topImg);
    reset();
  }

  void setImage(int n) {
    imgN = n;
    topImg.clear();
    switch(n) {
    case 1:
      TopTools.setTopGrapics01(topImg);
      break;
    case 2:
      TopTools.setTopGrapics02(topImg);
      break;
    case 3:
      TopTools.setTopGrapics04(topImg);
      break;
    case 4:
      TopTools.setTopGrapics03(topImg);
      break;
    }
  }

  private boolean fencingPos() {
    float boardFence = boardRad - topRad/2;

    PVector dirVec = pos.copy();
    dirVec.sub(centerPos);

    if (dirVec.mag() > boardFence) {
      dirVec.normalize();

      // die Check
      //float outForceVel = PVector.dot(vel, dirVec);
      //float outForceVel = vel.mag();
      //if (outForceVel > dashVelMag*0.98) {
      if (collipoint.x>0) {
        collipoint.sub(pos);
        float threshold = (float)boardRad/1.8;
        println(collipoint.mag(), threshold);
        if ((isBounce && collipoint.mag() < threshold)|| dashStartTime > 0) {
          collipoint.set(-1, -1);
          heart--;
          fallSnd.play();
          dieStartTime = millis();
          vel.normalize();
          vel.mult(0.8);
          return true;
        }
      }
      
      collipoint.set(-1,-1);
      pos = dirVec.copy();
      pos.mult(boardFence);
      pos.add(centerPos);

      dirVec.mult(-1.2*dirVec.dot(vel));
      vel.add(dirVec);
      vel.mult(0.7);
    }
    return false;
  }

  void bounce(PVector _vel) {
    isBounce = true;
    dashStartTime = -1;
    if(_vel.mag() > bounceBasics + velMagLimit)
      collipoint = pos.copy();
    else
      collipoint.set(-1,-1);
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

  void reset() {
    pos.set(startPos);
    dieStartTime = -1;
    dashStartTime = -1;
    coolStartTime = -1;
    vel.mult(0);
    acc.mult(0);
    collipoint.set(-1, -1);
    isBounce = false;
  }

  void physicsUpdate()
  {
    // State : die
    if (dieStartTime > 0) {
      if (millis() - dieStartTime > dieTime) {
        startSnd.play();
        dieStartTime = -1;
        reset();
      }
    }
    // State : Move
    else if (dashStartTime < 0) {
      // cool time update
      if (coolStartTime > 0) {
        if (millis() - coolStartTime > coolTime)
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
        ristcV.mult(1.5);
      addForce(ristcV);


      acc = force.div(mass).copy();
      if (isBounce) {
        PVector noPlus = vel.copy();
        noPlus.normalize();
        float dd = noPlus.dot(acc);
        if (dd > 0) {
          noPlus = noPlus.mult(dd);
          acc.sub(noPlus);
        }
      }
      vel.add(PVector.mult(acc, 0.035*deltaTime));

      if (isBounce == false && vel.mag() > velMagLimit) {
        vel.setMag(velMagLimit);
      } else if (isBounce == true && vel.mag() < velMagLimit) {
        isBounce = false;
      }
      pos.add(PVector.mult(vel, 0.05*deltaTime));
      fencingPos();
    }
    // State : Dash
    else {
      if (millis()-dashStartTime > dashTime) {
        dashStartTime = -1;
        vel.mult(0);
      } else {
        pos.add(vel);
      }
      fencingPos();
    }
  }

  void drawUpdate() {
    rot += rotSpd;
    pushMatrix();
    translate(pos.x, pos.y);
    // die effect
    if (dieStartTime > 0) {
      pos.add(vel);
      float s = 1-(millis()-dieStartTime)/dieTime;
      scale(s);
    }
    rotate(rot);
    imageMode(CENTER);
    image(topImg, 0, 0);
    popMatrix();
    
    tail.update(pos.copy(), rot);
  }

  void update() {
    physicsUpdate();
    drawUpdate();
  }

  void dash() {
    final float originRate = 0.1;
    if (isBounce || userForce.magSq() < 0.1 || dashStartTime > 0 || coolStartTime > 0)
      return;
    collipoint = pos.copy();
    dashSnd[0].play();
    coolStartTime = millis();
    dashStartTime = millis();
    float originVelLength = vel.dot(userForce);
    vel = userForce.copy();
    float velLength = dashVelMag + originVelLength*originRate;
    if(isItemOn) {
      velLength +=13;
      isItemOn = false;
    }
    vel.mult(velLength);
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
