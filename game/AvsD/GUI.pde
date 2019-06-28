class GUI extends RenderObj implements IUpdate {

  //The lastCP that was lit
  int lastCP = 0;
  //Previous frame this was the last one
  int prevCP = 0;
  //The font we're using to draw the GUI
  PFont mainFont;
  //What color to use
  float effectCol = 0;
  float angle = 0;
  //Blinking timer for the cursor
  int onTime = 0;
  int period = 20;
  
  //The offset that we ease in from
  float offX = 1000;

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
    //Slowly ease back to 0
    if(game.state == GameState.RUN) effectCol *= 0.98;
    else{
      effectCol = sin(angle) * .5 + .5;
      angle += 0.1;
      onTime --;
      if(onTime < -period) onTime = period;
    }
  }

  //Renders all the GUI components
  void render(PGraphics g) {
    if (game.state == GameState.RUN) {
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
      g.fill(getEffectCol(), 200 + effectCol * 55);
      g.text(getEffect(virus.percentage), left + 5, yPos + yInc / 3);
      g.fill(virus.COL_VR);
      g.textSize(12);
      g.text("Controls", left, yPos += yInc);
      g.textSize(10);
      g.fill(virus.COL_VR, 200);
      g.text("[SPACE] to shoot\n[ARROWS] to move", left + 5, yPos + yInc / 3);
    } else if (game.state == GameState.LOST) {
      offX += (-offX) * 0.1;
      if(offX < 2) offX = 0;
      g.translate(offX, 0);
      drawDarkness(g);
      //Draw the gameOVer and name submission screen
      drawLost(g);
    } else if (game.state == GameState.READY) {
      offX += (-offX) * 0.1;
      if(offX < 2) offX = 0;
      g.translate(offX, 0);
      drawDarkness(g);
      //Draw the ready to play overlay, with the highscores
      drawReady(g);
    }
  }
  
  void drawLost(PGraphics g){
    //Background
    g.fill(0);
    g.stroke(virus.COL_VR);
    g.rect(64, 32, g.width - 128, g.height - 64);
    //Title
    g.textSize(22);
    g.fill(virus.COL_VR);
    g.noStroke();
    float offset = g.textWidth("Game Over");
    g.text("Game Over", g.width / 2 - offset / 2, 60);
    //Subtitle
    g.textSize(10);
    g.fill(virus.COL_VR, 200);
    offset = g.textWidth("Type name to register score!");
    g.text("Type name to register score!", g.width / 2 - offset / 2, 80);
    
    g.textSize(18);
    g.fill(virus.COL_GOOD);
    offset = g.textWidth(game.username);
    g.text(game.username, g.width / 2 - offset / 2, 120);
    if(onTime < 0 && game.username.length() < 12){
      g.stroke(getEffectCol());
      g.line(g.width / 2 + offset / 2, 120, g.width / 2 + offset / 2 + 16, 120);
    }
    
    g.textSize(18);
    offset = g.textWidth("Score");
    g.fill(virus.COL_VR);
    g.text("Score", g.width / 2 - offset / 2, 160);
    offset = g.textWidth(game.score + "");
    g.text(game.score, g.width / 2 - offset / 2, 180);
    
    //Cue
    g.textSize(15);
    g.fill(getEffectCol());
    g.noStroke();
    offset = g.textWidth("Press enter to continue");
    g.text("Press enter to continue", g.width / 2 - offset / 2, g.height - 50);
  }

  void drawReady(PGraphics g) {
    //Background
    g.fill(0);
    g.stroke(virus.COL_VR);
    g.rect(64, 32, g.width - 128, g.height - 64);
    //Title
    g.textSize(22);
    g.fill(virus.COL_VR);
    g.noStroke();
    g.text("Analog vs Digital", 74, 60);
    //Subtitle
    g.textSize(10);
    g.fill(virus.COL_VR, 200);
    g.text("Help fight the virus that is taking\nover our world!", 74, 80);
    //Highscores
    g.fill(virus.COL_VR);
    g.textSize(15);
    g.text("Highscores Top 5", 74, 116);
    g.textSize(10);
    g.fill(virus.COL_VR, 220);
    renderTopFive(g);
    //Cue
    g.textSize(17);
    g.fill(getEffectCol());
    g.noStroke();
    g.text("Press any key to start!", 72, g.height - 40);
  }
  
  void renderTopFive(PGraphics g){
    g.pushMatrix();
    g.translate(74, 132);
    float yOff = 18;
    for(int i = 0; i < network.topScores.size(); i++){
      g.text((i + 1), 0, 0);
      g.text(network.topScores.get(i).name, 16, 0);
      g.text(network.topScores.get(i).score, 128, 0);
      g.translate(0, yOff);
    }
    g.popMatrix();
  }

  void drawDarkness(PGraphics g) {
    //Dark overlay to make the focus the popout
    g.fill(0, 200);
    g.noStroke();
    g.rect(-3000, -3000, 6000, 6000);
  }

  color getEffectCol() {
    return lerpColor(virus.COL_VR, virus.COL_GOOD, effectCol);
  }

  //Returns the description of the virus effect
  String getEffect(float perc) {
    perc += 0.1;
    if (perc >= 0.8) return "Screen shake";
    else if (perc >= 0.6) return "Mirror movement";
    else if (perc >= 0.4) return "Noisy Screen";
    else if (perc >= 0.2) return "Slow Shooting";
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
      boolean lit = virus.percentage > (i + .5) * 0.2f;
      g.fill(lit ? virus.COL_VR: virus.COL_GOOD);
      if (lit) lastCP = i + 1;
      g.stroke(virus.COL_VR);
      g.circle((i + .5) * inc + r / 2, r, r);
    }
    if (prevCP != lastCP) {
      prevCP = lastCP;
      if (prevCP == 5) game.gameOver();
      game.setEffect(prevCP);
      //Do a poof
      game.shake(10);
    }
    g.fill(virus.COL_VR);
    g.popMatrix();
  }
}
