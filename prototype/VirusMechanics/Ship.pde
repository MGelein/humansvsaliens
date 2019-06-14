class Ship{
  final float MAX_BULLET_SIZE = 50;
  float y = 0;
  float vel = 0;
  float force = 2;
  float buffer = 30;
  float xOff = 0;
  float chargeUp = 0;
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
    if(Key.isDown(32)){//SPACE
      chargeUp += (MAX_BULLET_SIZE - chargeUp) * 0.01;
      if(chargeUp >= MAX_BULLET_SIZE) {
        shoot();
        Key.setState(32, false);//Unpress the spacebar
      }
    }else{
      if(chargeUp > 0){
        shoot();
      }
    }
    vel *= 0.9;
    xOff *= 0.8;
    
    float newY = constrain(y, buffer, height - buffer);
    if(y != newY) {
      y = newY;
      vel *= -.6;
    }
  }
  
  void shoot(){
    bulletManager.bullets.add(new Bullet(this, chargeUp));
    xOff = chargeUp * .1;
    chargeUp = 0;
  }
  
  void render(){
    fill(shipColor);
    strokeWeight(RESOLUTION);
    stroke(255);
    pushMatrix();
    translate(width - buffer + xOff, y);
    beginShape();
    float b = buffer * .5;
    vertex(-b, 0);
    vertex(b, -b);
    vertex(b, b);
    endShape(CLOSE);
    popMatrix();
    
    //Draw the charge meter
    noStroke();
    rect(width - RESOLUTION, height, RESOLUTION, map(chargeUp, 0, MAX_BULLET_SIZE, 0, -height));
  }
}
