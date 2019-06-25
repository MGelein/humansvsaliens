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
  void render(PGraphics g){
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
    for(Person p: people.list){
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
      circles.add(new ExpCircle(pos, i, t / 5, size));
    }
  }
  
  //Adds a person dot to the display
  void addPeople(ArrayList<PVector> places){
    people.list.clear();
     for(int i = 0; i < places.size(); i++){
       people.add(new Person(places.get(i)));
     }
  }
}

//A single person
class Person extends RenderObj implements IUpdate{
  PVector pos;
  PVector tPos;
  
  Person(PVector place){
    pos = new PVector(place.x * virus.W, place.y * virus.H);
  }
  
  void update(){
    
  }
  
  void render(PGraphics g){
    g.fill(255);
    g.circle(pos.x, pos.y, 10);
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
