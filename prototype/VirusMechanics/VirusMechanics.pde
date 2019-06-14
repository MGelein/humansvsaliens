import processing.net.*;

final int RESOLUTION = 4;//Size of each 'pixel', only use PO2 values
final float INC = 0.01;//Increase or decrease of lifeforce
final float NOISE_A = .6;
final float SPREAD_CTRL = 1.2f;
final color bgColor = color(0);
//final color virusColor = color(255, 50, 0);
final color virusColor = color(0, 255, 255);
PImage banner;

float[][] cells;
float[][] bombs;
float heartBeatAngle = 0;
float heartBeatSpeed = 0.1;
float heartBeat = 0;
float offNoise = 0;

Ship ship;

void setup() {
  size(1280, 512, P3D);
  cells = new float[width / RESOLUTION][height / RESOLUTION];
  bombs = new float[width / RESOLUTION][height / RESOLUTION];

  for (int x = 0; x < cells.length; x++) {
    for (int y = 0; y < cells[0].length; y++) {
      cells[x][y] = x < 1 ? random(.5) : 0;
      bombs[x][y] = 0;
    }
  }
  
  ship = new Ship();

  blendMode(ADD);
  noSmooth();
}

void draw() {
  //Handle the heartBeat
  heartBeatAngle += heartBeatSpeed;
  heartBeat = sin(heartBeatAngle) * .1 + .1;
  offNoise -= heartBeatSpeed;
  ship.update();

  background(0);
  noStroke();
  //Draw them all
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

      //Always decrease the bomb values back to 0
      float val = getB(x, y);
      setB(x, y, val * 0.95);
    }
  }
  
  ship.render();
}

float getB(int x, int y) {
  if (x < 0 || x >= bombs.length) return 0;
  else if (y < 0 || y >= bombs[0].length) return 0;
  return bombs[x][y];
}

float getC(int x, int y) {
  if (x < 0 || x >= cells.length) return 0;
  else if (y < 0 || y >= cells[0].length) return 0;
  return cells[x][y];
}

void setB(int x, int y, float v) {
  if (x < 0 || x >= bombs.length) return;
  else if (y < 0 || y >= bombs[0].length) return;
  bombs[x][y] = v;
}

void setC(int x, int y, float v) {
  if (x < 0 || x >= cells.length) return;
  else if (y < 0 || y >= cells[0].length) return;
  cells[x][y] = v;
}

void mousePressed() {
  int mx = (int) (mouseX / RESOLUTION);
  int my = (int) (mouseY / RESOLUTION);
  for (int x = mx - 2; x < mx + 2; x++) {
    for (int y = my - 2; y < my + 2; y++) {
      setB(x, y, 1);
    }
  }
}
