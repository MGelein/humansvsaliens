class GUI extends RenderObj implements IUpdate{
  
  GUI(){
    depth = 100;
    game.renderList.add(this);
    game.updateList.add(this);
  }
  
  //Update all the necessary components
  void update(){
    
  }
  
  //Renders all the GUI components
  void render(PGraphics g){
    
  }
}
