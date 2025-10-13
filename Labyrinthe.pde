final int LAB_SIZE = 21;
final int NB_LAB = 12;  // 15 max

char tabLab [][][] = new char[NB_LAB][][];
char tabSides [][][][] = new char[NB_LAB][][][];
int boxSize, bs2;  //doit être final mais compilateur veut pas pcq initialisé dans une fonction

PImage mur, sable;
PShader sandShader;

void setup() {
  sandShader = loadShader("shaders/myFragmentShader.glsl", "shaders/myVertexShader.glsl");
  frameRate(20);
  randomSeed(2);
  size(600, 600, P3D);
  
  mur = loadImage("stones.jpg");
  sable = loadImage("sable.jpg");
  textureMode(NORMAL);

  tabLab = initTabLab();
  tabSides = initSides(tabLab);
  
  setupCurrentLevel();

  boxSize = min(width/LAB_SIZE, height/LAB_SIZE);
  if (boxSize%2 == 1) boxSize--;  // toujours pair
  bs2 = boxSize/2; 

}

int level = 0;
char[][] labyrinthe = tabLab[level];
char[][][] sides = tabSides[level];

boolean cameraShift = false, noMomie = false, noClip = false; // pour débug

boolean isOutside = true, ecranTitre = true;
boolean hasLost = false, hasWon = false;

void draw() {
  background(154, 219, 241);

  translate(bs2, bs2);
  
  if (momX == posX && momY == posY && !noMomie) gameOver();

  if (hasLost) afficheGameOver();
  else if (hasWon) afficheYouWon();
  else if (isOutside) { 
    drawOutside();
    ecranTitre(ecranTitre);
  }
  else {
    drawInside();
  }
}



void drawInside() {
  float x = boxSize*(posX);
  float y = boxSize*(posY);
  float xAnim = boxSize*  dirXA*(anim/float(tmpAnim));
  float yAnim = boxSize*  dirYA*(anim/float(tmpAnim));
  float zAnim = -bs2/2.0*sin(anim/float(tmpAnim)*2*PI)/3.0;

  float z = bs2 + zAnim;

  if (cameraShift)
    camera(0, 0, boxSize*30,
      boxSize*posX, boxSize*posY, 0,
      0, 0, -1);
  else
    camera(x - xAnim, y - yAnim, z,
      x + boxSize*dirX, y + boxSize*dirY, z,
      0, 0, -1);
  perspective(PI/4., 1.5, 1, boxSize*labyrinthe.length*2);
  
  noLights();
  lightFalloff(0.0, 0.01, 0.0001);
  pointLight(128, 128, 128, (x-xAnim), (y-yAnim), boxSize);

  if (anim>0) anim--;

  afficheLabyrinthe(boxSize, bs2, currentVision(labyrinthe), level);
  
  afficheMomie(boxSize);
  if (!noMomie) deplaceMomie(labyrinthe, posX, posY); 
  
  updateHasSeen(currentVision(labyrinthe));
  afficheMiniMap(x-xAnim, y-yAnim);
  
  if (transitionNiveau && anim <= 0) setupNiveauSuivant(); 
}



void drawOutside() {
  /*
  camera(posX*boxSize + boxSize/2 -boxSize*400, posY*boxSize + boxSize/2-200, boxSize*10,
   width/2, height/2, 0, // c'est le point qu'on fixe
    0.0, 0.0, -1.0); */
  camera(-boxSize*LAB_SIZE, -boxSize*LAB_SIZE,   boxSize*LAB_SIZE/3.0,
         width/2.0, height/2.0, boxSize*LAB_SIZE/2.0,
         0, 0, -1);
  perspective();
  
  lights();
  translate(boxSize*LAB_SIZE/2.0, boxSize*LAB_SIZE/2.0, 0);
  rotateZ(PI*frameCount/256.0);
  translate(-boxSize*LAB_SIZE/2.0, -boxSize*LAB_SIZE/2.0, 0);
  rotateZ(PI/8.0);
  
  pushMatrix();
  translate(width/2.0, height/2.0);
  translate(-50*100/2,-50*100/2,0);
  dessineDesert();
  popMatrix();
  
  translate(-boxSize/2.0, -boxSize/2.0, boxSize);
  scale(1, 1, 1+1/3.0);
  afficheExterieurPyramide();
}


//_______________________________

// CHANGEMENT DE NIVEAU

boolean transitionNiveau = false;


void setupNiveauSuivant() {
  transitionNiveau = false;
  level++;
  if (level >= NB_LAB) {
    hasWon = true;
    return;
  } 
  setupCurrentLevel();
}

void setupCurrentLevel() {
  labyrinthe = tabLab[level];
  sides = tabSides[level];
  
  resetJoueurPos(labyrinthe);
  
  setPositionMomie(labyrinthe, labyrinthe.length/2, labyrinthe[0].length/2);
  setMaxTimerMoveMomie(40);
  
  resetHasSeenHasBeen(labyrinthe);
}



//______________________________

//TITLE SCREEN / ECRAN TITRE

void ecranTitre(boolean ecranTitre) {
  camera();
  perspective();
  fill(100, 64, 0);
  float x = width/20.0;
  float zEnter = x*7;
  if (ecranTitre) {  // affiche par le titre & les crédits si on est seulement en pause
    textSize(width/8.0);
    textAlign(LEFT, TOP);
    text("PYRAMIDE", x-5, x/2.0);
    textSize(width/16.0);
    text("Projet IGSD", x, x*3.2);
    textSize(width/24.0);
    text("par Emilie FESQUET et Bilguissou DIALLO", x, x*4.5); 
  } 
  else {
    textSize(width/16.0);
    text("PAUSE", x, x);
    zEnter = x*4;
  }
  if ((frameCount/10)%2 == 1) {  // Press Enter clignote
    textSize(width/20.0);
    text("Press Enter", x, zEnter); 
  }
}


//______________________________

//VICTORY / YOU WON

void afficheYouWon() {
  //background(64, 200, 255);
  fill(255, 255, 64);
  textSize(width/6.0);
  textAlign(CENTER);
  text("You won :)", width/2.0, height/2.0);
}



//______________________________

//GAME OVER

private int mercyFrames = 5; 

void gameOver() {
  mercyFrames--;
  if (mercyFrames == 0) hasLost = true;
}

void afficheGameOver() {
  background(0);
  fill(255, 64, 64);
  textSize(width/6.0);
  textAlign(CENTER);
  text("You lost :(", width/2.0, height/2.0);
}
