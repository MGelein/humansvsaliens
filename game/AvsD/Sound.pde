//This class managed bgmusic and soundfx
class SoundManager implements IUpdate {

  //All the different sound files that we can play
  SoundFile shoot;
  SoundFile lost;
  SoundFile waitingMusic;
  float waitVol = 1;
  float waitVolT = 1;
  SoundFile playMusic;
  float playVol = 0;
  float playVolT = 0;
  SoundFile capture;
  SoundFile bleep;
  SoundFile explosion;

  //The max amplitude of any music file
  float musicVol = 0.5;
  float fxVol = 0.5;

  SoundManager() {
    game.updateList.add(this);
  }
  
  //Does the actual loading inside of setup
  void init(){
    waitingMusic = new SoundFile(app, "sound/menumusic.wav");
    playMusic = new SoundFile(app, "sound/background.wav");
    capture = new SoundFile(app, "sound/impact1.wav");
    lost = new SoundFile(app, "sound/impact2.wav");
    bleep = new SoundFile(app, "sound/select.wav");
    explosion = new SoundFile(app, "sound/explosion.wav");
    shoot = new SoundFile(app, "sound/shoot.wav");
    capture.amp(fxVol);
    lost.amp(fxVol);
    bleep.amp(fxVol);
    explosion.amp(fxVol * .4);
    shoot.amp(fxVol * .25);
    
    startMenuMusic();
  }

  void update() {
    waitVol += (waitVolT - waitVol) * .01;
    playVol += (playVolT - playVol) * .01;
    if (playMusic.isPlaying()) {
      playMusic.amp(playVol * musicVol);
      if(playVol < 0.01) {
        playMusic.stop();
        playVol = 0;
      }
    }
    if (waitingMusic.isPlaying()) {
      waitingMusic.amp(waitVol * musicVol);
      if(waitVol < 0.01) {
        waitingMusic.stop();
        waitVol = 0;
      }
    }
  }
  
  void startMenuMusic(){
    lost.play();
    waitVolT = 1;
    if(!waitingMusic.isPlaying()) waitingMusic.loop();
    playVolT = 0;
  }
  
  void startGameMusic(){
    playVolT = 1;
    if(!playMusic.isPlaying()) playMusic.loop();
    waitVolT = 0;
  }
}
