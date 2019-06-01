ArrayList<ControlPoint> controlPoints = new ArrayList<ControlPoint>();
ArrayList<ControlPoint> inControl = new ArrayList<ControlPoint>();//List used for spawning mechanics, basically a temp var

final float CAPTURE_R = 30;
final int CAPTURE_LIMIT = 500;

class ControlPoint {
  //Position of this point
  PVector pos = new PVector();
  boolean isBase = false;
  int captureTime = 0;
  boolean captured = false;
  //Which team controlls this control point
  Team team = Team.Neutral;
  //List of nearby creaturess
  ArrayList<Creature> closeCreatures = new ArrayList<Creature>();

  ControlPoint(float x, float y, Team t) {
    pos.x = x;
    pos.y = y;
    team = t;
  }

  void setBase(boolean isBase) {
    this.isBase = isBase;
  }

  //Spawns a single creature
  void spawn() {
    if (team == Team.Red) allRed.add(new Creature(this));
    else if (team == Team.Blue) allBlue.add(new Creature(this));
  }

  //Checks surrounding area for creatures from both teams, and balances its own
  //Color to match
  void update() {
    captureTime = min(max(-CAPTURE_LIMIT, captureTime), CAPTURE_LIMIT);
    closeCreatures.clear();
    for (Creature c : allBlue) if (closeEnough(c)) closeCreatures.add(c);
    for (Creature c : allRed) if (closeEnough(c)) closeCreatures.add(c);
    for (Creature c : closeCreatures) {
      if (c.team != team && captured) {//As soon as someone enters the circle this cp is neutral
        team = Team.Neutral;
        captured = false;
      }

      if (!captured) {
        if (c.team == Team.Red) {
          captureTime += c.capture;
        } else if (c.team == Team.Blue) {
          captureTime -= c.capture;
        }
      }
      if(captureTime > CAPTURE_LIMIT)  setTeam(Team.Red);
      else if(captureTime < -CAPTURE_LIMIT) setTeam(Team.Blue);
    }
  }
  
  void setTeam(Team t){
    if(team == t) return;
    captured = true;
    team = t;
  }

  boolean closeEnough(Creature c) {
    float dx = c.pos.x - pos.x;
    if (dx < - CAPTURE_R || dx > CAPTURE_R) return false;
    float dy = c.pos.y - pos.y;
    if (dy < - CAPTURE_R || dy > CAPTURE_R) return false;
    return sqrt(dx * dx + dy * dy) < CAPTURE_R;
  }

  void render() {
    strokeWeight(captured ? 2 : 5);
    stroke(0, 80);
    fill(team == Team.Red ? RED : team == Team.Blue ? BLUE : GREY);
    circle(pos.x, pos.y, 20);
    fill(255);
    text(captureTime, pos.x, pos.y);
  }
}

void addCP(float x, float y) {
  addCP(x, y, Team.Neutral);
}
void addCP(float x, float y, Team t) {
  controlPoints.add(new ControlPoint(x, y, t));
}
