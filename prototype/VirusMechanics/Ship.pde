class Ship{
  float y = 0;
  float vel = 0;
  float force = 2;
  float buffer = 30;
  float xOff = 0;
  int cooldown = 0;
  final int shootCooldown = 10;
  color shipColor = color(125, 125, 255);
  
  Ship(){
    y = height / 2;
    vel = 0;
  }
  
  void update(){
    cooldown --;
    y += vel;
    if(Key.isDown(UP)){
      vel -= force;
    }
    if(Key.isDown(DOWN)){
      vel += force;
    }
    if(Key.isDown(32)){//SPACE
      if(cooldown <= 0){
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
    bulletManager.bullets.add(new Bullet(this));
    cooldown = shootCooldown;
    xOff = 10;
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
  }
}
