// class keeps informations about screen stages and settings
class Window{
  boolean wellcome, play, rules;
  Drawer drawer;
  ControlP5 controlP5;
  RadioButton playerNumRB;
  Button nextBtn, playBtn, rulesBtn, backBtn, kraj;
  String errorMessage;
  Textfield names[];
  int brIgraca;
  Game game;
  StringList playersName;
  PImage img;
  String trebaPravila, briime;
  
  //first we show wellcome screen and get info about game
  Window(ControlP5 _controlP5) {
    wellcome = true;
    play = false;
    rules = false;
    
    controlP5 = _controlP5;
    drawer = new Drawer();
    playersName = new StringList();
    makeControls();
    img = loadImage("slika1.png");
    trebaPravila = "Novi ste u ovoj igri?";
    briime="Odaberite broj igrača!";
  }
  
  // use radio button to get number of players
  // add controls to UI
  void makeControls() {    
    controlP5.setFont(drawer.getControlFont(20));
    drawer.setFont(50, 255);
    playerNumRB = controlP5.addRadioButton("playerNum", width/2 - 20, height/4 + 80)
      .setSize(25, 25);
    playerNumRB.addItem("2", 2);
    playerNumRB.addItem("3", 3);
    playerNumRB.addItem("4", 4);
    playerNumRB.addItem("5", 5);
    playerNumRB.addItem("6", 6);
    
    nextBtn = controlP5.addButton("Potvrdite!")
      .setValue(0)
      .setPosition(width/2 - 80 , height/4+220)  
      .setSize(150, 50);
    playBtn = controlP5.addButton("Zapocnite igru!")
      .setValue(0)
      .setSize(250, 50);
    rulesBtn = controlP5.addButton("Pravila")
      .setValue(0)
      .setPosition(width/2 - 80, height/4+320)  
      .setSize(150, 50);
    backBtn = controlP5.addButton("Natrag")
      .setValue(0)
      .setPosition(width/2 -80, height/4+450)  
      .setSize(150, 50);
    kraj = controlP5.addButton("Završi igru")
      .setValue(0)
      .setPosition(width/2 - 80, height/4+550)
      .setSize(150, 50);
    playBtn.setVisible(false);
    backBtn.setVisible(false);
    brIgraca = 0;
    errorMessage = "";    
  }
  
  // use text boxes to get player names 
   void drawTextFields(){
    for (int i = 0; i < brIgraca; ++i) {
      names[i] = controlP5.addTextfield("Igrac"+(i+1))
        .setPosition(width/2, height/4+80+i*50)
        .setSize(150, 30)
        .setFont(drawer.getControlFont(20));
      names[i].getCaptionLabel().align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER)
        .getStyle().setPaddingLeft(-10);
    }
  }
  
  // draw current stage
  void drawCurrentStage() {
    if (wellcome) {
      image(img, 10, 20, 250, 250);
      drawer.makeText("JAMB", 40, 255, width/2, height/4);
      drawer.makeText(briime, 20, 255, width/2, height/4 + 40);
      drawer.makeText(trebaPravila, 20, 255, width/2, height/4+300);
      drawer.makeText(errorMessage, 20, 0, width/2, height/4 + 400);
    } 
    else if (play) {
      game.DrawGame();
      
    }
    else if(rules){
     String s1 = "Jamb je zabavna igra s kockicama koju moze igrati 2 - 6 igrača.\nIgra se s pet kockica čije se kombinacije upisuju u tablicu.\nKockice se bacaju tri puta te se prije svakog bacanja može fiksirati kockica koju ne želimo bacati. \nRezultati bacanja upisuju u tablicu po posebnom rasporedu.\nU prvi stupac bodovi se upisuju samo od gore prema dolje.\nU drugom stupcu upisuju se samo od dolje prema gore, a u trecem proizvoljno. \nOnaj igrač koji na kraju ima najveću sumu svih rubrika je pobjednik.";
      drawer.makeTextRules(s1, 20, 255, 20, 50);
      drawer.makeTextRules("NAČIN RAČUNANJA BODOVA:", 20, 255, 20, 350);
      String s2 = "1 - 6 = suma jedinica, ... , suma šestica\nMax = što veći mogući zbroj\nMin = što manji mogući zbroj\nTris = tri ista broja (zbroj + 10 bodova)\nSkala = 5 u nizu (40 bodova)\nFull = Par + Tris (zbroj + 30 bodova)\nPoker = četiri ista broja (zbroj + 40 bodova)\nJamb = pet istih brojeva (zbroj + 50 bodova) ";
      drawer.makeTextRules(s2, 20, 255, 20, 380);
    }
  }
  
  // klik na button Next
  void nextButtonClick(){
    kraj.show();
    rulesBtn.hide();
    trebaPravila="";
    for (int i = 0; i < playerNumRB.getArrayValue().length; ++i)
      if (playerNumRB.getArrayValue()[i] == 1)
        brIgraca = i + 2;
          
    if (brIgraca == 0) {
      errorMessage = "Molimo unesite broj igrača!";
      return;
    }
    else {
      errorMessage = "";
      briime="Unesite imena igrača!";
      //drawer.makeText("Unesite imena igrača", 20, 255, width/2, height/4 + 40);
      names = new Textfield[brIgraca];
      drawTextFields();
      removeWellcomeScreen();
      playBtn.setVisible(true);
      playBtn.setPosition(width/2 - 100, height/4+80+ brIgraca*60);
    }
  }
  
  // makni pocetni zaslon
  void removeWellcomeScreen(){
    nextBtn.remove();
    playerNumRB.remove();
  }
  
  void krajButtonClick(){
     exit();

  }
  
  // klik na playButton
  void playButtonClick(){
    for( int i = 0; i < brIgraca; i++ ){
      String s = names[i].getText();
      playersName.append(s);
      println(s);
      names[i].remove();
    }
    
    game = new Game(brIgraca, playersName);
    play=true;
    wellcome=false;
    playBtn.remove();
    kraj.show();
    
  }
  
  // klik na button Pravila
  void rulesButtonClick(){
    rules = true; 
    wellcome = false;
    nextBtn.hide();
    playerNumRB.hide();
    rulesBtn.hide();
    backBtn.setVisible(true);
  
  }
  
  // klik na button Natrag
  void backButtonClick(){
    rules = false; 
    wellcome = true;
    backBtn.hide();
    playerNumRB.show();
    nextBtn.show();
    rulesBtn.show();
  }
  
  // control event
  void controlEvent(ControlEvent theEvent) {
    if (!theEvent.isGroup()) {
      if (theEvent.getController().getName().equals("Potvrdite!")) 
        nextButtonClick();
      else if (theEvent.getController().getName() == "Zapocnite igru!")
        playButtonClick(); 
        
      else if(theEvent.getController().getName() == "Pravila")
        rulesButtonClick();
       
      else if(theEvent.getController().getName() == "Natrag")
        backButtonClick();
        
      else if(theEvent.getController().getName() == "Završi igru")
        krajButtonClick();
      
    }
  }
  
  // ovo mi treba za pritisak tipke, tj za bacanje kockica
  void checkPressedKey(int key) {
    if (play) {
      game.checkPressedKey(key);
    }
  }
  
  // klik misa mi je za vise toga
  void checkMousePressed(){
    
    if(play){
      game.checkOnClick();
  }
  }
}
