class GUI extends RenderObj implements IUpdate{
  
  //The font we're using to draw the GUI
  PFont mainFont;
  
  GUI(){
    depth = 100;
    game.renderList.add(this);
    game.updateList.add(this);
  }
  
  //Init code for the GUI
  void init(){
    mainFont = createFont("font.TTF", 12);
    game.g.textFont(mainFont);
  }
  
  //Update all the necessary components
  void update(){
    
  }
  
  //Renders all the GUI components
  void render(PGraphics g){
    float left = virus.W + 64;
    float yPos = 32;
    float yInc = 72;
    g.fill(virus.COL_VR);
    g.text("Score: ", left, yPos);
    g.text(game.score, left, yPos + yInc / 3);
    g.text("Time Left", left + virus.W - 64, yPos);
    g.text(game.timeLeft, left + virus.W - 64, yPos + yInc / 3);
    g.text("Control Points", left, yPos += yInc);
    drawProgress(left, yPos, g);
    g.text("Current effect", left, yPos += yInc);
  }
  
  //Draw the control point progress thingy
  void drawProgress(float x, float y, PGraphics g){
    g.pushMatrix();
    g.translate(x, y);
    float inc = 48;
    float r = 16;
    g.stroke(virus.COL_VR);
    g.strokeWeight(1);
    g.line(r / 2, r, 5 * inc, r);
    g.strokeWeight(4);
    println(virus.percentage);
    g.line(r / 2, r, (5.0f * virus.percentage) * inc, r);
    g.strokeWeight(1);
    for(int i = 0; i < 5; i++){
      g.fill(virus.percentage > (i + .5) * 0.2f ? virus.COL_VR: 0);
      g.stroke(virus.COL_VR);
      g.circle((i + .5) * inc + r / 2, r, r);
    }
    g.popMatrix();
  }
}
