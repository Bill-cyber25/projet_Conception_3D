/**

affichage de l'extérieur de la pyramide

*/

// ______________________________

// SABLE

int noiseV = 50;

void dessineDesert() {
  noFill();
  noTint();
  noStroke();
  shader(sandShader);
  fill(218, 192, 100);
  for (int i= 0; i < 100; i++) {
    beginShape(QUADS);
    //texture(sable);

    for (int j =0; j < 200; j++) {
      vertex(i*50,     j*50,     noiseV*noise(i, j),     0, 1);
      vertex((i+1)*50, j*50,     noiseV*noise(i+1, j),   1, 1);
      vertex((i+1)*50, (j+1)*50, noiseV*noise(i+1, j+1), 1, 0);
      vertex(i*50,     (j+1)*50, noiseV*noise(i, j+1),   0, 0);
      
    }
    endShape();
  }
  noLights();
  resetShader();
}


// __________________________________

// PYRAMIDE 


// pour afficher que l'extérieur du labyrinthe lorsqu'on le voit pas
void afficheExterieurPyramide() {
  tint(255, 225, 96);
  for (int i=0; i<tabLab.length; i++) {
    push();
    translate(boxSize*i, boxSize*i, boxSize*i);
    afficheExtLab(boxSize, bs2, i);
    pop();
  }
  pyramideTop();
}

private void afficheExtLab(int boxSize, int bs2, int lvl) {
  char[][] lab = tabLab[lvl];
  noStroke();
  
  for (int i=0; i<lab.length; i++) {
    for (int j=0; j<lab[0].length; j++) {
      pushMatrix();
      translate(i*boxSize, j*boxSize);
      
      // mur haut
      if (j==0) {
        beginShape(QUADS);
        texture(mur);
        vertex(-bs2, -bs2, 0, 0, 0);
        vertex(-bs2, -bs2, boxSize, 0, 1);
        vertex(bs2, -bs2, boxSize, 1, 1);
        vertex(bs2, -bs2, 0, 1, 0);
        endShape();
      }
  
      // mur droit
      if (i == lab.length-1) {
        beginShape(QUADS);
        texture(mur);
        vertex(bs2, -bs2, 0, 0, 0);
        vertex(bs2, -bs2, boxSize, 0, 1);
        vertex(bs2, bs2, boxSize, 1, 1);
        vertex(bs2, bs2, 0, 1, 0);
        endShape();
      }
      
      // mur bas
      if (j==lab.length-1) {
        beginShape(QUADS);
        texture(mur);
        vertex(bs2, bs2, 0, 1, 0);
        vertex(bs2, bs2, boxSize, 1, 1);
        vertex(-bs2, bs2, boxSize, 0, 1);
        vertex(-bs2, bs2, 0, 0, 0);
        endShape();
      }
      
      // mur gauche
      if (i==0) {
        beginShape(QUADS);
        texture(mur);
        vertex(-bs2, bs2, 0, 1, 0);
        vertex(-bs2, bs2, boxSize, 1, 1);
        vertex(-bs2, -bs2, boxSize, 0, 1);
        vertex(-bs2, -bs2, 0, 0, 0);
        endShape();
      }
          
      // plafond
      beginShape(QUADS);
      texture(mur);
      vertex(-bs2,  bs2, boxSize, 0, 1);
      vertex( bs2,  bs2, boxSize, 1, 1);
      vertex( bs2, -bs2, boxSize, 1, 0);
      vertex(-bs2, -bs2, boxSize, 0, 0);
      endShape();
          
          
      popMatrix();
    }
  }
}

private void pyramideTop() {
  int nbMax = LAB_SIZE/2 +5;  // le nombre d'étages maximum dans la pyramide
  int nbManq = nbMax - (NB_LAB-1);  // nombre d'étages manquant pour atteindre le sommet
  int nbCasesDernier = LAB_SIZE+10 -(NB_LAB-1)*2 ; // nombre de cases dans le dernier étage
  if (nbManq <= 0) return;
  pushMatrix();
  // on se met au centre du labyrinthe
  translate(boxSize*LAB_SIZE/2.0, boxSize*LAB_SIZE/2.0, boxSize*NB_LAB);
  fill(145, 120, 20);
  int x = nbCasesDernier*boxSize, y = x, z = boxSize*nbManq;
  beginShape(TRIANGLE_STRIP);
  vertex(0, 0, 0);
  vertex(x/2.0, y/2.0, z);
  vertex(x, 0, 0);
  vertex(x/2.0, y/2.0, z);
  vertex(x, y, 0);
  vertex(x/2.0, y/2.0, z);
  vertex(0, y, 0);
  vertex(x/2.0, y/2.0, z);
  vertex(0, 0, 0);
  endShape();
  popMatrix();
}
