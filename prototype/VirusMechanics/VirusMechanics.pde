final int RESOLUTION = 4;//Size of each 'pixel', only use PO2 values

float[][] cells;

void setup(){
  size(1280, 360);
  cells = new float[width / RESOLUTION][height / RESOLUTION];
  
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[0].length; y++){
      cells[x][y] = random(1);
    }
  }
}

void draw(){
  noStroke();
  //Draw them all
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[0].length; y++){
      fill((1 - cells[x][y]) * 255);
      rect(x * RESOLUTION, y * RESOLUTION, RESOLUTION, RESOLUTION);
    }
  }
  
  //Check them and spread them
  for(int x = 1; x < cells.length - 1; x++){
    for(int y = 1; y < cells[0].length - 1; y++){
      float myVal = cells[x][y];
      float leftVal = cells[x - 1][y];
      float rightVal = cells[x + 1][y];
    }
  }
}
