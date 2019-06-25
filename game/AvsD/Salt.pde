//Salt is the best anti-virus?
class Salt extends RenderObj implements IUpdate {
  //The list of circles that still need to be drawn
  final ManagedList<ExpCircle> circles = new ManagedList<ExpCircle>();
  //A list of all the people that are visible by the webcam
  final ManagedList<Person> people = new ManagedList<Person>();
  //The graphics that the salt is drawn on
  PGraphics g;

  //Initializes the salt
  void init() {
    depth = 1;
    g = createGraphics(virus.W, virus.H, P2D);
    g.hint(DISABLE_TEXTURE_MIPMAPS);
    ((PGraphicsOpenGL)g).textureSampling(2);
    g.beginDraw();
    g.endDraw();
    game.updateList.add(this);
    game.renderList.add(this);
  }

  //Renders the salt layer on top of the virus
  void render(PGraphics g) {
    //g.image(this.g, 0, 0);
  }

  //Updates this layer
  void update() {
    circles.update();
    people.update();
    g.beginDraw();
    g.fill(0, 50);
    g.rect(-10, -10, g.width + 20, g.height + 20);
    //See if we need to draw any expanding circles
    for (ExpCircle e : circles.list) {
      e.update();
      e.render(g);
    }
    for (Person p : people.list) {
      p.update();
      p.render(g);
    }

    g.endDraw();
  }

  //Returns the brightness of the provided pixel
  float getB(int x, int y) {
    return (g.pixels[x  + y * virus.W] & 0xFF) / 255f;
  }

  //Adds an explosion at the provided position, of the provided size
  void addExplosion(PVector pos, int size) {
    if (size < 10) size = 5;
    int t = 0;
    for (int i = 0; i < size; i++) {
      t++;
      circles.add(new ExpCircle(pos, i, t / 3, size));
    }
  }

  //Adds a person dot to the display
  void addPeople(ArrayList<PVector> places) {
    for(Person p : people.list){
      p.updated = false;
    }
    
    //Try to find a match for all the places
    for(PVector place: places){
      Person match = getClosestPerson(place);
      if(match == null) {
        match = new Person(place);
        people.add(match);
      }
      match.setTarget(place);
    }
    
    
    //Remove any unupdated person
    for(Person p : people.list){
      if(!p.updated) people.rem(p);
    }
  }

  //Finds the closest match to the provided position
  Person getClosestPerson(PVector pos) {
    Person record = null;
    float recordDist = 1234567890;
    for (Person p : people.list) {
      if (p.updated) continue;
      float dist = dist(p.pos.x, p.pos.y, pos.x, pos.y);
      if (dist < recordDist) {
        recordDist = dist;
        record = p;
      }
    }
    if (record != null) record.updated = true;
    return record;
  }
}

//A single person
class Person extends RenderObj implements IUpdate {
  PVector pos;
  PVector tPos;
  boolean updated = false;

  Person(PVector place) {
    pos = new PVector(place.x * virus.W, place.y * virus.H);
  }

  void update() {
    PVector diff = PVector.sub(tPos, pos);
    pos.add(diff.mult(0.1));
  }
  
  //Sets the target to ease towards
  void setTarget(PVector target){
    tPos = target.copy();
  }

  void render(PGraphics g) {
    g.fill(255);
    g.circle(pos.x, pos.y, 16);
  }
}

//A single Explosion circle
class ExpCircle {
  PVector pos;
  float radius = 0;
  int time = 0;
  float maxRadius;

  ExpCircle(PVector position, float r, int t, float maxR) {
    radius = r;
    pos = position.copy();
    time = t;
    maxRadius = maxR;
  }

  void update() {
    time --;
  }

  void render(PGraphics g) {
    if (time > 0) return;
    g.stroke(255, map(radius, 0, maxRadius, 255, 0));
    g.noFill();
    g.circle(pos.x, pos.y, radius);
    //If we have drawn ourselves, remove me
    salt.circles.rem(this);
  }
}
