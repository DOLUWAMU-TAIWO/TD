#include <WiFiNINA.h>          // Required for WiFi connectivity
#include <PubSubClient.h>      // Required for MQTT functionality

// WiFi settings
const char* ssid = "Vodafone-2CB8";
const char* password = "CLc7aeMcPh76amHJ";

// MQTT broker settings
const char* mqtt_server = "192.168.0.110";
const int mqtt_port = 1883;   // Default MQTT port
const char* mqtt_username = "teamd";
const char* mqtt_password = "TeamD2023";
const char* acuterTopic = "Acuter";

// Relay pin
const int relayPin = 3;

// WiFi and MQTT client instances
WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);

// Callback function when MQTT client receives a message
void callback(char* topic, byte* payload, unsigned int length) {
  // Handle received message
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  // Control relay based on the message
  if (message == "ON") {
    digitalWrite(relayPin, HIGH);  // Turn on relay
  } else if (message == "OFF") {
    digitalWrite(relayPin, LOW);   // Turn off relay
  }

  Serial.print("Received message on topic '");
  Serial.print(topic);
  Serial.print("': ");
  Serial.println(message);
}

void setup() {
  // Initialize serial communication
  Serial.begin(9600);

  // Set relay pin as output
  pinMode(relayPin, OUTPUT);

  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.println("WiFi connected");

  // Set MQTT server and callback function
  mqttClient.setServer(mqtt_server, mqtt_port);
  mqttClient.setCallback(callback);

  // Connect to MQTT broker
  if (mqttClient.connect("ArduinoClient", mqtt_username, mqtt_password)) {
    Serial.println("Connected to MQTT broker");
    mqttClient.subscribe(acuterTopic);
  } else {
    Serial.println("Failed to connect to MQTT broker");
  }
}

void loop() {
  if (WiFi.status() == WL_CONNECTED && mqttClient.connected()) {
    // Reconnect to MQTT broker if disconnected
    if (!mqttClient.connected()) {
      if (mqttClient.connect("ArduinoClient", mqtt_username, mqtt_password)) {
        Serial.println("Reconnected to MQTT broker");
        mqttClient.subscribe(acuterTopic);
      } else {
        Serial.println("Failed to reconnect to MQTT broker");
      }
    }
  } else {
    // Reconnect to WiFi and MQTT broker if disconnected
    if (WiFi.status() != WL_CONNECTED) {
      WiFi.begin(ssid, password);
      while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
      }
      Serial.println();
      Serial.println("WiFi reconnected");
    }
    if (!mqttClient.connected()) {
      if (mqttClient.connect("ArduinoClient", mqtt_username, mqtt_password)) {
        Serial.println("Reconnected to MQTT broker");
        mqttClient.subscribe(acuterTopic);
      } else {
        Serial.println("Failed to reconnect to MQTT broker");
      }
    }
  }

  // Maintain MQTT connection and handle incoming messages
  mqttClient.loop();
}
