//
//  AppDelegate.m
//  BleRgbLed
//
//  Created by Geek on 12/23/12.
//  Copyright (c) 2012 lincomatic. All rights reserved.
//  based on SimpleControls by
//  Created by Cheong on 27/10/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize ble;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    ble = [[BLE alloc] init];
    [ble controlSetup:1];
    ble.delegate = self;
}

-(void) bleDidConnect
{
    NSLog(@"->Connected");
    
    btnConnect.title = @"Disconnect";
    [indConnect stopAnimation:self];
    
    
    sldRed.enabled = true;
    sldBlue.enabled = true;
    sldGreen.enabled = true;
    
    sldRed.integerValue = 0;
    sldBlue.integerValue = 0;
    sldGreen.integerValue = 0;
}

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");
    
    btnConnect.title = @"Connect";
    
    sldRed.enabled = false;
    sldBlue.enabled = false;
    sldGreen.enabled = false;
    
    lblRSSI.stringValue = @"---";
    
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSLog(@"Length: %d", length);
    
    // parse data, all commands are in 3-byte
    for (int i = 0; i < length; i+=3)
    {
        NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        
        if (data[i] == 0x0A)
        {
            
        }
        else if (data[i] == 0x0B)
        {
        }
    }
}

-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    lblRSSI.stringValue = rssi.stringValue;
}

- (IBAction)btnConnect:(id)sender
{
    if (ble.activePeripheral)
        if(ble.activePeripheral.isConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [indConnect startAnimation:self];
}

-(void) connectionTimer:(NSTimer *)timer
{
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    else
    {
        [indConnect stopAnimation:self];
    }
}



// PWM slide will call this to send its value to Arduino
#define SYNC_BYTE 0xa5
-(IBAction)sendColorSlider:(id)sender
{
    UInt8 pktbuf[5];
    // packet format <syncbyte><red><green><blue><checksum>
    pktbuf[0] = SYNC_BYTE;
    pktbuf[1] = sldRed.integerValue;
    pktbuf[2] = sldGreen.integerValue;
    pktbuf[3] = sldBlue.integerValue;
    pktbuf[4] = pktbuf[1] ^ pktbuf[2] ^ pktbuf[3];
    
    
    NSData *data = [[NSData alloc] initWithBytes:pktbuf length:5];
    [ble write:data];
}

@end
