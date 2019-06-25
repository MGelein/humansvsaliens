class Network implements IUpdate{
  //People interval, in frames
  final int PEOPLE_INTERVAL = 30;
  final int PROGRESS_INTERVAL = 6;
  //The amount of frames that have passed
  int frames = 0;
  
  //Initializing the network
  Network(){
    game.updateList.add(this);
  }
  
  //Update the network, this takes care of time management for the people
  void update(){
    frames ++;
    if(frames % PEOPLE_INTERVAL == 0) getPeople();
    if(frames % PROGRESS_INTERVAL == 0) postProgress();
  }
  
  //Posts the progress
  void postProgress(){
    loadStrings("http://localhost:3000/progress/" + virus.percentage);
  }
  
  //Updates the people
  void getPeople(){
    ArrayList<PVector> places = new ArrayList<PVector>();
    String[] lines = loadStrings("http://localhost:3000/people/csv/");
    for(String line: lines){
      if(line.trim().length() < 1) continue;
      String[] parts = line.split(",");
      if(parts.length < 5) continue;
      float x = parseFloat(parts[1]);
      float y = parseFloat(parts[2]);
      places.add(new PVector(x, y));
    }
    salt.addPeople(places);
  }
}
