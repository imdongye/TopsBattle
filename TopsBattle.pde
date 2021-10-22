import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice stick;

DyTop[] top = new DyTop[2];
TopTools topTools;

PVector centerPos;
float boardRad;

PVector inputP1 = new PVector(0, 0);
PVector inputP2 = new PVector(0, 0);
TopsBoard topsBoard;

void setup() {
  size(1400, 900, P2D);
  surface.setTitle("팽이게임");
  
  centerPos = new PVector(width/2, height/2, 0);
  boardRad = height/2;
  
  control = ControlIO.getInstance(this);
  stick = null;
  top[0] = new DyTop(0, new PVector(width/4, height/2));
  top[1] = new DyTop(1, new PVector(width/4*3, height/2));
  topsBoard = new TopsBoard(height/2);
}

void updateGamePadInput() {
  if (stick != null) {
    inputP1.x = map(stick.getSlider(1).getValue(), -1, 1, -1, 1);
    inputP1.y = map(stick.getSlider(0).getValue(), -1, 1, -1, 1);

    inputP2.x = map(stick.getSlider(3).getValue(), -1, 1, -1, 1);
    inputP2.y = map(stick.getSlider(2).getValue(), -1, 1, -1, 1);

    top[0].setUserForce(inputP1.x, inputP1.y);
    top[1].setUserForce(inputP2.x, inputP2.y);
  }
}
void dashPressed() {
  println("dash");
}
void setStick() {
  stick = control.filter(GCP.GAMEPAD).getMatchedDevice("joystick");
  if (stick == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  println(stick);
  stick.setTolerance(0.2);
  stick.getButton(4).plug(this, "dashPressed", ControlIO.ON_PRESS);
}
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      inputP2.y = -1;
    } else if (keyCode  == DOWN) {
      inputP2.y = 1;
    } else if (keyCode  == LEFT) {
      inputP2.x = -1;
    } else if (keyCode  == RIGHT) {
      inputP2.x = 1;
    }
  } else {
    if (key == 'x') {
      if ( stick != null) stick = null;
      else {
        setStick();
      }
    }
    if (key == 'w') {
      inputP1.y = -1;
    } else if (key  == 's') {
      inputP1.y = 1;
    } else if (key  == 'a') {
      inputP1.x = -1;
    } else if (key  == 'd') {
      inputP1.x = 1;
    }
  }
  top[0].setUserForce(inputP1.x, inputP1.y);
  top[1].setUserForce(inputP2.x, inputP2.y);
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP || keyCode  == DOWN) {
      inputP2.y = 0;
    } else if (keyCode  == LEFT || keyCode  == RIGHT) {
      inputP2.x = 0;
    }
  } else {
    if (key == 'w' || key  == 's') {
      inputP1.y = 0;
    } else if (key  == 'a' || key  == 'd') {
      inputP1.x = 0;
    }
  }
  top[0].setUserForce(inputP1.x, inputP1.y);
  top[1].setUserForce(inputP2.x, inputP2.y);
}
void collisionDetect() {
  PVector betweenVec = top[0].pos.copy();
  betweenVec.sub(top[1].pos);
  
  if(betweenVec.mag() < top[0].topRad + top[1].topRad) { //<>//
    top[0].collidesWidth(top[0]);
    top[1].collidesWidth(top[1]);
  }
}
void gameUpdate() {
  background(255); 
  topsBoard.draw();
  
  updateGamePadInput();
  
  collisionDetect();
  
  top[0].update();
  top[1].update();
}
  

void draw() {
  
  gameUpdate();
}
