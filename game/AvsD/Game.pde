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
  }

  //Resets the game-parameters
  void restart() {
    virus.restart();
    timeLeft = 7200;
    score = 0;
  }

  void update() {    
    //Update all the items
    updateList.updateAll();
    //Decrease time left to play
    timeLeft --;
    score += (1 - virus.percentage) * 5 + 1;
  }

  //Render all the graphics of the game to the sub-canvas
  void render() {
    g.beginDraw();
    g.background(0);
    //Render all the items
    renderList.renderAll(g);
    g.endDraw();
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
