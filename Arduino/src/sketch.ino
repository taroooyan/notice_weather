void setup() {
	Serial.begin(9600);
}

void loop() {
	int value = analogRead(0);
	int distance = (6787/(value-3))-4;
  Serial.println(distance);
	delay(500);
}
