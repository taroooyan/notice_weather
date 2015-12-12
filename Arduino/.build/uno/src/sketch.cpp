#include <Arduino.h>

void setup();
void loop();
#line 1 "src/sketch.ino"
void setup()
{
	Serial.begin(9600);
}

void loop()
{
	int value = analogRead(0);
	int distance = (6787/(value-3))-4;
	//50cm以下で反応
	/* if(distance <= 50){ */
	/* 	Serial.print(distance); */
	/* 	Serial.println("cm"); */
	/* } */
	/* else{ */
	/* 	Serial.println("not found"); */
	/* } */
  Serial.println(distance);
	delay(500);
}
