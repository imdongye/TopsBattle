DyTop top;
TopTools topTools;

int inputX;
int inputY;

void setup() {
  size(1200, 980, P2D);
  top = new DyTop(new PVector(width/2, height/2));
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      inputY = -1;
    } else if (keyCode  == DOWN) {
      inputY = 1;
    } else if (keyCode  == LEFT) {
      inputX = -1;
    } else if (keyCode  == RIGHT) {
      inputX = 1;
    }
  } else {
    if (key == 'w') {
      inputY = -1;
    } else if (key  == 's') {
      inputY = 1;
    } else if (key  == 'a') {
      inputX = -1;
    } else if (key  == 'd') {
      inputX = 1;
    }
  }
  top.setUserForce(inputX, inputY);
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP || keyCode  == DOWN) {
      inputY = 0;
    } else if (keyCode  == LEFT || keyCode  == RIGHT) {
      inputX = 0;
    }
  } else {
    if (key == 'w' || key  == 's') {
      inputY = 0;
    } else if (key  == 'a' || key  == 'd') {
      inputX = 0;
    }
  }
  top.setUserForce(inputX, inputY);
}


void draw() {
  background(255);
  top.update();
}
