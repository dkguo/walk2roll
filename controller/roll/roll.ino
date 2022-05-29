//
// roll
//
// Robotics Research with Prof. Oldham
//
// Created by Dingkun Guo
// Copyright © 2022 dkguo. All rights reserved.
//

#include <Arduino_LSM6DS3.h>

// Connections for motor driver
const int PWMB = 9;
const int BIN2 = 8;
const int BIN1 = 7;
const int STBY = 6;
const int AIN1 = 5;
const int AIN2 = 4;
const int PWMA = 3;

// Connections for encoders
const int front_encoderA = 13;
const int front_encoderB = 12;
const int back_encoderA = 10;
const int back_encoderB = 11;

const float SUPPLY_VOLTAGE = 5;

unsigned long execution_duration = 0;
unsigned long last_execution_time = 0;
unsigned long timer = 0;

// for encoder
float f_Ep, f_Ei = 0, f_Ed;
float b_Ep, b_Ei = 0, b_Ed;
int front_pos = 0;
int back_pos = 0;

// PID controller
float Kp = 0.03;
float Ki = 0.02;
float Kd = 0.001;

int state = 0;
int prev_state = 0;

int front_des = 0;
int back_des = 0;

float acc_x, acc_y, acc_z;
float gyr_x, gyr_y, gyr_z;


void setup() {
  pinMode(back_encoderA, INPUT);
  pinMode(back_encoderB, INPUT);
  pinMode(front_encoderA, INPUT);
  pinMode(front_encoderB, INPUT);

  pinMode(STBY, OUTPUT);
  pinMode(AIN1, OUTPUT);
  pinMode(AIN2, OUTPUT);
  pinMode(PWMA, OUTPUT);
  pinMode(BIN1, OUTPUT);
  pinMode(BIN2, OUTPUT);
  pinMode(PWMB, OUTPUT);

  Serial.begin(9600);
  while (!Serial);

  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

  Serial.println("-------------------------------------");

  attachInterrupt(digitalPinToInterrupt(back_encoderA), isrBA, CHANGE); 
  attachInterrupt(digitalPinToInterrupt(back_encoderB), isrBB, CHANGE);
  attachInterrupt(digitalPinToInterrupt(front_encoderA),isrFA, CHANGE); 
  attachInterrupt(digitalPinToInterrupt(front_encoderB), isrFB, CHANGE);
}

void loop() {
  execution_duration = micros() - last_execution_time;
  last_execution_time = micros();
  if (state != prev_state) {
    timer = 0;
    prev_state = state;
  }
  timer += execution_duration;

  IMU.readAcceleration(acc_x, acc_y, acc_z);
  IMU.readGyroscope(gyr_x, gyr_y, gyr_z);

  switch (state) {
    case 0:
      front_des = 0;
      back_des = 0;
      if (acc_y < -0.4 && acc_z < 0.9)
        state = 2;
      else if (acc_z > 0 && front_pos > -25 && front_pos < 25 && back_pos > -25 && back_pos < 25)
        state = 3;
      else if (acc_z < -0.9 && front_pos > -25 && front_pos < 25 && back_pos > -25 && back_pos < 25)
        state = 4;
      break;

    case 2:
      front_des = 0;
      back_des = 600;
      if (timer > 500000 && back_pos > 550 && acc_y > 0.2)
        state = 3;
      else if (timer > 1000000 && back_pos > 550)
        state = 4;
      break;

    case 3:
      front_des = 1500;
      back_des = 300;
      
      if (back_pos > 250 && acc_y < -0.98)
        state = 4;
      else if (timer > 1000000 && back_pos > 250)
        state = 0;
      break;

    case 4:
      front_des = 1500;
      back_des = 1300;
      if (back_pos > 1250 && acc_y > 0.1 && acc_z < -0.9)
        state = 0;
      else if (timer > 1000000 && back_pos > 1250 && acc_y < -0.4 && acc_z > -0.98)
        state = 5;
      else if (timer > 1000000 && back_pos > 1250 && acc_z > 0.99)
        state = 0;
      break;

    case 5:
      front_des = 1500;
      if (timer < 500000)
        back_des = 700;
      else
        back_des = 0;

      if (back_pos < 50 && acc_y < -0.98 && acc_z > -0.99)
        state = 4;
      else if (back_pos < 50 && acc_y > -0.4 && acc_z > 0.9)
        state = 0;
      break;
  }

  int front_pwm = front_leg_to(front_des);
  int back_pwm = back_leg_to(back_des);

  // print out info
  Serial.print(state);
  Serial.print('\t');
  Serial.print(front_des);
  Serial.print('\t');
  Serial.print(back_des);
  Serial.print('\t');
  Serial.print(front_pos);
  Serial.print('\t');
  Serial.print(back_pos);
  Serial.print('\t');
  Serial.print(front_pwm);
  Serial.print('\t');
  Serial.print(back_pwm);
  Serial.print('\t');
  Serial.print(acc_y);
  Serial.print('\t');
  Serial.print(acc_z);
  Serial.print('\t');
  Serial.print(gyr_x);
  Serial.print('\n');
}


