final int RESOLUTION = 4;//Size of each 'pixel', only use PO2 values
final float INC = 0.01;//Increase or decrease of lifeforce
final float SPREAD_CTRL = 1.2f;

float[][] cells;

void setup(){
  size(1280, 360);
  cells = new float[width / RESOLUTION][height / RESOLUTION];
  
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[0].length; y++){
      cells[x][y] = 0;
    }
  }
}

void draw(){
  noStroke();
  //Draw them all
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[0].length; y++){
      fill((1 - getC(x, y))* 255);
      rect(x * RESOLUTION, y * RESOLUTION, RESOLUTION, RESOLUTION);
    }
  }
  
  //Check them and spread them
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[0].length; y++){
      float myVal = getC(x, y);
      float leftVal = getC(x - 1, y);
      if(leftVal < 0.01) setC(x - 1, y, myVal / SPREAD_CTRL);
      float rightVal = getC(x + 1, y);
      if(rightVal < 0.01) setC(x + 1, y, myVal / SPREAD_CTRL);
      float upVal = getC(x, y - 1);
      if(upVal < 0.01) setC(x, y - 1, myVal / SPREAD_CTRL);
      float downVal = getC(x, y + 1);
      if(downVal < 0.01) setC(x, y + 1, myVal / SPREAD_CTRL);
      float avg = (myVal + leftVal + rightVal + upVal + downVal) / 5;
      if(avg == 1){//If we're surrounded by only life cells
        myVal -= 0.2;
      }
      myVal += (avg - myVal) * random(0.5); //Move a little bit towards the avg
      //If we're strong (>.5) increase lifeforce
      //If we're weak (<.5) decrease lifeforce
      myVal += (myVal > .3) ? INC : -INC;
      myVal = constrain(myVal, -1, 2);
      setC(x, y, myVal);
    }
  }
}

float getC(int x, int y){
  if(x < 0 || x >= cells.length) return 0;
  else if(y < 0 || y >= cells[0].length) return 0;
  return cells[x][y];
}

void setC(int x, int y, float v){
  if(x < 0 || x >= cells.length) return;
  else if(y < 0 || y >= cells[0].length) return;
  cells[x][y] = v;
}

void mousePressed(){
  int mx = (int) (mouseX / RESOLUTION);
  int my = (int) (mouseY / RESOLUTION);
  for(int x = mx - 4; x < mx + 4; x++){
    for(int y = my - 4; y < my + 4; y++){
      setC(x, y, 1);
    }
  }
}
