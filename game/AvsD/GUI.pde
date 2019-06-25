class GUI extends RenderObj implements IUpdate {

  //The font we're using to draw the GUI
  PFont mainFont;

  GUI() {
    depth = 100;
    game.renderList.add(this);
    game.updateList.add(this);
  }

  //Init code for the GUI
  void init() {
    mainFont = createFont("font.TTF", 12);
    game.g.textFont(mainFont);
  }

  //Update all the necessary components
  void update() {
  }

  //Renders all the GUI components
  void render(PGraphics g) {
    float left = virus.W + 64;
    float yPos = 32;
    float yInc = 64;
    g.fill(virus.COL_VR);
    g.textSize(12);
    g.text("Score: ", left, yPos);
    g.text(game.score, left, yPos + yInc / 3);
    g.text("Time Left", left + virus.W - 64, yPos);
    g.text(game.timeLeft, left + virus.W - 64, yPos + yInc / 3);
    g.text("Control Points", left, yPos += yInc);
    drawProgress(left, yPos, g);
    g.text("Current effect", left, yPos += yInc);
    g.textSize(10);
    g.fill(virus.COL_VR, 200);
    g.textSize(12);
    g.text(getEffect(virus.percentage), left + 5, yPos + yInc / 3);
    g.fill(virus.COL_VR);
    g.text("Controls", left, yPos += yInc);
    g.textSize(10);
    g.fill(virus.COL_VR, 200);
    g.text("[SPACE] to shoot\n[ARROWS] to move", left + 5, yPos + yInc / 3);
  }
  
  //Returns the description of the virus effect
  String getEffect(float perc){
    perc += 0.1;
    if(perc >= 0.8) return "Screen shake";
    else if(perc >= 0.6) return "Mirror movement";
    else if(perc >= 0.4) return "Noisy Screen";
    else if(perc >= 0.2) return "Slow Shooting";
    else return "None";
  }

  //Draw the control point progress thingy
  void drawProgress(float x, float y, PGraphics g) {
    g.pushMatrix();
    g.translate(x, y);
    float inc = 48;
    float r = 16;
    g.stroke(virus.COL_VR);
    g.strokeWeight(1);
    g.line(r / 2, r, 5 * inc, r);
    g.strokeWeight(4);
    g.line(r / 2, r, (5.0f * virus.percentage) * inc, r);
    g.strokeWeight(1);
    for (int i = 0; i < 5; i++) {
      g.fill(virus.percentage > (i + .5) * 0.2f ? virus.COL_VR: virus.COL_GOOD);
      g.stroke(virus.COL_VR);
      g.circle((i + .5) * inc + r / 2, r, r);
    }
    g.fill(virus.COL_VR);
    g.popMatrix();
  }
}
