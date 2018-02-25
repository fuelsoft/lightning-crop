PImage bg;
PImage newBG;
PImage output;
int boxScale = 50;
int ratioSelect = 5;
int[] selectionCorners;
float ratio;
String friendlyRatio = "1x1";
int displayMode = 1;
boolean showRatio = true;
String filename;
boolean warned = false;

void setup() {
  size(480, 360);
  surface.setResizable(true);
  delay(200);
  selectInput("Select an image to work with...", "filepicked");
  noCursor();
  ratio = 1f;
  textFont(loadFont("Arial-BoldMT-30.vlw"));
  noLoop();
}

void filepicked(File selection){
  noLoop();
  if(selection == null) {
    loop();
    return;
  }
  else {
    filename = selection.getName().substring(0, selection.getName().lastIndexOf(".")); //used in IDing saved clippings
    bg = loadImage(selection.getAbsolutePath());
    newBG = bg.get();
    //println(filename);
    if (displayWidth <= (bg.width + 50) || displayHeight <= (bg.height + 50)){
      //print("image too large ");
      if ((bg.width/(float) bg.height) > (displayWidth/(float) displayHeight)) { //image is too wide
      //println("in width ("+bg.width+" <-> "+displayWidth+"), trying to resize to "+(displayWidth/2));
        newBG.resize((displayWidth/2), 0);
      }
      else { //image too tall
       //println("in height ("+bg.height+" <-> "+displayHeight+"), trying to resize to "+(displayHeight/2));
       newBG.resize(0, (displayHeight/2));
      }
      //println("image resized");
    }
    //println("size set to "+newBG.width+" x "+newBG.height);
    surface.setSize(newBG.width, newBG.height);
    delay(20);
  }
  loop();
}

void draw() {
  if (newBG != null) {
    try {
      background(newBG);
    } catch (Exception e) {
      sysprint("FATAL", "Window could not be scaled to match image size! (Too big/small for OS to handle?)");
      exit();
    }
  }
  else {
    background(127);
  }
  if (displayMode < 2){
    noStroke();
  }
  boxInit();
  if(displayMode > 0){
    //sides
    shading(selectionCorners[0], selectionCorners[1], -1, selectionCorners[3]); //left
    shading(selectionCorners[2], selectionCorners[1], width+1, selectionCorners[3]); //right
    shading(selectionCorners[0], selectionCorners[1], selectionCorners[2], -1); //top
    shading(selectionCorners[0], selectionCorners[3], selectionCorners[2], height+1); //bottom
    //corners
    shading(selectionCorners[0], selectionCorners[1], -1, -1); //top left
    shading(selectionCorners[2], selectionCorners[1], width+1, -1); //top right
    shading(selectionCorners[0], selectionCorners[3], -1, height+1); //bottom left
    shading(selectionCorners[2], selectionCorners[3], width+1, height+1); //bottom right
  }
  //bounding boxes
  else {
    box(3, 0); //black
  }
  box(1, 255); //white
  if (showRatio){
    drawText(friendlyRatio);
  }
}

void boxInit() {
  float HScaleRatio = boxScale * ratio;
  selectionCorners = setCorners(mouseX-((int) HScaleRatio), mouseY-((int) boxScale), mouseX+((int) HScaleRatio), mouseY+((int) boxScale));
  /* left | top | right | bottom */
}

void box(int w, int c){
  stroke(c);
  strokeWeight(w);
  line(selectionCorners[0], selectionCorners[1], selectionCorners[2], selectionCorners[1]); //top
  line(selectionCorners[2], selectionCorners[3], selectionCorners[0], selectionCorners[3]); //bottom
  line(selectionCorners[0], selectionCorners[1], selectionCorners[0], selectionCorners[3]); //left
  line(selectionCorners[2], selectionCorners[3], selectionCorners[2], selectionCorners[1]); //right
}

void shading(int x1, int y1, int x2, int y2) {
  rectMode(CORNERS);
  fill(0, 0, 0, 127);
  rect(x1, y1, x2, y2);
}

