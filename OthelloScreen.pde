
import processing.video.*;

int screenWidth = 1280;//checked 640, 1280
int screenHeight = screenWidth*3/4;
int cellSize = 20;
int cols, rows;
Capture video;
boolean isMouseDragged = false;
ArrayList<Othello> othellos = new ArrayList<Othello>();


void setup() {
  size(screenWidth, screenHeight,P3D);
  cols = width / cellSize;
  rows = height / cellSize;
  colorMode(RGB, 255, 255, 255, 100);
  rectMode(CENTER);
  
  for (int i = 0; i < cols;i++) {
    for (int j = 0; j < rows;j++) {
      int x = i * cellSize;
      int y = j * cellSize;
      othellos.add(new Othello(x + cellSize/2, y + cellSize/2, cellSize/2));
    }
  }


  video = new Capture(this, width, height);
  
  video.start();  

  background(0);
}


void draw() { 
  if (video.available()) {
    video.read();
    video.loadPixels();
    

    
    background(0);
    noStroke();
    pushMatrix();
    if(isMouseDragged){
      translate(width/2,height/2,0);
      rotateX(-(mouseY-height/2) / 150.0);
      rotateY((mouseX-width/2) / 200.0);
      translate(-width/2,-height/2,0);
    }
    for (int i = 0; i < cols;i++) {
      for (int j = 0; j < rows;j++) {
        int x = i * cellSize;
        int y = j * cellSize;
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image
        
        lights();
        shininess(10.0);
        
        othellos.get(i*(rows) + j).draw_othello(brightness(video.pixels[loc]));
      }
    }
    popMatrix();
  }
}


class Othello{
  float x,y,z;
  float locX, locY;
  float size;
  
  Othello(float locX,float locY, float size){
    this.locX = locX;
    this.locY = locY;
    this.size = size;
  }
  
  void draw_othello(float slope){
    //draw othello's white side
    pushMatrix();
    //color and position
    fill(255);
    translate(locX,locY,0);
    rotateX(radians(135*(slope/100)-45));
    translate(0,size/16);
    //shape
    draw_othello_shape(size);
    
    popMatrix();
    
    //draw othello's black side
    pushMatrix();
    //color and position
    fill(0);
    translate(locX,locY,0);
    rotateX(radians(135*(slope/100)-45));
    translate(0,-size/16,0);
  
    draw_othello_shape(size);
    popMatrix();
  }
  
  void draw_othello_shape(float size){//draw thin Cylinder
    float x,y,z;
    
    beginShape(TRIANGLE_FAN);
    y = -size/16;
    vertex(0, y, 0);
    for(int deg = 0; deg <= 360; deg = deg + 10){
      x = cos(radians(deg)) * size;
      z = sin(radians(deg)) * size;
      vertex(x, y, z);
    }
    endShape();
    beginShape(TRIANGLE_FAN);
    y = size/16;
    vertex(0, y, 0);
    for(int deg = 0; deg <= 360; deg = deg + 10){
      x = cos(radians(deg)) * size;
      z = sin(radians(deg)) * size;
      vertex(x, y, z);
    }
    endShape();
    beginShape(TRIANGLE_STRIP);
    for(int deg =0; deg <= 360; deg = deg + 5){
      x = cos(radians(deg)) * size;
      y = -size/16;
      z = sin(radians(deg)) * size;
      vertex(x, y, z);
      x = cos(radians(deg)) * size;
      y = size/16;
      z = sin(radians(deg)) * size;
      vertex(x, y, z);
    }
    endShape();
  }
}



//dragg
void mouseDragged(){
  isMouseDragged = true;
}
void mouseReleased(){
  isMouseDragged = false;
}
  
