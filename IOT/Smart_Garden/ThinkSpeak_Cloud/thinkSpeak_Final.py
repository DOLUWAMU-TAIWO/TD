import paho.mqtt.client as mqtt
import requests
import time

# MQTT broker settings
broker = "172.20.10.4"
port = 1883
username = "teamd"  # Replace with your MQTT broker username
password = "TeamD2023"  # Replace with your MQTT broker password

# ThingSpeak settings
channel_id = "2164717"  # Replace with your ThingSpeak channel ID
api_key = "L2T932BU6SPRNEBH"  # Replace with your ThingSpeak API key

# MQTT on_connect callback
def on_connect(client, userdata, flags, rc):
    print("Connected to MQTT broker")
    client.subscribe("real_unique_topic")  # Subscribe to the topic where data is being published

# MQTT on_message callback
def on_message(client, userdata, msg):
    payload = msg.payload.decode()
    print("Received message:", payload)

    # Extract temperature, humidity, and moisture readings
    temperature_start = payload.find("Temperature:") + len("Temperature:")
    temperature_end = payload.find("°C", temperature_start)
    temperature = payload[temperature_start:temperature_end].strip()

    humidity_start = payload.find("Humidity:")
    humidity_end = payload.find("%", humidity_start)
    humidity = payload[humidity_start + len("Humidity:"):humidity_end].strip()

    moisture_start = payload.find("Moisture:")
    moisture_end = len(payload)
    moisture = payload[moisture_start + len("Moisture:"):moisture_end].strip()

    print("Extracted temperature:", temperature)
    print("Extracted humidity:", humidity)
    print("Extracted moisture:", moisture)

    # Convert temperature, humidity, and moisture to float
    try:
        temperature = float(temperature)
        humidity = float(humidity)
        moisture = int(moisture)
    except ValueError:
        print("Failed to convert sensor values to float")
        return

    # Publish temperature to ThingSpeak
    time.sleep(10)
    url_temperature = f"https://api.thingspeak.com/update?api_key={api_key}&field1={temperature:.2f}"
    time.sleep(5)
    response_temperature = requests.get(url_temperature)
    if response_temperature.content.decode() == "0":
        print("Failed to publish temperature to ThingSpeak")
    else:
        print("Temperature published to ThingSpeak")

    time.sleep(20)  # Introduce a 20-second delay between publishing temperature and humidity

    # Publish humidity to ThingSpeak
    url_humidity = f"https://api.thingspeak.com/update?api_key={api_key}&field2={humidity:.2f}"
    time.sleep(5)
    response_humidity = requests.get(url_humidity)
    if response_humidity.content.decode() == "0":
        print("Failed to publish humidity to ThingSpeak")
    else:
        print("Humidity published to ThingSpeak")

    time.sleep(20)  # Introduce a 20-second delay between publishing humidity and moisture

    # Publish moisture to ThingSpeak
    url_moisture = f"https://api.thingspeak.com/update?api_key={api_key}&field3={moisture}"
    time.sleep(5)
    response_moisture = requests.get(url_moisture)
    if response_moisture.content.decode() == "0":
        print("Failed to publish moisture to ThingSpeak")
    else:
        print("Moisture published to ThingSpeak")

# Create MQTT client
client = mqtt.Client()

# Set MQTT client options
client.username_pw_set(username, password)
client.on_connect = on_connect
client.on_message = on_message

# Connect to MQTT broker
client.connect(broker, port)

# Start the MQTT client loop
client.loop_forever()
