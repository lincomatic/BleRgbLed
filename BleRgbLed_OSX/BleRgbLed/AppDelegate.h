//
//  AppDelegate.h
//  BleRgbLed
//
//  Created by Geek on 12/23/12.
//  Copyright (c) 2012 lincomatic. All rights reserved.
//  based on SimpleControls by
//  Created by Cheong on 27/10/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//
//

#import <Cocoa/Cocoa.h>
#import "BLE.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, BLEDelegate>
{
    IBOutlet NSTextField *lblRSSI;
    IBOutlet NSButton *btnConnect;
    IBOutlet NSProgressIndicator *indConnect;
    IBOutlet NSSlider *sldRed;
    IBOutlet NSSlider *sldBlue;
    IBOutlet NSSlider *sldGreen;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) BLE *ble;

@end
