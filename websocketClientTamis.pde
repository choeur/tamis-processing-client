import websockets.*;
import http.requests.*;

WebsocketClient wsc;
int now;
String domain;
String messagesEndpoint;
String scheduledContentEndpoint;
String jsonResponse;
String securityToken;
boolean newMessage;
String message;
String[] scheduledContent;
String commandJson = "{\"command\":\"subscribe\",\"identifier\":\"{\\\"channel\\\":\\\"AcceptedMessagesChannel\\\",\\\"project\\\":\\\"1\\\"}\"}";

void getScheduledContent() {
  scheduledContentEndpoint = "http://" + domain + "/api/current_scheduled_content/1";
  GetRequest get = new GetRequest(scheduledContentEndpoint);
  get.addHeader("Accept", "application/json");
  get.addHeader("secret-token", securityToken);
  get.send();
  jsonResponse = get.getContent();
  JSONObject json = parseJSONObject(jsonResponse);
  scheduledContent = json.getJSONArray("content").toStringArray();
  println(scheduledContent[0]);
}

void connectToMessagesChannel() {
  messagesEndpoint = "ws://" + domain + "/cable?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJCk7-C3W3jk9TjMlO2Di-QrJzQo0";
  newMessage=false;

  wsc= new WebsocketClient(this, messagesEndpoint);

  wsc.sendMessage(commandJson);
}

void setup() {
  securityToken = "dTJNVKPYdUZ0kwhivU3zqw";
  domain = "localhost:3000";
  getScheduledContent();
  connectToMessagesChannel();

  size(1200, 1200);



  now=millis();
}

void webSocketEvent(String msg) {
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

void draw() {
  if (newMessage) {
    text(message, random(width), random(height));
    newMessage=false;
  }

  if (millis()>now+5000) {
    //wsc.sendMessage("Client message");
    now=millis();
  }
}
