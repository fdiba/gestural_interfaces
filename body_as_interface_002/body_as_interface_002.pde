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
  
  if(dist(pos.x, pos.y, width/2, height/2)<=n_diam/2){
    actual_zone = 0;
  } else if(pos.x < width/2 && pos.y < height/2){
    actual_zone = 1;
  } else if(pos.x >= width/2 && pos.y < height/2){
    actual_zone = 2;
  } else if(pos.x < width/2 && pos.y >= height/2){
    actual_zone = 3; 
  } else if(pos.x >= width/2 && pos.y >= height/2){
    actual_zone = 4;
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
  if(userList.length==1 && context.getCoM(userList[0], com)){ 
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

  drawScores();
    
  textAlign(LEFT);
  fill(255);
  textSize(30);
  String str1 = "x: "+ (int)xPos + " y: " + (int)yPos;
  text(str1, 50, 50);
  String str2 = "numFrames: "+ numFrames;
  text(str2, 50, 90);
  
  tint(255, 127);
  if(context.depthImage()!=null)image(context.depthImage(),0,0);
  tint(255,0);
  
}
//------------- draw functions ---------------//
void drawBlackHole(){
  noStroke();
  fill(0);
  ellipse(width/2, height/2, n_diam, n_diam);
}
void drawScores(){
  
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(60);
  
  for(int i=0; i<scores.length; i++){
    float x = width/2, y = height/2;
    switch(i){
      case 1:
        x -= width/4;
        y -= height/4;
        break;
      case 2:
        x += width/4;
        y -= height/4;
        break;
      case 3:
        x -= width/4;
        y += height/4;
        break;
      case 4:
        x += width/4;
        y += height/4;
        break;
      default:
        break;
    } 
    String str=str(scores[i]);
    text(str,x,y);
  }
}
void drawZones(int id){
  
  int alpha = 255;
  if(numFrames<17)alpha=numFrames*15;
  noStroke();
  switch(id){
    case 0:
      fill(52,73,94,alpha);
      ellipse(width/2, height/2, n_diam, n_diam);
      break;
    case 1:
      fill(26,188,156,alpha);
      rect(0, 0, width/2, height/2);
      break;
    case 2:
      fill(46,204,113,alpha);
      rect(width/2, 0, width/2, height/2);
      break;
    case 3:
      fill(52,152,219,alpha);
      rect(0, height/2, width/2, height/2);
      break;
    case 4:
      fill(155,89,182,alpha);
      rect(width/2, height/2, width/2, height/2);
      break;
    default:
       break;
  }
}

