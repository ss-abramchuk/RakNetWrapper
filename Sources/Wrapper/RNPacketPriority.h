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
    RNPacketPriorityImmediatePriority,
    /// For every 2 RNPacketPriorityImmediatePriority messages, 1 RNPacketPriorityHighPriority will be sent.
    /// Messages at this priority and lower are buffered to be sent in groups at 10 millisecond intervals to reduce UDP overhead and better measure congestion control.
    RNPacketPriorityHighPriority,
    /// For every 2 RNPacketPriorityHighPriority messages, 1 RNPacketPriorityMediumPriority will be sent.
    /// Messages at this priority and lower are buffered to be sent in groups at 10 millisecond intervals to reduce UDP overhead and better measure congestion control.
    RNPacketPriorityMediumPriority,
    /// For every 2 RNPacketPriorityMediumPriority messages, 1 RNPacketPriorityLowPriority will be sent.
    /// Messages at this priority and lower are buffered to be sent in groups at 10 millisecond intervals to reduce UDP overhead and better measure congestion control.
    RNPacketPriorityLowPriority
};
