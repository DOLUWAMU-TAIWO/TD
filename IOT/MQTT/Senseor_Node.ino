#include <WiFiNINA.h>          // Required for WiFi connectivity
#include <PubSubClient.h>      // Required for MQTT functionality
#include <DHT.h>               // Required for DHT sensor

// WiFi settings
const char* ssid = "Vodafone-2CB8";
const char* password = "CLc7aeMcPh76amHJ";

const int soilMoisturePin = A0;
const int DHTPin = 2;      // Pin connected to the DHT sensor
const int DHTType = DHT11; // Type of the DHT sensor (DHT11 or DHT22)

// MQTT broker settings
const char* mqtt_server = "192.168.0.110";
const int mqtt_port = 1883;   // Default MQTT port
const char* mqtt_username = "teamd";
const char* mqtt_password = "TeamD2023";
const char* topic = "test";

// WiFi and MQTT client instances
WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);

// DHT sensor instance
DHT dht(DHTPin, DHTType);

// Callback function when MQTT client receives a message
void callback(char* topic, byte* payload, unsigned int length) {
  /* Handle received message
  Serial.print("Received message: ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println(); */
}

void setup() {
  // Initialize serial communication
  Serial.begin(9600);

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
    mqttClient.subscribe(topic);
  } else {
    Serial.println("Failed to connect to MQTT broker");
  }

  // Initialize DHT sensor
  dht.begin();
}

void loop() {
  if (WiFi.status() == WL_CONNECTED && mqttClient.connected()) {
    // Reconnect to MQTT broker if disconnected
    if (!mqttClient.connected()) {
      if (mqttClient.connect("ArduinoClient", mqtt_username, mqtt_password)) {
        Serial.println("Reconnected to MQTT broker");
        mqttClient.subscribe(topic);
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
        mqttClient.subscribe(topic);
      } else {
        Serial.println("Failed to reconnect to MQTT broker");
      }
    }
  }

  mqttClient.publish(topic, ("Soil Moisture: " + String(readSoilMoisture()) + "%").c_str());
  delay(1000);

  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  if (!isnan(humidity) && !isnan(temperature)) {
    String sensorData = "Temperature: " + String(temperature) + "°C, Humidity: " + String(humidity) + "%";
    mqttClient.publish(topic, sensorData.c_str());
    Serial.println("Sensor data sent to MQTT broker: " + sensorData);
  }

  // Maintain MQTT connection and handle incoming messages
  mqttClient.loop();
}

int readSoilMoisture() {
  int soilMoistureValue = analogRead(soilMoisturePin);
  int moisturePercentage = map(soilMoistureValue, 0, 1023, 0, 100);
  return moisturePercentage;
}
