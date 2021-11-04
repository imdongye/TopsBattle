class Item {
  PVector pos = new PVector();
  PVector vel = new PVector();
  float rad = 10;

  Item(PVector _pos) {
    pos.set(_pos);
    vel.set(0, 0);
  }
  void update() {
    vel.x += (noise(millis()/101)-0.5)*0.9;
    vel.y += (noise(millis()/101 + 200)-0.5)*0.9;
    if (vel.magSq() > 9)
      vel.setMag(3);
    pos.add(vel);
    fencingPos();

    pushMatrix();
    translate(pos.x, pos.y);
    fill(color(250, 225, 0));
    strokeWeight(1);
    circle(0, 0, rad*2);
    popMatrix();
  }
  void fencingPos() {
    float boardFence = boardRad - rad;

    PVector dirVec = pos.copy();
    dirVec.sub(centerPos);

    if (dirVec.mag() > boardFence) {
      dirVec.normalize();

      pos = dirVec.copy();
      pos.mult(boardFence);
      pos.add(centerPos);

      dirVec.mult(-1.4*dirVec.dot(vel));
      vel.add(dirVec);
    }
  }
}
