class TailNode {
  PVector pos = new PVector();
  float scale, rot;
  TailNode(PVector _pos, float _rot) {
    pos = _pos.copy();
    scale = 1;
    rot = _rot;
  }
}

class Tail {
  ArrayList<TailNode> nodes = new ArrayList<TailNode>();
  PVector prevPos = new PVector();
  PGraphics img;

  Tail(PGraphics _img) {
    img = _img;
  }

  void update(PVector pos, float rot) {
    PVector lenV = PVector.sub(pos, prevPos);
    if (lenV.magSq()>10) {
      nodes.add(new TailNode(pos, rot));
    }
    
    ArrayList<TailNode> removeId = new ArrayList<TailNode>();
    for (TailNode cur : nodes) {
      pushMatrix();
      translate(cur.pos.x, cur.pos.y);
      
      rotate(cur.rot);
      scale(cur.scale); //<>//
      imageMode(CENTER);
      image(img, 0, 0);
      popMatrix();

      cur.scale -= 1.5*1/deltaTime;
      if (cur.scale < 0) {
        removeId.add(cur);
      }
    }
    for(TailNode rm : removeId) {
      nodes.remove(rm);
    }
    prevPos.set(pos);
  }
}
