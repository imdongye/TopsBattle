import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice stick;

DyTop top;
TopTools topTools;

float inputX1;
float inputY1;
float inputX2;

void setup() {
  size(1200, 980, P2D);
  surface.setTitle("팽이게임");

  control = ControlIO.getInstance(this);
  stick = control.filter(GCP.STICK).getMatchedDevice("joystick");
  if (stick == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  println(stick);
  stick.setTolerance(0.2);
  top = new DyTop(new PVector(width/2, height/2));
}

void updateGamePadInput() {
  if (stick != null) {
    inputX1 = map(stick.getSlider(1).getValue(), -1, 1, -1, 1);
    inputY1 = map(stick.getSlider(0).getValue(), -1, 1, -1, 1);
    // limit level : 0.02
    top.setUserForce(inputX, inputY);
    if(stick.getButton(4).pressed()) {
      println("dash");
    }
    if(stick.getButton(5).pressed()) {
      println("dash");
    }
  }
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
  updateGamePadInput();
  top.update();
}
