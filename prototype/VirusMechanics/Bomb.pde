//This is the surface to draw bomb stuff into
PGraphics bombGraphics;

float getB(int x, int y) {
  return brightness(bombGraphics.pixels[x + y * bombGraphics.width]);
}

void openBomb(){
  bombGraphics.beginDraw();
}

void closeBomb(){
  bombGraphics.endDraw();
}

void updateBomb(){
  bombGraphics.fill(0, 80);
  bombGraphics.rect(0, 0, bombGraphics.width, bombGraphics.height);
}


void initBomb() {
  bombGraphics = createGraphics(width / RESOLUTION, height / RESOLUTION, P2D);
  bombGraphics.beginDraw();
  bombGraphics.background(0);
  bombGraphics.endDraw();
}
