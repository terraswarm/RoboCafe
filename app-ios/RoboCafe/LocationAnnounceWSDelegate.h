//
//  LocationAnnounceWSDelegate.h
//  RoboCafe
//
//  Created by Patrick Pannuto on 8/13/15.
//  Copyright (c) 2015 Carnegie Mellon University. All rights reserved.
//

#import "SRWebSocket.h"

@class AppDelegate;

@interface LocationAnnounceWSDelegate : NSObject <SRWebSocketDelegate> {
    AppDelegate *appDelegate;
}

@property (nonatomic) NSTimer* reconnectTimer;

@end
