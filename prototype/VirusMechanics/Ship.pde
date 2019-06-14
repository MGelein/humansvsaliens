class Ship{
  float y = 0;
  float vel = 0;
  float force = 2;
  float buffer = 30;
  color shipColor = color(125, 125, 255);
  
  Ship(){
    y = height / 2;
    vel = 0;
  }
  
  void update(){
    y += vel;
    if(Key.isDown(UP)){
      vel -= force;
    }
    if(Key.isDown(DOWN)){
      vel += force;
    }
    vel *= 0.9;
    
    float newY = constrain(y, buffer, height - buffer);
    if(y != newY) {
      y = newY;
      vel *= -.6;
    }
  }
  
  void render(){
    fill(shipColor);
    strokeWeight(RESOLUTION);
    stroke(255);
    pushMatrix();
    translate(width - buffer, y);
    beginShape();
    float b = buffer * .5;
    vertex(-b, 0);
    vertex(b, -b);
    vertex(b, b);
    endShape(CLOSE);
    popMatrix();
  }
}

void keyPressed(){
  Key.setState(keyCode, true);
}

void keyReleased(){
  Key.setState(keyCode, false);
}
