import websockets.*;

WebsocketClient wsc;
int now;
String messagesEndpoint;
String scheduledContentEndpoint;
String securityToken;
boolean newMessage;
String message;
String commandJson = "{\"command\":\"subscribe\",\"identifier\":\"{\\\"channel\\\":\\\"AcceptedMessagesChannel\\\",\\\"project\\\":\\\"1\\\"}\"}";

void setup(){
  messagesEndpoint = "ws://localhost:3000/cable?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJCk7-C3W3jk9TjMlO2Di-QrJzQo0";
  size(1200, 1200);
  
  newMessage=false;
  
  wsc= new WebsocketClient(this, messagesEndpoint);
  
  wsc.sendMessage(commandJson);
  
  now=millis();
}

void webSocketEvent(String msg){
  println(msg);
  JSONObject json = parseJSONObject(msg);
  if (json.getString("type") != null ) {
    println("ping");
  } else {
    newMessage=true;
    message = json.getString("message");
    println("message");
    println(message);
  }
}

void draw(){
  if(newMessage){
    text(message, random(width),random(height));
    newMessage=false;
  }
    
  if(millis()>now+5000){
    //wsc.sendMessage("Client message");
    now=millis();
  }
}
