PFont mainFont;
final color virusColor = color(0, 255, 255);
float centerX;
final String title = "Analog vs Digital";
float titleX;
final String highscores = "Highscores";

//First initialization
void setup(){
  size(1280, 720);
  mainFont = createFont("font.TTF", 64);
  textFont(mainFont);
  centerX = width / 2;
  titleX = textWidth(title) / 2;
  
  //Low framerate, since we don't really need much
  frameRate(15);
}

//Draws at the fps
void draw(){
  background(0);
  fill(virusColor);
  //Draw the header
  text(title, centerX - titleX, 70);
}
