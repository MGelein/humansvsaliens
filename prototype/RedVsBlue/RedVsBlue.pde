final color BLUE = color(0, 0, 200);
final color RED = color(200, 0, 0);
final color GREY = color(200, 200, 200);
final int MAX_CREATURES = 200;

void setup(){
  //A long straight hall, similar to dimensions of expo space
  size(1280, 360);
  
  //Add the controlpoints
  addCP(50, height / 2, Team.Red);//Permanent base
  addCP(width * .25, 50);
  addCP(width * .25, height - 50);
  addCP(width * .5, 50);
  addCP(width * .5, height - 50);
  addCP(width * .75, 50);
  addCP(width * .75, height - 50);
  addCP(width - 50, height / 2, Team.Blue);//Permanent base
}

void draw(){
  //Repaint background
  background(255);
  
  //Update all creatures, then render them
  updateAllCreatures();
  renderAllCreatures();
  
  //Update and Render all controlPoints
  for(ControlPoint cp: controlPoints) cp.update();
  for(ControlPoint cp: controlPoints) cp.render();
  
  //Finally spawn creatures on controlPoints controlled by a team
  handleSpawning();
}

void handleSpawning(){
  spawnTeam(Team.Red);
  spawnTeam(Team.Blue);
}

void updateAllCreatures(){
  for(Creature c: allRed) c.update();
  for(Creature c: allBlue) c.update();
  if(dead.size() > 0){
    for(Creature c: dead){
      allRed.remove(c);
      allBlue.remove(c);
    }
    dead.clear();
  }
}

void renderAllCreatures(){
  for(Creature c: allRed) c.render();
  for(Creature c: allBlue) c.render();
}

//Spawns for a specific team
void spawnTeam(Team t){
  inControl.clear();//Clear the list of bases we control
  for(ControlPoint cp: controlPoints){
    if(cp.team == t) inControl.add(cp);
  }
  //Now that we have a list of valid controlPoints, pick random ones to spawn from
  int toSpawn = canSpawn(t) ? 1 : 0;
  while(toSpawn > 0){
    inControl.get((int) random(inControl.size())).spawn();
    toSpawn--;
  }
}

boolean canSpawn(Team t){
  if(t == Team.Red) return allRed.size() < MAX_CREATURES;
  else if(t == Team.Blue) return allBlue.size() < MAX_CREATURES;
  else return false;
}

//The teams that are in this
enum Team{
  Red, Blue, Neutral
}

enum Role{
  Scout, Fighter
}
