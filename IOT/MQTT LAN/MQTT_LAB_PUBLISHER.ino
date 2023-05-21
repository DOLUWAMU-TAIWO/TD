#include <WiFiNINA.h>
#include <ArduinoMqttClient.h>
#include "arduino_secrets.h"
#include <DHT.h>

char ssid[] = SECRET_SSID;         // Your network SSID (name)
char pass[] = SECRET_PASS;         // Your network password (use for WPA, or use as key for WEP)

WiFiClient wifiClient;
MqttClient mqttClient(wifiClient);

const char broker[] = "test.mosquitto.org";
int port = 1883;
const char topic[] = "real_unique_topic";

// DHT sensor settings
#define DHTPIN 2
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// Moisture sensor pin
const int moisturePin = A0;

// Set interval for sending messages (milliseconds)
const long interval = 8000;
unsigned long previousMillis = 0;

void setup() {
  // Initialize serial and wait for the port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // Wait for the serial port to connect. Needed for native USB port only
  }

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

  if (!mqttClient.connect(broker, port)) {
    Serial.print("MQTT connection failed! Error code = ");
    Serial.println(mqttClient.connectError());
    while (1);
  }

  Serial.println("You're connected to the MQTT broker!");
  Serial.println();

  // Initialize DHT sensor
  dht.begin();
}

void sendSensorDataToTopic(const char* sensorData, const char* topic) {
  Serial.print("Sending message to topic: ");
  Serial.println(topic);
  Serial.println(sensorData);

  mqttClient.beginMessage(topic);
  mqttClient.print(sensorData);
  mqttClient.endMessage();
}

void loop() {
  // Call poll() regularly to allow the library to send MQTT keep alive
  // and avoid being disconnected by the broker
  mqttClient.poll();

  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    // Save the last time a message was sent
    previousMillis = currentMillis;

    // Read temperature and humidity from DHT11 sensor
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();

    // Read moisture value from funduino sensor
  // Read moisture value from funduino sensor
int moistureValue = map(analogRead(moisturePin), 0, 1023, 0, 100);


    // Check if the sensor readings are valid
    if (isnan(temperature) || isnan(humidity)) {
      Serial.println("Failed to read from DHT sensor");
      return;
    }

    // Create payload for temperature, humidity, and moisture
    String payload = "Temperature: " + String(temperature) + " °C, Humidity: " + String(humidity) + "%, Moisture: " + String(moistureValue);

    // Publish sensor data to topic
    sendSensorDataToTopic(payload.c_str(), topic);

    Serial.println();
  }
}