int[] setCorners(int x1, int y1, int x2, int y2) {
  return new int[]{x1, y1, x2, y2};
}

void drawText(String s){
  fill(255);
  text(s, 10, height-10);
}

PImage imageScale(PImage reference, float factor){
  PImage tempScaleImage = createImage(reference.width, reference.height, RGB);
  tempScaleImage = reference.get();
  tempScaleImage.resize(((int) (width*factor)), 0);
  return tempScaleImage;
}

void mouseWheel(MouseEvent event){
  if (keyPressed && keyCode == CONTROL) { //change box dimensions (wheel + ctrl)
    ratioSelect -= event.getCount();
    if (ratioSelect <= 1){
      ratio = 5f/2f;
      friendlyRatio = "5x2";
    }
    else if (ratioSelect == 2){
      ratio = 2f;
      friendlyRatio = "2x1";
    }
    else if (ratioSelect == 3){
      ratio = 16f/9f;
      friendlyRatio = "16x9";
    }
    else if (ratioSelect == 4) {
      ratio = 4f/3f;
      friendlyRatio = "4x3";
    }
    else if (ratioSelect == 5) {
      ratio = 1;
      friendlyRatio = "1x1";
    }
    else if (ratioSelect == 6) {
      ratio = 3f/4f;
      friendlyRatio = "3x4";
    }
    else if (ratioSelect == 7) {
      ratio = 9f/16f;
      friendlyRatio = "9x16";
    }
    else if (ratioSelect == 8){
      ratio = 1f/2f;
      friendlyRatio = "1x2";
    }
    else if (ratioSelect >= 9){
      ratio = 2f/5f;
      friendlyRatio = "2x5";
    }
    if (ratioSelect < 1) {
      ratioSelect = 1;
    }
    else if (ratioSelect > 9) {
      ratioSelect = 9;
    }
  }
  else { //change box scale (wheel)
    boxScale -= 4*event.getCount();
    if (boxScale < 10) { //lower limit
      boxScale = 10;
    }
    else if (boxScale > 500) { //upper limit
      boxScale = 500;
    }
  }
}

void mousePressed() { //mouse clicked, check and trigger save
  if (mouseButton == LEFT){
    int sWidth = selectionCorners[2] - selectionCorners[0];
    int sHeight = selectionCorners[3] - selectionCorners[1];
    output = createImage(sWidth, sHeight, RGB);
    output = newBG.get(selectionCorners[0], selectionCorners[1], sWidth, sHeight);
    output.save(filename+"-"+frameCount+".png");
  }
}

void keyPressed() {
  if (key == 'm' || key == 'M'){ //change box display mode
    displayMode = (displayMode+1)%3;
  }
  if (key == 'r' || key == 'R'){ //toggle ratio printout
    showRatio = !showRatio;
  }
  if (key == 'o' || key == 'O'){ //open new image file
    selectInput("Select an image to work with...", "filepicked");
  }
  if (key == '+') { //scale window up (zoom in)
    if (!warned) {
      sysprint("WARNING", "Scaling is considered experimental.");
      sysprint("WARNING", "What works on one platform may work differently or may not work at all on another platform.");
      sysprint("WARNING", "Scaling very large or small may very well crash the program due to operating system window size restrictions.");      
      warned = true;
    }
    newBG = imageScale(bg, 1.1);
    surface.setSize(newBG.width, newBG.height);
  }
  if (key == '-') { //scale window down (zoom out)
    if (width >= 150) {
      if (!warned) {
        sysprint("WARNING", "Scaling is considered experimental.");
        sysprint("WARNING", "What works on one platform may work differently or may not work at all on another platform.");
        sysprint("WARNING", "Scaling very large or small may very well crash the prograam due to operating system window size restrictions.");
        warned = true;
      }
      newBG = imageScale(bg, 1/1.1);
      surface.setSize(newBG.width, newBG.height);
    }
  }
}

void sysprint(String type, String msg) {
  System.err.println(type+": "+msg);
}