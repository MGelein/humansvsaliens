final float WANDER_ANGLE = QUARTER_PI;
ArrayList<Creature> allRed = new ArrayList<Creature>();
ArrayList<Creature> allBlue = new ArrayList<Creature>();
ArrayList<Creature> dead = new ArrayList<Creature>();
class Creature {
  Role role;
  final float maxForce = .3;
  final float seekForce = 1;
  final float avoidForce = .5;
  final float wanderForce = .5;
  PVector pos = new PVector();
  PVector acc = new PVector();
  PVector vel = new PVector();
  float health = 100;
  float radius = 10;
  float attack = 0;//Attack force
  float capture = 0;//Capture force
  Team team = Team.Neutral;//Neutral creatures don't exist

  //A creature is created from a controlpoint
  Creature(ControlPoint p) {
    pos.set(p.pos);
    vel = PVector.random2D();
    team = p.team;
    getRole();
  }

  void getRole() {
    role = (random(1) < .5) ? Role.Scout : Role.Fighter;
    radius = (role == Role.Scout) ? 8 : 12;
    //Now depending on role set stats
    attack = (role == Role.Scout) ? 1 : 2;
    capture = (role == Role.Scout) ? 2 : 1;
  }

  void update() {
    //Friction and limit acceleration
    acc.limit(maxForce);
    vel.mult(0.9);

    //Apply all forces and velocities
    pos.add(vel);
    vel.add(acc);
    acc.set(0, 0);

    doBehaviour();
    
    if(health < 1){//Remove if we have 0 or less hp
      dead.add(this);
    }
  }

  //Depending on role, do a thing
  void doBehaviour() {
    //Every creature wanders a bit
    wander();
    if (role == Role.Fighter) {
      //And seeks closest enemy
      Creature enemy = getClosestEnemy(this);
      if (enemy != null) {
        seek(enemy.pos);
        if(dist(enemy.pos.x, enemy.pos.y, pos.x, pos.y) < radius){//If we hit an enemy
          enemy.health -= attack;//Do damage
        }
      }
    }else if(role == Role.Scout){
      //Seek the closest CP
      ControlPoint cp = getClosestEnemyCP(this);
      if(cp != null){
        seek(cp.pos);
      }
    }
  }

  void wander() {
    PVector newDir = vel.copy();
    newDir.rotate(random(-WANDER_ANGLE, WANDER_ANGLE)).setMag(wanderForce);
    acc.add(newDir);
  }

  void seek(PVector p) {
    PVector diff = PVector.sub(p, pos);
    if (diff.mag() > seekForce) diff.setMag(seekForce);
    acc.add(diff);
  }

  void avoid(PVector p) {
    PVector diff = PVector.sub(pos, p);
    diff.setMag(avoidForce);
    acc.add(diff);
  }

  void render() {
    noStroke();
    fill(team == Team.Red ? RED : team == Team.Blue ? BLUE : GREY);
    circle(pos.x, pos.y, radius);
  }
}

ControlPoint getClosestEnemyCP(Creature self){
  float record = 123456789;
  ControlPoint recordHolder = null;
  for(ControlPoint cp : controlPoints){
    if(cp.team == self.team) continue;
    float d = dist(self.pos.x, self.pos.y, cp.pos.x, cp.pos.y);
    if(d < record){
      record = d;
      recordHolder = cp;
    }
  }
  return recordHolder;
}

//Returns the closest enemey
Creature getClosestEnemy(Creature self) {
  ArrayList<Creature> enemyList;
  if (self.team == Team.Red) enemyList = allBlue;
  else if (self.team == Team.Blue) enemyList = allRed;
  else return null;//No proper team, ignore request

  float record = 12345678;
  Creature recordHolder = null;
  for (Creature c : enemyList) {
    float d = dist(self.pos.x, self.pos.y, c.pos.x, c.pos.y);
    if (d < record) {
      record = d;
      recordHolder = c;
    }
  }
  //Now that we have a record holder, return him
  return recordHolder;
}