// -----------------Leg PID controller----------------
int front_leg_to(const int p) {
  f_Ep = p - front_pos;
  f_Ei += f_Ep * (float) execution_duration / 1000000;
  f_Ed = 0; // - motor_velocity;
  
  float voltage = Kp * f_Ep + Ki * f_Ei + Kd * f_Ed;

  int motor = int(abs(voltage * 255 / SUPPLY_VOLTAGE));
  if (motor > 150) {
    motor = 150;
    f_Ei -= f_Ep * (float) execution_duration / 1000000;
  }

  if (voltage >= 0) 
    front_leg_forward(motor);
  else 
    front_leg_backward(motor);

  return motor;
}


int back_leg_to(const int p) {
  b_Ep = p - back_pos;
  b_Ei += b_Ep * (float) execution_duration / 1000000;
  b_Ed = 0; // - motor_velocity;
  
  float voltage = Kp * b_Ep + Ki * b_Ei + Kd * b_Ed;

  int motor = int(abs(voltage * 255 / SUPPLY_VOLTAGE));
  if (motor > 150) {
    motor = 150;
    b_Ei -= b_Ep * (float) execution_duration / 1000000;
  }

  if (voltage >= 0) 
    back_leg_forward(motor);
  else 
    back_leg_backward(motor);

  return motor;
}


// -----------------Leg position----------------
void front_leg_forward(int m) {
  digitalWrite(STBY, HIGH);
  digitalWrite(BIN1, HIGH);
  digitalWrite(BIN2, LOW);
  analogWrite(PWMB, m);
}

void front_leg_backward(int m) {
  digitalWrite(STBY, HIGH);
  digitalWrite(BIN1, LOW);
  digitalWrite(BIN2, HIGH);
  analogWrite(PWMB, m);
}

void back_leg_backward(int m) {
  digitalWrite(STBY, HIGH);
  digitalWrite(AIN1, LOW);
  digitalWrite(AIN2, HIGH);
  analogWrite(PWMA, m);
}

void back_leg_forward(int m) {
  digitalWrite(STBY, HIGH);  
  digitalWrite(AIN1, HIGH);
  digitalWrite(AIN2, LOW);
  analogWrite(PWMA, m);
}


// ---------------Encoder Interrupts----------------
// interrupt routine for encoders
void isrFA() {
  int f_channelA = digitalRead(front_encoderA); 
  int f_channelB = digitalRead(front_encoderB); 
  if (f_channelA == f_channelB) 
    --front_pos;
  else 
    ++front_pos;
}

void isrBA() {
  int b_channelA = digitalRead(back_encoderA); 
  int b_channelB = digitalRead(back_encoderB); 
  if (b_channelA == b_channelB) 
    --back_pos;
  else 
    ++back_pos;
}

void isrFB() {
  int f_channelA = digitalRead(front_encoderA); 
  int f_channelB = digitalRead(front_encoderB); 
  if (f_channelA == f_channelB)
    ++front_pos;
  else
    --front_pos;
}

void isrBB() {
  int b_channelA = digitalRead(back_encoderA); 
  int b_channelB = digitalRead(back_encoderB); 
  if (b_channelA == b_channelB) 
    ++back_pos;
  else
    --back_pos;
}
