class Game {
  //The list of renderables
  final RenderList renderList = new RenderList();
  //The list of update-ables
  final UpdateList updateList = new UpdateList();
  //The internal dimensions of the playing field
  final PVector dim = new PVector(480, 280);
  //The sub-canvas we're rendering on
  PGraphics g;
  //The amount of frames we're allowed to play
  int timeLeft = 7200;
  //The score we've accumulated so far
  int score = 0;
  //The gamestates our game can be in
  GameState state = GameState.READY;
  //Used for screenshake
  PVector offset = new PVector();
  PVector vel = new PVector();
  
  //The username of the last user
  String username = "player";
  
  //The effect booleans
  boolean noisyScreen = false;
  boolean mirrorMovement = false;
  boolean slowShooting = false;
  boolean shakyScreen = false;

  void init() {
    salt.init();
    //Initialize the canvas
    g = createGraphics((int) dim.x, (int) dim.y, P2D);
    hint(DISABLE_TEXTURE_MIPMAPS);
    ((PGraphicsOpenGL)g).textureSampling(2);
    g.beginDraw();
    g.rect(0, 0, 1000, 100);
    g.endDraw();
    //Init the gui
    gui.init();
    //Init the sounds
    soundManager.init();
  }

  //Resets the game-parameters
  void restart() {
    soundManager.startGameMusic();
    virus.restart();
    timeLeft = 7200;
    score = 0;
    game.state = GameState.RUN;
  }
  
  //Starts the submission process and makes the game ready for more play
  void submitScore(){
    game.state = GameState.READY;
    gui.offX = 1000;
    network.postScore(game.username, game.score);
  }

  void update() {    
    //Update all the items
    updateList.updateAll();
    //Decrease time left to play
    if(game.state == GameState.RUN) {
      timeLeft --;
      score += (1 - virus.percentage) * 5 + 1;
      
      if(shakyScreen) shake(2);
    }
    
    offset.add(vel);
    vel.mult(0.8);
    vel.add(offset.copy().rotate(PI).mult(0.8));
    offset.mult(0.9);
    //Stop shaking after a while
    if(offset.magSq() < 1) offset.set(0, 0);
  }
  
  //Shakes the game with a specified amount of force
  void shake(float force){
    vel.add((PVector.random2D()).mult(force));
  }

  //Render all the graphics of the game to the sub-canvas
  void render() {
    g.beginDraw();
    g.background(0);
    //Render all the items
    renderList.renderAll(g);
    if(noisyScreen) makeNoise(g);
    g.endDraw();
  }
  
  //Make a bit of static
  void makeNoise(PGraphics g){
    int i1, i2, max = g.pixels.length;
    for(int count = 0; count < max; count ++){
      i1 = (int) random(0, max);
      i2 = (int) random(0, max);
      g.pixels[i1] = g.pixels[i2];
    }
  }
  
  //Sets the currently active effect
  void setEffect(int num){
    soundManager.capture.play();
    gui.effectCol = 1;
    slowShooting = mirrorMovement = noisyScreen = shakyScreen = false;
    if(num == 1) slowShooting = true;
    else if(num == 3) mirrorMovement = true;
    else if(num == 2) noisyScreen = true;
    else if(num == 4) shakyScreen = true;
  }
  
  //Called when the game is done
  void gameOver(){
    state = GameState.LOST;
    soundManager.startMenuMusic();
  }
  
  //Sent whenver we type in the lost screen
  void typeKey(String letter, int keyCode){
    letter = letter.toLowerCase();
    String allowed = "abcdefghijklmnopqrstuvwxyz1234567890 ";
    if(allowed.indexOf(letter) == -1){
      if(keyCode == 8 && username.length() > 0) {
        username = username.substring(0, username.length() - 1);
      }
    }else{
      if(game.username.length() < 12) username += letter;
    }
  }
}

class RenderList extends ManagedList<RenderObj> {
  //Renders all the items in this list
  void renderAll(PGraphics g) {
    //Sort the renderlist on depth
    list.sort(new Comparator<RenderObj>() {
      public int compare(RenderObj a, RenderObj b) {
        return a.depth - b.depth;
      }
    }
    );
    for (RenderObj r : list) {//list is a member of the managedList superclass
      r.render(g);
    }
    //Update the list, do maintenance, remove and add items
    update();
  }
}

class UpdateList extends ManagedList<IUpdate> {
  //Updates all the items in this list
  void updateAll() {
    for (IUpdate u : list) {//list is a member of the managedList superclass
      u.update();
    }
    //Update the list, do maintenance, remove and add items
    update();
  }
}

enum GameState{
  RUN, LOST, READY
}
