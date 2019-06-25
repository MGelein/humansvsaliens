class Ship extends RenderObj implements IUpdate{
  PVector pos = new PVector();
  PVector vel = new PVector();
  final float size = 16;
  final float force = 0.2;
  final float maxCharge = 20;
  boolean charging = false;//If we're charging the shooting mechanism
  float charge = 0;
  
  Ship(){
    game.renderList.add(this);
    game.updateList.add(this);
    pos.y = virus.H - size;
    pos.x = virus.W / 2;
  }
  
  //Updating the movement code, and handling keyinput
  void update(){
    pos.add(vel);
    vel.mult(0.95);
    if(pos.x > virus.W - size / 2){
      pos.x = virus.W - size / 2;
      vel.x = 0;
    }else if(pos.x < size / 2){
      pos.x = size / 2;
      vel.x = 0;
    }
    
    //Handles the key-input
    keyInput();
  }
  
  //Handles the key-input
  void keyInput(){
    if(Key.isDown(LEFT)){
      vel.x -= force;
    }else if(Key.isDown(RIGHT)){
      vel.x += force;
    }
    
    //See if we're shooting
    if(Key.isDown(SPACE)){
      charging = true;
      charge += (maxCharge - charge) * 0.005;
    }else{
      //If we release the spacebar, release the charged shot
      if(charging){
        charging = false;
        shoot();
      }
    }
  }
  
  //Shoots a projectile after charging for a bit
  void shoot(){
    
    //Reset the charge after shooting
    charge = 0;
  }
  
  //Renders the ship to the graphics buffer
  void render(PGraphics g){
    g.pushMatrix();
    g.translate(pos.x + 32, pos.y);
    g.fill(virus.COL_GOOD);
    g.triangle(0, -size, size / 2, 0, -size / 2, 0);
    g.triangle(0, size / 3, size / 3, 0, -size / 3, 0);
    g.fill(virus.COL_VR);
    g.circle(0, -size / 3, size / 3);
    g.popMatrix();
    //Draw the charge bar
    drawCharge(g);
  }
  
  //Draws the force charge of the shooting mechanism
  void drawCharge(PGraphics g){
    float buffer = 16;
    float maxH = virus.H - buffer * 2;
    float h = map(charge, 0, maxCharge, 0, maxH);
    //Inner fill
    g.noStroke();
    g.fill(virus.COL_GOOD);
    g.rect(8, virus.H - buffer, 16, -h);
    //Outer edge
    g.noFill();
    g.stroke(virus.COL_VR);
    g.rect(8, buffer, 16, maxH);
    
  }
}
