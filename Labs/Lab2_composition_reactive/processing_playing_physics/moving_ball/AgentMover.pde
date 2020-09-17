int RADIUS_CIRCLE=50;
int LIMIT_VELOCITY=50;
float CONSTANT_ACC=10;
int PORT = 57120;
float alpha=0.1;  

import oscP5.*;
import netP5.*;
  

class AgentMover{
  PVector position, velocity, acceleration;
  OscP5 oscP5;
  NetAddress ip_port;
  float old_vibrato=0;
  float old_cutoff=0.5;
  AgentMover(){
    this.position= new PVector(random(0, width), random(0, height));
    this.velocity = new PVector(random(-2, 2), random(-2, 2));
    this.acceleration = new PVector(random(2), random(2));

    this.oscP5 = new OscP5(this,55000);
    this.ip_port = new NetAddress("127.0.0.1",PORT);
  }
  void planning(){    
    PVector delta = new PVector(mouseX, mouseY);
    delta.sub(this.position);
    delta.normalize();
    delta.mult(CONSTANT_ACC);
    this.acceleration = delta;
    
    this.velocity.add(this.acceleration);
    this.velocity.limit(LIMIT_VELOCITY);
    this.position.add(this.velocity);
    
  }
  void action(){
    this.planning();
    fill(200);
    ellipse(this.position.x, this.position.y, RADIUS_CIRCLE, RADIUS_CIRCLE);
    OscMessage effect = new OscMessage("/note_effect");
    
    float new_vibrato= constrain(this.position.x/width -0.5, -0.5, 0.5);
    this.old_vibrato=alpha* new_vibrato + (1-alpha)*this.old_vibrato;
    float new_cutoff=constrain((this.position.y/height),0,1);
    this.old_cutoff= alpha* new_cutoff +(1-alpha)*this.old_cutoff;
    
    effect.add("effect");   
    
    effect.add(this.old_cutoff);
    effect.add(this.old_vibrato);
    
    this.oscP5.send(effect, this.ip_port);
  
  }

}
