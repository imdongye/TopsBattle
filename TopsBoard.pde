class TopsBoard {
  PImage board = null;

  int rad = 200;
  color back;

  TopsBoard(int _rad) {
    rad = _rad;
    board = createImage(rad*2, rad*2, RGB);
    board.loadPixels();
    float centerw = board.width/2;
    float centerh = board.height/2;

    for (int i = 0; i < board.height; i++) {
      for (int j = 0; j < board.width; j++) {
        int loc = j+i*board.width;

        float d = distance(centerw, centerh, j, i);
        if (d <= rad) {
          float tem = map(d, 0, rad, sin(3*PI/2), sin(2*PI));
          float colortem = map(tem, -1, 0, 0, 170);
          back = color(0, colortem, colortem);
          board.pixels[loc] = back;
          for (int k = 0; k*20<=rad; k++) {
            if (rad/20*k <= d && d <= rad/20*k+1) {
              board.pixels[loc] = color(0, colortem-10, colortem-10);
            }
          }
        } else {
          back = color(255);
          board.pixels[loc] = back;
        }
      }
    }
    board.updatePixels();
  }


  void draw() {
    pushMatrix();
    noFill();
    strokeWeight(5);
    stroke(0);
    translate(width/2, height/2);
    imageMode(CENTER);
    image(board, 0, 0);
    circle(0,0,rad*2);
    popMatrix();
  }
  float distance(float cw, float ch, float x, float y) {
    float d;
    float xd, yd;
    yd = (float) pow((y-ch), 2);
    xd = (float) pow((x-cw), 2);
    d = sqrt(yd+xd);
    return d;
  }
}
