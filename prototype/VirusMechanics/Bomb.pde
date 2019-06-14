//This is the surface to draw bomb stuff into
PGraphics bombGraphics;

float getB(int x, int y) {
  return red(bombGraphics.pixels[x + y * bombGraphics.width]) / 255;
}
ManagedList<ExpCircle> circles = new ManagedList<ExpCircle>();

void openBomb(){
  bombGraphics.beginDraw();
}

void closeBomb(){
  bombGraphics.endDraw();
}

void updateBomb(){
  circles.update();
  bombGraphics.fill(0, 50);
  bombGraphics.rect(-10, -10, bombGraphics.width + 20, bombGraphics.height + 20);
  //See if we need to draw any expanding circles
  for(ExpCircle e: circles.list){
    e.update();
    e.render(bombGraphics);
  }
}

void initBomb() {
  bombGraphics = createGraphics(width / RESOLUTION, height / RESOLUTION, P2D);
  bombGraphics.noSmooth();
  bombGraphics.beginDraw();
  bombGraphics.background(0);
  bombGraphics.endDraw();
}

void addExplosion(PVector pos, int size){
  if(size < 10) size = 5;
  pos.div(RESOLUTION);
  int t = 0;
  for(int i = 0; i < size; i++){
    t++;
    circles.add(new ExpCircle(pos, i, t / 5, size));
  }
}

class ExpCircle{
  PVector pos;
  float radius = 0;
  int time = 0;
  float maxRadius;
  
  ExpCircle(PVector position, float r, int t, float maxR){
    radius = r;
    pos = position.copy();
    time = t;
    maxRadius = maxR;
  }
  
  void update(){
    time --;
  }
  
  void render(PGraphics g){
    if(time > 0) return;
    g.stroke(255, map(radius, 0, maxRadius, 255, 0));
    g.noFill();
    g.circle(pos.x, pos.y, radius);
    //If we have drawn ourselves, remove me
    circles.rem(this);
  }
}
