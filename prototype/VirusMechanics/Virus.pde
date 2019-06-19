final float INC = 0.01;//Increase or decrease of lifeforce
final float NOISE_A = .6;
final float SPREAD_CTRL = 1.1f;
final color bgColor = color(0);
//final color virusColor = color(255, 50, 0);
final color virusColor = color(0, 255, 255);

//Necessary variables
float[][] cells;
float[][] bombs;
float heartBeatAngle = 0;
float heartBeatSpeed = 0.1;
float heartBeat = 0;
float offNoise = 0;

void virusRender() {
  float virus;
  for (int x = 0; x < cells.length; x++) {
    for (int y = 0; y < cells[0].length; y++) {
      //virus = getB(x, y);
      virus = getC(x, y) - noise(x + offNoise, y) * NOISE_A;
      if (virus < .1) virus -= heartBeat;
      else virus += heartBeat;

      fill(lerpColor(bgColor, virusColor, virus));
      square(x * RESOLUTION, y * RESOLUTION, RESOLUTION);
      if (virus > .1) {
        fill(heartBeat * 300);
        square(x * RESOLUTION, y * RESOLUTION, RESOLUTION);
      }
    }
  }
}

void virusUpdate() {
  bombGraphics.loadPixels();
  for (int x = 0; x < cells.length; x++) {
    for (int y = 0; y < cells[0].length; y++) {
      float myVal = getC(x, y) - getB(x, y);
      float leftVal = getC(x - 1, y);
      if (leftVal < 0.01) setC(x - 1, y, myVal / SPREAD_CTRL);
      float rightVal = getC(x + 1, y);
      if (rightVal < 0.01) setC(x + 1, y, myVal / SPREAD_CTRL);
      float upVal = getC(x, y - 1);
      if (upVal < 0.01) setC(x, y - 1, myVal / SPREAD_CTRL);
      float downVal = getC(x, y + 1);
      if (downVal < 0.01) setC(x, y + 1, myVal / SPREAD_CTRL);
      float avg = (myVal + leftVal + rightVal + upVal + downVal) / 5;
      if (avg >= 1) {//If we're surrounded by only life cells
        myVal -= .05;//Die a little bit
      }
      myVal += (avg - myVal) * random(0.1); //Move a little bit towards the avg
      //If we're strong (>.5) increase lifeforce
      //If we're weak (<.5) decrease lifeforce
      myVal += (myVal > .2) ? INC : -INC;
      myVal = constrain(myVal, -1, 2);
      setC(x, y, myVal);
    }
  }
  bombGraphics.updatePixels();
}

float getC(int x, int y) {
  if (x < 0 || x >= cells.length) return 0;
  else if (y < 0 || y >= cells[0].length) return 0;
  return cells[x][y];
}

void setC(int x, int y, float v) {
  if (x < 0 || x >= cells.length) return;
  else if (y < 0 || y >= cells[0].length) return;
  cells[x][y] = v;
}

float samplePos(PVector p) {
  return getC((int) p.x / RESOLUTION, (int) p.y / RESOLUTION);
}
