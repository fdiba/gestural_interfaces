import SimpleOpenNI.*;
SimpleOpenNI context;

int actual_zone;
int previous_zone;
PVector com;

int n_diam;
int[] scores ={0,0,0,0,0};
float xPos=0, yPos=0;
int numFrames=0;

/*
void init() {
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.addNotify();
    super.init();
}*/

void setup(){
  //size(640,480);
  size(1280,720);

  n_diam = 300;
  
  com = new PVector();
  
  context = new SimpleOpenNI(this);
  context.enableDepth();
  context.enableUser();
  
  actual_zone = -999;
  previous_zone = actual_zone;
}
void checkZone(PVector pos){
  
  PVector v1 = new PVector(width/4, 0);
  PVector v2 = new PVector(pos.x-width/2, pos.y-height/2); 
  float angle = degrees(PVector.angleBetween(v1, v2));
  //println(a);
  
  if(dist(pos.x, pos.y, width/2, height/2)<=n_diam/2){
    actual_zone = 0;
  } else if(angle <= 45){
    actual_zone = 2;
  } else if(angle >= 135){
    actual_zone = 4;
  } else if(pos.y >height/2){
    actual_zone = 3; 
  } else {
    actual_zone = 1;
  }
  
  if(actual_zone!=previous_zone){
    numFrames=0;
    scores[actual_zone]++;
    println(scores[0],scores[1],scores[2],scores[3],scores[4]);
    //newEvents(actual_zone);
  }
  previous_zone = actual_zone;
}
void newEvents(int id){
  
  background(0);
  
  switch(id){
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    case 4:
      break;
    default:
       break;
  }
}
void mousePressed(){
  //frame.setLocation(2024, 100); 
}
void draw(){

  background(0);
  
  context.update();
  
  int[] userList = context.getUsers();
  if(userList.length>0 && context.getCoM(userList[0], com)){ 
    //println(com.y);
    xPos = lerp(xPos, map(com.x, -600., 600., 0, width), 0.3);
    yPos = lerp(yPos, map(com.y, -400., 0., height, 0), 0.3);
    
    /*xPos = lerp(xPos, map(com.x, -500., 500., 0, width), 0.3);
    yPos = lerp(yPos, map(com.y, -200., 0., height, 0), 0.3);*/
    
  } else {
    xPos=mouseX;
    yPos=mouseY;
  }
  
  checkZone(new PVector(xPos, yPos));
  drawZones(actual_zone);
  
  if(actual_zone!=0)drawBlackHole();
  
  numFrames++;
  
  fill(127);
  ellipse(xPos,yPos,50,50);

  
    
  textAlign(LEFT);
  fill(255);
  textSize(24);
  String str2 = "numFrames: "+ numFrames;
  text(str2, 50, 50);
  //String str1 = "x: "+ (int)xPos + " y: " + (int)yPos;
  //text(str1, 50, 90);
  
  tint(255, 127);
  if(context.depthImage()!=null)image(context.depthImage(),0,0);
  tint(255,0);
  
  drawScores();
  
}
//------------- draw functions ---------------//
void drawBlackHole(){
  noStroke();
  fill(0);
  ellipse(width/2, height/2, n_diam, n_diam);
}
void drawScores(){
  
  textAlign(CENTER, CENTER);
  
  textSize(30);
  int alpha=30;
  color c1 = color(52,73,94,alpha);
  
  for(int i=0; i<scores.length; i++){
    float x = width/2, y = height/2;
    switch(i){
      case 1:
        y -= height/3;
        c1=color(26,188,156,alpha);
        break;
      case 2:
        x += width/3;
        c1=color(46,204,113,alpha);
        break;
      case 3:
        y += height/3;
        c1=color(52,152,219,alpha);
        break;
      case 4:
        x -= width/3;
        c1=color(155,89,182,alpha);
        break;
      default:
        break;
    } 
    
    fill(c1);
    ellipse(x,y+4,60,60);
    fill(255);
    String str=str(scores[i]);
    text(str,x,y);
  }
}
void drawZones(int id){
  
  int alpha = 255;
  if(numFrames<17)alpha=numFrames*15;
  noStroke();
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(45));
  switch(id){
    case 0:
      fill(52,73,94,alpha);
      ellipse(0,0,n_diam,n_diam);
      break;
    case 1:
      fill(26,188,156,alpha);
      rect(-width, -height, width, height);
      break;
    case 2:
      fill(46,204,113,alpha);
      rect(0, -height, width, height);
      break;
    case 3:
      fill(52,152,219,alpha);
      rect(0, 0, width, height);
      break;
    case 4:
      fill(155,89,182,alpha);
      rect(-width, 0, width, height);
      break;
    default:
       break;
  }
  popMatrix();
}

