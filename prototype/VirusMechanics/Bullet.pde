BulletManager bulletManager = new BulletManager();
class BulletManager{
  ManagedList<Bullet> bullets = new ManagedList<Bullet>();
  
  void update(){
    bullets.update();
    for(Bullet b: bullets.list){
      b.update();
    }
  }
  
  void render(){
    for(Bullet b: bullets.list){
      b.render();
    }
  }
}

class Bullet{
  final float size = 10;
  final color bulletColor = color(0, 125, 255);
  PVector pos;
  final PVector shootForce = new PVector(-30, 0);
  
  Bullet(Ship s){
    pos = new PVector(width - s.buffer, s.y);
  }
  
  void update(){
    pos.add(shootForce);
    //Do any collision after this
    
    if(pos.x < 0){
      bulletManager.bullets.rem(this);
    }
  }
  
  void render(){
    pushMatrix();
    translate(pos.x, pos.y);
    fill(bulletColor);
    stroke(255);
    strokeWeight(RESOLUTION);
    circle(0, 0, size);
    popMatrix();
  }
}
