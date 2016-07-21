//
//  RNPacketReliability.h
//  MCPEServer
//
//  Created by Sergey Abramchuk on 21.12.15.
//  Copyright © 2015 ss-abramchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

/// These enumerations are used to describe how packets are delivered.
typedef NS_ENUM (unsigned char, RNPacketReliability) {
    /// Same as regular UDP, except that it will also discard duplicate datagrams. RakNet adds (6 to 17) + 21 bits of overhead, 16 of which is used to detect duplicate packets and 6 to 17 of which is used for message length.
    RNPacketReliabilityUnreliable,
    /// Regular UDP with a sequence counter. Out of order messages will be discarded.
    /// Sequenced and ordered messages sent on the same channel will arrive in the order sent.
    RNPacketReliabilityUnreliableSequenced,
    /// The message is sent reliably, but not necessarily in any order. Same overhead as RNPacketReliabilityUnreliable.
    RNPacketReliabilityReliable,
    /// This message is reliable and will arrive in the order you sent it. Messages will be delayed while waiting for out of order messages. Same overhead as RNPacketReliabilityUnreliableSequenced.
    /// Sequenced and ordered messages sent on the same channel will arrive in the order sent.
    RNPacketReliabilityReliableOrdered,
    /// This message is reliable and will arrive in the sequence you sent it. Out or order messages will be dropped.  Same overhead as RNPacketReliabilityUnreliableSequenced.
    /// Sequenced and ordered messages sent on the same channel will arrive in the order sent.
    RNPacketReliabilityReliableSequenced,
    /// Same as RNPacketReliabilityUnreliable, however the user will get either ID_SND_RECEIPT_ACKED or ID_SND_RECEIPT_LOSS based on the result of sending this message when calling [RNPeerInterface receive:]. Bytes 1-4 will contain the number returned from the [RNPeerInterface send:] function. On disconnect or shutdown, all messages not previously acked should be considered lost.
    RNPacketReliabilityUnreliableWithAckReceipt,
    /// Same as RNPacketReliabilityReliable. The user will also get ID_SND_RECEIPT_ACKED after the message is delivered when calling [RNPeerInterface receive:]. ID_SND_RECEIPT_ACKED is returned when the message arrives, not necessarily the order when it was sent. Bytes 1-4 will contain the number returned from the [RNPeerInterface send:] function. On disconnect or shutdown, all messages not previously acked should be considered lost. This does not return ID_SND_RECEIPT_LOSS.
    RNPacketReliabilityReliableWithAckReceipt,
    /// Same as RNPacketReliabilityReliableWithAckReceipt. The user will also get ID_SND_RECEIPT_ACKED after the message is delivered when calling [RNPeerInterface receive:]. ID_SND_RECEIPT_ACKED is returned when the message arrives, not necessarily the order when it was sent. Bytes 1-4 will contain the number returned from the [RNPeerInterface send:] function. On disconnect or shutdown, all messages not previously acked should be considered lost. This does not return ID_SND_RECEIPT_LOSS.
    RNPacketReliabilityReliableOrderedWithAckReceipt
};
