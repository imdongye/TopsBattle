import org.gamecontrolplus.gui.*; //<>//
import org.gamecontrolplus.*;
import net.java.games.input.*;
import processing.sound.*;
import processing.video.*;

ControlIO control;
ControlDevice stick;

DyTop top0, top1;
TopTools topTools;

PVector centerPos;
int boardRad;

PVector joyP1 = new PVector(0, 0);
PVector joyP2 = new PVector(0, 0);
PVector inputP1 = new PVector(0, 0);
PVector inputP2 = new PVector(0, 0);
TopsBoard topsBoard;

float prevMillis = 0;
float deltaTime = 0;

PFont mainFont;
PImage hImg;
SoundFile bgm;
HighPass highP;
SoundFile[] coliSnd = new SoundFile[5];
SoundFile[] dashSnd = new SoundFile[2];
SoundFile fallSnd;
SoundFile itemSnd;
SoundFile startSnd;

IntroScene intro;
Movie i_movie;
PImage backImg;

Item item;
int itemCoolStartTime = -1;
int itemCoolTime = 9000;


void setup() {
  size(1400, 900, P2D);
  smooth(2);
  surface.setTitle("팽이게임");
  mainFont = createFont("ail.ttf", 200);
  hImg = loadImage("h.png");
  centerPos = new PVector(width/2, height/2, 0);
  boardRad = height/2-30;

  control = ControlIO.getInstance(this);
  stick = null;
  top0 = new DyTop(0, new PVector(width/4, height/2));
  top1 = new DyTop(1, new PVector(width/4*3, height/2));
  top0.setImage(1);
  top1.setImage(2);
  topsBoard = new TopsBoard(boardRad);
  prevMillis = millis();
  bgm = new SoundFile(this, "sound/song.mp3");
  bgm.loop();
  highP = new HighPass(this);
  highP.freq(700);
  highP.process(bgm);
  coliSnd[0] = new SoundFile(this, "sound/coli1.mp3");
  coliSnd[1] = new SoundFile(this, "sound/coli2.mp3");
  coliSnd[2] = new SoundFile(this, "sound/coli3.mp3");
  coliSnd[3] = new SoundFile(this, "sound/coli4.mp3");
  coliSnd[4] = new SoundFile(this, "sound/coli5.mp3");
  dashSnd[0] = new SoundFile(this, "sound/dash1.mp3");
  dashSnd[1] = new SoundFile(this, "sound/dash2.mp3");
  fallSnd = new SoundFile(this, "sound/fall.wav");
  itemSnd = new SoundFile(this, "sound/item.wav");
  startSnd = new SoundFile(this, "sound/start.mp3");
  intro = new IntroScene();
  i_movie = new Movie(this, "intro.mp4");
  i_movie.loop();
  backImg = loadImage("back.png");
  item = null;
}

void movieEvent(Movie movie) {
  movie.read();
}

void setStick() {
  stick = control.filter(GCP.STICK).getMatchedDevice("joystick");
  if (stick == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  println(stick);
  stick.setTolerance(0.2);
  stick.getButton(4).plug(this, "dashPressedP0", ControlIO.ON_PRESS);
  stick.getButton(5).plug(this, "dashPressedP1", ControlIO.ON_PRESS);
}

void updateGamePadInput() {
  if (stick != null) {
    joyP1.x = map(stick.getSlider(1).getValue(), -1, 1, -1, 1);
    joyP1.y = map(stick.getSlider(0).getValue(), -1, 1, -1, 1);

    joyP2.x = map(stick.getSlider(3).getValue(), -1, 1, -1, 1);
    joyP2.y = map(stick.getSlider(2).getValue(), -1, 1, -1, 1);
  }
}

void dashPressedP0() {
  top0.dash();
}
void dashPressedP1() {
  top1.dash();
}
void keyPressed() {
  if (intro != null) {
    intro.i_key_pressed();
    // start key
    if (key == ' ') {
      highP.stop();
      startSnd.play();
      top0.setImage(intro.choice1+1);
      top1.setImage(intro.choice2+1);
      top0.heart = 3;
      top0.reset();
      top0.score = 0;
      top1.heart = 3;
      top1.reset();
      top1.score=0;
      intro = null;
      item = null;
      itemCoolStartTime = millis();
    } else if (key == 'x') {
      if ( stick != null) stick = null;
      else {
        setStick();
      }
    }
    return;
  }
  // dir input
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
  // other input
  if (key == '1') {
    dashPressedP0();
  } else if ( key == '/') {
    dashPressedP1();
  } else if (key == 'x') {
    if ( stick != null) stick = null;
    else {
      setStick();
    }
  } else if (key == 'r') {
    highP.process(bgm);
    intro = new IntroScene();
    i_movie.loop();
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP && inputP2.y < -0.5) {
      inputP2.y = 0;
    } else if (keyCode  == DOWN && inputP2.y > 0.5) {
      inputP2.y = 0;
    } else if (keyCode  == LEFT && inputP2.x < -0.5) {
      inputP2.x = 0;
    } else if (keyCode  == RIGHT&& inputP2.x > 0.5) {
      inputP2.x = 0;
    }
  } else {
    if (key == 'w' && inputP1.y < -0.5) {
      inputP1.y = 0;
    } else if (key  == 's' && inputP1.y > 0.5) {
      inputP1.y = 0;
    } else if (key  == 'a' && inputP1.x < -0.5) {
      inputP1.x = 0;
    } else if (key  == 'd' && inputP1.x > 0.5) {
      inputP1.x = 0;
    }
  }
}


