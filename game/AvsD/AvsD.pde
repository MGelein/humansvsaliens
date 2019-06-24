//Java util is necessary for sorting of arraylists
import java.util.*;

//The global game variable. This contains the game-manager
final Game game = new Game();
final Virus virus = new Virus();
final Salt salt = new Salt();
final GUI gui = new GUI();

//Handles the initialization of the game
void setup(){
  //Set the current window size. For testing, otherwise fullscreen
  fullScreen(P2D);
  //size(960, 540, P2D);
  //Initialize the game, start loading assets, etc
  game.init();
  //Don't do any smoothing to textures
  noSmooth();
}

//Renders and updates the game in the main loop
void draw(){
  //Update your state
  game.update();
  //Render to your own canvas
  game.render();
  //Render the game canvas and stretch it to the correct size
  image(game.g, 0, 0, width, height);
  //Draw the game-fps to the screen
  fill(virus.COL_VR, 100);
  text(((int) frameRate) + " fps", 5, 15);
}

//Handles keyPressed events and forwards to the Key manager
void keyPressed(){
  Key.setState(keyCode, true);
}

//Handles keyReleased events and forwards to the Key manager
void keyReleased(){
  Key.setState(keyCode, false);
}


//Interface that says you can update
interface IUpdate {
  void update();
}

//Interface that says you can be rendered using a supplied canvas
abstract class RenderObj {
  int depth = 0;
  abstract void render(PGraphics g);
}
