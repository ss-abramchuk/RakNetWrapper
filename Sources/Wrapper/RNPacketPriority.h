//
//  RNPacketPriority.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 21.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

/// These enumerations are used to describe when packets are delivered.
typedef NS_ENUM (unsigned char, RNPacketPriority) {
    /// The highest possible priority. These message trigger sends immediately, and are generally not buffered or aggregated into a single datagram.
    RNPacketPriorityImmediate,
    /// For every 2 RNPacketPriorityImmediate messages, 1 RNPacketPriorityHigh will be sent.
    /// Messages at this priority and lower are buffered to be sent in groups at 10 millisecond intervals to reduce UDP overhead and better measure congestion control.
    RNPacketPriorityHigh,
    /// For every 2 RNPacketPriorityHigh messages, 1 RNPacketPriorityMedium will be sent.
    /// Messages at this priority and lower are buffered to be sent in groups at 10 millisecond intervals to reduce UDP overhead and better measure congestion control.
    RNPacketPriorityMedium,
    /// For every 2 RNPacketPriorityMedium messages, 1 RNPacketPriorityLow will be sent.
    /// Messages at this priority and lower are buffered to be sent in groups at 10 millisecond intervals to reduce UDP overhead and better measure congestion control.
    RNPacketPriorityLow
};