void uiUpdate() {
  image(backImg, width/2,height/2,width, height);
  fill(255);
  topsBoard.draw();

  // <player0>
  textAlign(LEFT);
  textFont(mainFont, 50);
  fill(240);
  text("Player 1", 20+47, 80);
  // top img
  pushMatrix();
  translate(20+110, 200);
  scale(1.5);
  imageMode(CENTER);
  image(top0.topImg, 0, 0);
  popMatrix();
  // dash gauge
  pushMatrix();
  translate(width/10.5, height/2);
  noStroke();
  float percent0 = 0;
  if (top0.coolStartTime < 0) {
    percent0 = 1;
  } else {
    percent0 = (float)(millis() - top0.coolStartTime)/top0.coolTime;
  }
  
  if(top0.isItemOn) {
    fill(color(255*(percent0), 255*percent0, 255*(1-percent0)));
  } else {
    fill(color(150*(1-percent0), 240*percent0, 240*(1-percent0*0.5)));
  }
  circle(0, 0, 140*percent0);
  // dash gauge outside
  stroke(0);
  noFill();
  strokeWeight(7);
  circle(0, 0, 140);
  popMatrix();
  for (int i = 0; i < top0.heart; i++) {
    image(hImg, 100+i*60, height - 200);
  }

  // <player1>
  textFont(mainFont, 50);
  fill(240);
  text("Player 2", width-(240), 80);
  // top img
  pushMatrix();
  translate(width-(40+110), 200);
  scale(1.5);
  imageMode(CENTER);
  image(top1.topImg, 0, 0);
  popMatrix();
  // dash gauge
  pushMatrix();
  translate(width-width/10.5, height/2);
  noStroke();
  float percent1 = 0;
  if (top1.coolStartTime < 0) {
    percent1 = 1;
  } else {
    percent1 = (float)(millis() - top1.coolStartTime)/top1.coolTime;
  }
  
  if(top1.isItemOn) {
    fill(color(255*(percent1), 255*percent1, 255*(1-percent1)));
  } else {
    fill(color(240*(1-percent1*0.5), 150*(1-percent1), 240*percent1));
  }
  circle(0, 0, 140*percent1);
  // dash gauge outside
  stroke(0);
  noFill();
  strokeWeight(7);
  circle(0, 0, 140);
  popMatrix();

  String scoreText = String.format("%d : %d", top0.score, top1.score);
  textAlign(CENTER);
  textFont(mainFont, 170);
  fill(color(255, 255, 255, 85));
  text(scoreText, width/2, height/4);
  for (int i = 0; i < top1.heart; i++) {
    image(hImg, width -100-i*60, height - 200);
  }
  
  textFont(mainFont, 20);
  fill(240);
  text("R : go to intro", width-120, height -40);
}


boolean collisionDetect() {
  if (top0.dieStartTime + top0.dieStartTime> 0) return false;
  PVector betweenVec = top0.pos.copy();
  betweenVec.sub(top1.pos);

  return (betweenVec.mag() < top0.topRad + top1.topRad);
}
int itemDetect() {
  if(item == null) return 0;
  PVector betweenVec = top0.pos.copy();
  betweenVec.sub(item.pos);
  if(betweenVec.mag() < top0.topRad) return 1;
  betweenVec = top1.pos.copy();
  betweenVec.sub(item.pos);
  if(betweenVec.mag() < top0.topRad) return 2;
  return 0;
}

void gameUpdate() {
  updateGamePadInput();

  int iddd = itemDetect();
  //collision
  if (collisionDetect()) {
    coliSnd[(int)random(0, 4)].play();
    PVector eachDir = PVector.sub(top1.pos, top0.pos);
    eachDir.normalize();
    float wt0 = PVector.dot(eachDir, top0.vel);
    eachDir.mult(-1);
    float wt1 = PVector.dot(eachDir, top1.vel);
    if (wt0+wt1 > 0) {
      float top0bv = top1.vel.mag() * top0.bounceRelativeRate + top0.bounceBasics;
      float top1bv = top0.vel.mag() * top1.bounceRelativeRate + top1.bounceBasics;
      PVector direct = PVector.sub(top1.vel, top0.vel);
      direct.normalize();

      top0.bounce(PVector.mult(direct, top0bv));
      top1.bounce(PVector.mult(direct, top1bv*-1));
    }
  } else if(iddd >0) {
    if(iddd == 1)
      top0.isItemOn = true;
    else
      top1.isItemOn = true;
    itemSnd.play();
    item = null;
    itemCoolStartTime = millis();
  }
  
  
  if (top0.heart < 1) {
    top1.score++;
    top0.heart = 3;
    top0.reset();
    top1.heart = 3;
    top1.reset();
    startSnd.play();
  } else if (top1.heart < 1) {
    top0.score++;
    top0.heart = 3;
    top0.reset();
    top1.heart = 3;
    top1.reset();
    startSnd.play();
  }
  top0.dirInput(inputP1.x+joyP1.x, inputP1.y+joyP1.y);
  top1.dirInput(inputP2.x+joyP2.x, inputP2.y+joyP2.y);
  
  if(item != null) item.update();
  if(itemCoolStartTime > 0) {
    if (millis() -itemCoolStartTime > itemCoolTime){
      println("asdf");
      itemCoolStartTime = -1;
      item = new Item(centerPos);
    }
  }
  
  top0.update();
  top1.update();
}


void draw() {
  deltaTime = millis() - prevMillis;
  prevMillis = millis();
  if (intro != null) {
    image(i_movie, width/2, height/2, width, height);
    if (i_movie.duration()-1 < i_movie.time()) {
      println(i_movie.duration());
      i_movie.speed(-1);
    } else if ( i_movie.time() < 1) {
      i_movie.speed(1);
    }
    intro.i_draw();
    return;
  }
  uiUpdate();
  gameUpdate();
}
