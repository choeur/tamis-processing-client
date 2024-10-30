import websockets.*;
import http.requests.*;


WebsocketClient wsc;
int now;
String domain;
String jsonResponse;
String securityToken;
boolean newMessage;
String message;
String[] scheduledContent;
String commandJson = "{\"command\":\"subscribe\",\"identifier\":\"{\\\"channel\\\":\\\"AcceptedMessagesChannel\\\",\\\"project\\\":\\\"1\\\"}\"}";

void getScheduledContent() {
  String scheduledContentEndpoint = "https://" + domain + "/api/projects/choeur-zenith/current_scheduled_content";
  GetRequest get = new GetRequest(scheduledContentEndpoint);
  get.addHeader("Accept", "application/json");
  get.addHeader("secret-token", securityToken);
  get.send();
  jsonResponse = get.getContent();
  JSONArray jsonArray = parseJSONArray(jsonResponse);
  scheduledContent = jsonArray.toStringArray();
  if (scheduledContent.length > 0) {
  println(scheduledContent[0]);
  }
}

void openSubmissions() {
  String openSubmissionsEndpoint = "https://" + domain + "/api/projects/choeur-zenith/open_submissions";
  PutRequest put = new PutRequest(openSubmissionsEndpoint);
  put.addHeader("Accept", "application/json");
  put.addHeader("secret-token", securityToken);
  put.send();
}

void pauseSubmissions() {
  String pauseSubmissionsEndpoint = "https://" + domain + "/api/projects/choeur-zenith/pause_submissions";
  PutRequest put = new PutRequest(pauseSubmissionsEndpoint);
  put.addHeader("Accept", "application/json");
  put.addHeader("secret-token", securityToken);
  put.send();
}

void closeEvent() {
  String closeEventEndpoint = "https://" + domain + "/api/projects/choeur-zenith/close_event";
  PutRequest put = new PutRequest(closeEventEndpoint);
  put.addHeader("Accept", "application/json");
  put.addHeader("secret-token", securityToken);
  put.send();
}

void connectToMessagesChannel() {
  String messagesEndpoint = "wss://" + domain + "/cable?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJCk7-C3W3jk9TjMlO2Di-QrJzQo0";
  newMessage=false;
//SslContextFactory ssl = new SslContextFactory(); 
  wsc= new WebsocketClient(this, messagesEndpoint);

  wsc.sendMessage(commandJson);
}

void setup() {
  securityToken = "qKZa7zp2jbN59qvKquShNA";
  domain = "choeur-zenith.com";
  //domain = "localhost:3000";
  getScheduledContent();
  openSubmissions();
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
