//Contains all the code for the virus class
class Virus extends RenderObj implements IUpdate {
  //The increase, or decrease of life force
  final float INC = 0.01;
  //The amplitude of the noise gen loop
  final float NOISE_A = .6;
  //The closer this factor comes to 1, the faster the virus spreads
  final float SPREAD_CTRL = 1.1f;
  //The color of the background
  final color COL_BG = color(0);
  //The color of the virus
  final color COL_VR = color(0, 255, 255);
  //The color of the heartbeat
  final color COL_WH = color(200, 200, 255);
  //The color that signifies all is good
  final color COL_GOOD = color(0, 255, 100);
  //The color that signifies this is a tracked person
  final color COL_P = color(255, 200, 255);
  //The size of the playing field
  final int W = (int) game.dim.x / 3;
  final int H = (int) game.dim.y;
  float percentage = 0;
  final color[] COL_CACHE = getColCache();

  //All the cells of the playing field that the virus can populate
  float[][] cells;
  //The heartbeat modifier, this increases/decreases the brightness
  float hb = 0;
  //The current angle of the sine of heartBeat
  float hbAngle = 0;
  //The speed of the heartbeat increase
  float hbSpeed = 0.1;
  //Noise offset, added to make the noise values also scroll, to add more movement
  float offNoise = 0;

  //Initializes the virus
  Virus() {
    //Add yourself to the required lists
    game.renderList.add(this);
    game.updateList.add(this);
    //Create the cells array
    cells = new float[W][H];
    restart();
  }

  //Resets the virus state
  void restart() {
    //And initialize it with random values
    for (int x = 0; x < cells.length; x++) {
      for (int y = 0; y < cells[0].length; y++) {
        cells[x][y] = y < 1 ? random(.5) : 0;
      }
    }
  }

  //Updates the virus
  void update() {
    //Increase the heartbeat
    hbAngle += hbSpeed;
    hb = sin(hbAngle) * .1 + .1;
    offNoise -= hbSpeed;
    
    //Only run this code in the actual game
    if(game.state != GameState.RUN) return;

    salt.g.loadPixels();
    int virusPixels = 0;
    for (int x = 0; x < cells.length; x++) {
      for (int y = 0; y < cells[0].length; y++) {
        float myVal = getC(x, y) - salt.getB(x, y);
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
        myVal += (myVal > .2) ? INC : -INC;
        myVal = constrain(myVal, -1, 2);
        setC(x, y, myVal);
        if(myVal > .1) virusPixels ++;
      }
    }
    percentage = (virusPixels / (W * H * 1.0f));
    salt.g.updatePixels();
  }

  //Returns the float at the specified position
  float getC(int x, int y) {
    if (x < 0 || x >= cells.length) return 0;
    else if (y < 0 || y >= cells[0].length) return 0;
    return cells[x][y];
  }

  //Sets the color at the specified position
  void setC(int x, int y, float v) {
    if (x < 0 || x >= cells.length) return;
    else if (y < 0 || y >= cells[0].length) return;
    cells[x][y] = v;
  }

  //Renders the virus to the canvas
  void render(PGraphics g) {
    g.pushMatrix();
    g.translate(32, 0);
    g.noFill();
    g.stroke(COL_VR);
    g.rect(-1, -1, W + 1, H + 2);
    g.noStroke();
    g.loadPixels();
    float virus;
    //Pixelindex
    int pxi = 0;
    color c;
    for (int x = 0; x < cells.length; x++) {
      for (int y = 0; y < cells[0].length; y++) {
        virus = getC(x, y) - noise(x * random(0.9, 1), y + offNoise) * NOISE_A;
        if (virus < .1) virus -= hb;
        else virus += hb;

        pxi = x + 32 + y * (int) game.dim.x;
        c = virus > 0.1 ? lerpColor(getColor(virus), COL_WH, hb) : getColor(virus);
        g.pixels[pxi] = c;
      }
    }
    g.updatePixels();
    g.popMatrix();
  }

  //Returns a color from the color cache
  color getColor(float val) {
    if (val <= 0) return COL_BG;
    else if (val >= 1) return COL_VR;
    else return COL_CACHE[(int) (val * 100)];
  }

  //Cached 100 intermediary colors between the two fading colors to prevent constant interpolation
  color[] getColCache() {
    color[] list = new color[100];
    for (int i = 0; i < list.length; i++) {
      list[i] = lerpColor(COL_BG, COL_VR, (i * 1.0f) / (list.length * 1.0f));
    }
    return list;
  }

  //Returns the virus value at the provided PVector position
  float samplePos(PVector p) {
    return getC((int) p.x, (int) p.y);
  }
}
