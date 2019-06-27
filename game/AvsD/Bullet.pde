class Bullet extends RenderObj implements IUpdate{
  final float force = 10;
  //Threshold before we explode
  final float threshold = 0.6;
  PVector vel;
  PVector pos;
  float strength = 0;
  
  //Create a new bullet by using the ref of the parent
  Bullet(Ship parent, float power){
    strength = power;
    pos = parent.pos.copy();
    vel = new PVector(0, -force * random(0.95, 1.05));
    if(game.slowShooting) vel.mult(0.3);
    game.renderList.add(this);
  }
  
  //Render yourself
  void render(PGraphics g){
    g.pushMatrix();
    g.translate(32, 0);
    g.fill(virus.COL_GOOD);
    if(vel.mag() > 7) g.noStroke();
    else g.stroke(virus.COL_VR);
    g.circle(pos.x, pos.y, strength);
    g.popMatrix();
  }
  
  //Updates this bullets movement
  void update(){
    pos.add(vel);
    if(pos.y < 0){
      die();
    }
    //Check if we collide with a full virus cell
    if(virus.getC((int) pos.x, (int) pos.y) > threshold){
      explode();
    }
  }
  
  //Adds an explosion on the salt layer, then die
  void explode(){
    soundManager.explosion.stop();
    soundManager.explosion.play();
    salt.addExplosion(pos, (int) (strength * 2.5));
    game.score += (int) strength * 2.5;
    die(); 
  }
  
  //Remove yourself from the game
  void die(){
    game.renderList.rem(this);
    game.updateList.rem(this);
  }
}
