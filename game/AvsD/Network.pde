class Network implements IUpdate {
  final String serverURL = "http://192.168.0.100:3000/";
  final String scoresURL = serverURL + "scores/";
  final String progressURL = serverURL + "progress/";
  final String peopleURL = serverURL + "people/csv/";
  final String topURL = scoresURL + "top/5?csv";
  //People interval, in frames
  final int PEOPLE_INTERVAL = 30;
  final int PROGRESS_INTERVAL = 6;
  //The amount of frames that have passed
  int frames = 0;
  //List of score entries
  ArrayList<Score> topScores = new ArrayList<Score>();
  
  //Initializing the network
  Network() {
    game.updateList.add(this);
  }
  
  void init(){
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
    String[] lines = loadStrings(topURL);
    topScores.clear();
    for(String line: lines){
      Score s = new Score();
      String[] parts = line.split(",");
      if(parts.length < 3) continue;
      s.name = parts[1];
      s.score = parts[2];
      topScores.add(s);
    }
    
    //Pad it to the correct size
    while(topScores.size() < 5){
      topScores.add(new Score());
    }
  }

  //Post the score to the server
  void postScore(String name, int score) {
    loadStrings(scoresURL + name + "/" + score);
  }

  //Posts the progress
  void postProgress() {
    loadStrings(progressURL + virus.percentage);
  }

  //Updates the people
  void getPeople() {
    ArrayList<PVector> places = new ArrayList<PVector>();
      String[] lines = loadStrings(peopleURL);
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

class Score{
  String name = "empty";
  String score = "";
}
