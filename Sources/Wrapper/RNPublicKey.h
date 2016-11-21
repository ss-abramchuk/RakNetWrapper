//
//  RNPublicKey.h
//  RakNetWrapper
//
//  Created by Sergey Abramchuk on 06.11.16.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, RNPublicKeyMode) {
    /// The connection is insecure.
    RNPublicKeyModeInsecureConnection,

    /// Accept whatever public key the server gives us. This is vulnerable to man in the middle, but does not require
    /// distribution of the public key in advance of connecting.
    RNPublicKeyModeAcceptAnyPublicKey,
    
    /// Use a known remote server public key. serverPublicKey of RNPublicKey must be non-nil.
    /// This is the recommended mode for secure connections.
    RNPublicKeyModeUseKnownPublicKey,
    
    /// Use a known remote server public key AND provide a public key for the connecting client.
    /// serverPublicKey, ownPublicKey and ownPrivateKey of RNPublicKey must be all be non-nil.
    /// The server must cooperate for this mode to work.
    /// I recommend not using this mode except for server-to-server communication as it significantly increases the CPU requirements during connections for both sides.
    /// Furthermore, when it is used, a connection password should be used as well to avoid DoS attacks.
    RNPublicKeyModeUseTwoWayAuthentication
};

@interface RNPublicKey : NSObject

/**
 How to interpret the public key. See description of RNPublicKeyMode values.
 */
@property (nonatomic) RNPublicKeyMode publicKeyMode;

/**
 Pointer to a server public key.
 */
@property (nonatomic, nullable) NSData *serverPublicKey;

/**
 Pointer to an own public key
 */
@property (nonatomic, nullable) NSData *ownPublicKey;

/**
 Pointer to aa own private key
 */
@property (nonatomic, nullable) NSData *ownPrivateKey;

- (nonnull instancetype)init;

@end
