#include <WiFiNINA.h>
#include <PubSubClient.h>
#include "arduino_secrets.h"

char ssid[] = SECRET_SSID;         // Your network SSID (name)
char pass[] = SECRET_PASS;         // Your network password (use for WPA, or use as key for WEP)

WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);

const char broker[] = "172.20.10.4";
int port = 1883;
const char topic[] = "real_unique_topic";
const char username[] = "teamd";
const char password[] = "TeamD2023";

#define TEMPERATURE_THRESHOLD 21
#define MOISTURE_THRESHOLD 70
#define TEMPERATURE_PIN 3
#define MOISTURE_PIN 4
#define WATER_PUMP_PIN 2

void setup() {
  // Initialize serial and wait for the port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // Wait for the serial port to connect. Needed for native USB port only
  }

  pinMode(TEMPERATURE_PIN, OUTPUT);
  pinMode(MOISTURE_PIN, OUTPUT);
  pinMode(WATER_PUMP_PIN, OUTPUT);
  digitalWrite(WATER_PUMP_PIN, LOW);

  // Attempt to connect to the WiFi network:
  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);
  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
    // Failed, retry
    Serial.print(".");
    delay(5000);
  }

  Serial.println("You're connected to the network");
  Serial.println();

  Serial.print("Attempting to connect to the MQTT broker: ");
  Serial.println(broker);

  mqttClient.setServer(broker, port);
  mqttClient.setCallback(messageReceived);

  while (!mqttClient.connected()) {
    if (mqttClient.connect("arduinoClientactuator", username, password)) {
      Serial.println("You're connected to the MQTT broker!");
      mqttClient.subscribe(topic);
      mqttClient.subscribe("water_pump");
    } else {
      Serial.print("MQTT connection failed! Error code = ");
      Serial.println(mqttClient.state());
      delay(5000);
    }
  }
}

void loop() {
  if (!mqttClient.connected()) {
    reconnect();
  }

  mqttClient.loop();
 
}

void reconnect() {
  while (!mqttClient.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (mqttClient.connect("arduinoClientactuator", username, password)) {
      Serial.println("You're connected to the MQTT broker!");
      mqttClient.subscribe(topic);
      mqttClient.subscribe("water_pump");
    } else {
      Serial.print("MQTT connection failed! Error code = ");
      Serial.println(mqttClient.state());
      delay(5000);
    }
  }
}

void messageReceived(char* topic, byte* payload, unsigned int length) {
  Serial.println("Received a message!");

  // Convert the payload to a string
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  Serial.print("Received message: ");
  Serial.println(message);

  // Check if the topic is "water_pump"
  if (strcmp(topic, "water_pump") == 0) {
    // Check the payload for the water pump
    if (message.equals("on")) {
      Serial.println("Turning water pump ON...");
      digitalWrite(WATER_PUMP_PIN, HIGH);
      delay(1000); // Wait for 1 second to ensure the pin stays HIGH
      Serial.println("Water pump turned ON");
    } else if (message.equals("off")) {
      Serial.println("Turning water pump OFF...");
      digitalWrite(WATER_PUMP_PIN, LOW);
      delay(1000); // Wait for 1 second to ensure the pin stays LOW
      Serial.println("Water pump turned OFF");
    }
  }

  // Extract temperature and moisture values from the message
  if (message.startsWith("Temperature:") && message.indexOf("Moisture:") != -1) {
    String temperatureString = message.substring(message.indexOf(":") + 2, message.indexOf(" °C"));
    float temperature = temperatureString.toFloat();

    String moistureString = message.substring(message.indexOf("Moisture:") + 10);
    int moisture = moistureString.toInt();

    // Check if temperature is greater than the threshold
    if (temperature > TEMPERATURE_THRESHOLD) {
      Serial.println("Temperature is greater than 21°C. Setting temperature pin HIGH.");
      digitalWrite(TEMPERATURE_PIN, HIGH);
    } else {
      Serial.println("Temperature is not greater than 21°C.");
      digitalWrite(TEMPERATURE_PIN, LOW);
    }

    // Check if moisture is less than the threshold
    if (moisture < MOISTURE_THRESHOLD) {
      Serial.println("Moisture is less than 70. Setting moisture pin HIGH.");
      digitalWrite(MOISTURE_PIN, HIGH);
    } else {
      Serial.println("Moisture is not less than 70.");
      digitalWrite(MOISTURE_PIN, LOW);
    }

    // Wait for data processing to complete before reading new data
    delay(100);
  }
  // Continue processing other sensor values as needed
}
