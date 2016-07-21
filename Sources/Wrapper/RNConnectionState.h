//
//  RNConnectionState.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 14.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, RNConnectionState) {
    /// connectToHost: was called, but the process hasn't started yet
    RNConnectionStatePending,
    /// Processing the connection attempt
    RNConnectionStateConnecting,
    /// Is connected and able to communicate
    RNConnectionStateConnected,
    /// Was connected, but will disconnect as soon as the remaining messages are delivered
    RNConnectionStateDisconnecting,
    /// A connection attempt failed and will be aborted
    RNConnectionStateSilentlyDisconnecting,
    /// No longer connected
    RNConnectionStateDisconnected,
    /// Was never connected, or else was disconnected long enough ago that the entry has been discarded
    RNConnectionStateNotConnected
};