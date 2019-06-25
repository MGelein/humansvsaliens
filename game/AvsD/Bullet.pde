class Bullet{
  final float force = 10;
  PVector vel;
  PVector pos;
  
  Bullet(Ship parent){
    pos = parent.pos.copy();
    vel = new PVector(0, -force);
  }
}
