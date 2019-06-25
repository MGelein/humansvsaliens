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
    g.text("Current effect", left, yPos += yInc);
  }
}
