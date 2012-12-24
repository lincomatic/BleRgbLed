#include <SPI.h>
#include <ble.h>
 
#define LED_RED_PIN   6
#define LED_GREEN_PIN 5
#define LED_BLUE_PIN  3

#define SYNC_BYTE 0xa5

byte g_RedVal = 128;
byte g_GreenVal = 128;
byte g_BlueVal = 128;

void setup()
{
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();

  ble_begin();
  
  pinMode(LED_RED_PIN,OUTPUT);
  pinMode(LED_GREEN_PIN,OUTPUT);
  pinMode(LED_BLUE_PIN,OUTPUT);
  
 // analogWrite(LED_RED_PIN,g_RedVal);
 // analogWrite(LED_BLUE_PIN,g_BlueVal);
 // analogWrite(LED_GREEN_PIN,g_GreenVal);
}

byte pktbuf[5];
byte bytecnt = 0;
void loop()
{
  // If data is ready
  while(ble_available())
  {
    for (byte i=0;i < 4;i++) {
      pktbuf[i] = pktbuf[i+1];
    }
    byte b = ble_read();
    
    if ((pktbuf[0] == SYNC_BYTE) && (bytecnt == 5)) {
      byte cksum = pktbuf[1] ^ pktbuf[2] ^ pktbuf[3];
      if (cksum == pktbuf[4]) {
        analogWrite(LED_RED_PIN,pktbuf[1]);
        analogWrite(LED_GREEN_PIN,pktbuf[2]);
        analogWrite(LED_BLUE_PIN,pktbuf[3]);
        bytecnt = 0;
      }
    }

  }
  // Allow BLE Shield to send/receive data
  ble_do_events();  
}



