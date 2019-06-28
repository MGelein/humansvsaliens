final int NUM_SCORES = 10;
final String scoreUrl = "http://localhost:3000/scores/top/" + NUM_SCORES + "?csv";
PFont mainFont;
final color virusColor = color(0, 255, 255);
float centerX;
final String title = "Analog vs Digital";
final String highscores = "Highscores";
final String credits = "made by Jordy van Miltenburg Jeroen Offerijns Mees Gelein";

float titleFontSize;
float subtitleFontSize;
float textFontSize;
float creditFontSize;

//List of all the recent scores
ArrayList<Score> scores = new ArrayList<Score>();

void settings(){
  fullScreen();
  noSmooth();
}

//First initialization
void setup() {
  mainFont = createFont("font.TTF", 32);
  textFont(mainFont);
  centerX = width / 2;
  titleFontSize = width / 20;
  subtitleFontSize = titleFontSize * .75;
  textFontSize = titleFontSize * .5;
  creditFontSize = subtitleFontSize * .25;


  //Low framerate, since we don't really need much
  frameRate(15);
  getScores();
}

//Draws at the fps
void draw() {
  background(0);
  fill(virusColor);
  //Draw the header
  textSize(titleFontSize);
  centerTextAt(title, centerX, titleFontSize * 1.1);
  textSize(subtitleFontSize);
  centerTextAt(highscores, centerX, titleFontSize * 2);
  renderScores();
  textSize(creditFontSize);
  centerTextAt(credits, centerX, height - creditFontSize); 

  //Only get the score every two seconds
  if (frameCount % 30 == 0) getScores();
}

//Render the top scores
void renderScores() {
  pushMatrix();
  translate(0, subtitleFontSize * 5);
  int rank = 1;
  int buff = width / 4;
  int buffY = 50;
  centerTextAt("Rank", centerX - buff, 0);
  centerTextAt("Player", centerX, 0);
  centerTextAt("Score", centerX + buff, 0);
  stroke(virusColor);
  strokeWeight(4);
  textSize(textFontSize);
  line(centerX - buff * 1.5, 8, centerX + buff * 1.5, 8);
  translate(0, buffY + 10);
  for (Score s : scores) {
    centerTextAt(rank + "", centerX - buff, 0);
    centerTextAt(s.name, centerX, 0);
    centerTextAt(s.score, centerX + buff, 0);
    rank ++;
    translate(0, buffY);
  }
  popMatrix();
}

//Center text at a position
void centerTextAt(String text, float x, float y) {
  float offX = textWidth(text) / 2;
  text(text, x - offX, y);
}

//Update the scores with the scores obtained from the server
void getScores() {
  String[] lines = loadStrings(scoreUrl);
  scores.clear();
  for (String line : lines) {
    String[] parts = line.split(",");
    if (parts.length < 3) continue;
    Score score = new Score();
    score.name = parts[1];
    score.score = parts[2];
    scores.add(score);
  }

  //Pad with empty scores
  while (scores.size() < NUM_SCORES) {
    scores.add(new Score());
  }
}

class Score {
  String name = "empty";
  String score = "";
}
