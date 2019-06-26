class Network implements IUpdate {
  //People interval, in frames
  final int PEOPLE_INTERVAL = 30;
  final int PROGRESS_INTERVAL = 6;
  //The amount of frames that have passed
  int frames = 0;
  //List of score entries
  ScoreEntry[] topFive = new ScoreEntry[5];
  
  //Initializing the network
  Network() {
    game.updateList.add(this);
    getTopFive();
  }

  //Update the network, this takes care of time management for the people
  void update() {
    frames ++;
    //Depdning on gamestate, do network queries
    if (game.state == GameState.RUN) {
      if (frames % PEOPLE_INTERVAL == 0) getPeople();
      if (frames % PROGRESS_INTERVAL == 0) postProgress();
    }
  }
  
  //Requests the latest top five from the API
  void getTopFive(){
    //http://localhost:3000/scores/top/5
    for(int i = 0; i < 5; i++){
      topFive[i] = new ScoreEntry();
    }
  }

  //Post the score to the server
  void postScore(String name, int score) {
    loadStrings("http://localhost:3000/score/" + name + "/" + score);
  }

  //Posts the progress
  void postProgress() {
    loadStrings("http://localhost:3000/progress/" + virus.percentage);
  }

  //Updates the people
  void getPeople() {
    ArrayList<PVector> places = new ArrayList<PVector>();
      String[] lines = loadStrings("http://localhost:3000/people/csv/");
      for (String line : lines) {
        if (line.trim().length() < 1) continue;
        String[] parts = line.split(",");
        if (parts.length < 5) continue;
        float x = parseFloat(parts[1]);
        float y = parseFloat(parts[2]);
        places.add(new PVector(x, y));
      }
      salt.addPeople(places);
  }
}

class ScoreEntry{
  String name = "empty";
  int score = -1;
}
