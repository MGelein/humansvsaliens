import processing.net.*;

final int RESOLUTION = 4;//Size of each 'pixel', only use PO2 values

//The ship the player controls
Ship ship;

void setup() {
  size(1280, 512, P2D);
  cells = new float[width / RESOLUTION][height / RESOLUTION];
  
  initBomb();

  for (int x = 0; x < cells.length; x++) {
    for (int y = 0; y < cells[0].length; y++) {
      cells[x][y] = x < 1 ? random(.5) : 0;
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
  
  //Do all the updates
  openBomb();
  updateBomb();
  virusUpdate();
  ship.update();
  bulletManager.update();
  closeBomb();

  //Do all the rendering
  background(0);
  noStroke();
  virusRender();
  ship.render();
  bulletManager.render();
    
  //Uncomment to show the debug 'bomb' overlay
  //image(bombGraphics, 0, 0, width, height);
}

void keyPressed() {
  Key.setState(keyCode, true);
}

void keyReleased() {
  Key.setState(keyCode, false);
}
