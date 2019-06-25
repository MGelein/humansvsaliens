class Bullet extends RenderObj implements IUpdate{
  final float force = 10;
  PVector vel;
  PVector pos;
  float strength = 0;
  
  //Create a new bullet by using the ref of the parent
  Bullet(Ship parent, float power){
    strength = power;
    pos = parent.pos.copy();
    vel = new PVector(0, -force);
    game.renderList.add(this);
  }
  
  //Render yourself
  void render(PGraphics g){
    g.pushMatrix();
    g.translate(32, 0);
    g.fill(virus.COL_GOOD);
    g.noStroke();
    g.circle(pos.x, pos.y, strength);
    g.popMatrix();
  }
  
  //Updates this bullets movement
  void update(){
    pos.add(vel);
    if(pos.y < 0){
      die();
    }
  }
  
  //Adds an explosion on the salt layer, then die
  void explode(){
    die(); 
  }
  
  //Remove yourself from the game
  void die(){
    game.renderList.rem(this);
    game.updateList.rem(this);
  }
}
