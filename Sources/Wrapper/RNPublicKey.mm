//
//  RNPublicKey.m
//  RakNetWrapper
//
//  Created by Sergey Abramchuk on 06.11.16.
//
//

#include <cstring>

#import "RNPublicKey.h"
#import "RNPublicKey+Internal.h"

using namespace RakNet;


@interface RNPublicKey () {
    PublicKey *_publicKey;
    
    NSUInteger _serverPublicKeyLength;
    NSUInteger _ownPublicKeyLength;
    NSUInteger _ownPrivateKeyLength;
}

@end


@implementation RNPublicKey (Internal)

- (PublicKey *)publicKey {
    return _publicKey;
}

@end


@implementation RNPublicKey

- (RNPublicKeyMode)publicKeyMode {
    switch (_publicKey->publicKeyMode) {
        case PKM_INSECURE_CONNECTION:
            return RNPublicKeyModeInsecureConnection;
            
        case PKM_ACCEPT_ANY_PUBLIC_KEY:
            return RNPublicKeyModeAcceptAnyPublicKey;
            
        case PKM_USE_KNOWN_PUBLIC_KEY:
            return RNPublicKeyModeUseKnownPublicKey;
            
        case PKM_USE_TWO_WAY_AUTHENTICATION:
            return RNPublicKeyModeUseTwoWayAuthentication;
    }
}

- (void)setPublicKeyMode:(RNPublicKeyMode)publicKeyMode {
    switch (publicKeyMode) {
        case RNPublicKeyModeInsecureConnection:
            _publicKey->publicKeyMode = PKM_INSECURE_CONNECTION;
            break;
            
        case RNPublicKeyModeAcceptAnyPublicKey:
            _publicKey->publicKeyMode = PKM_ACCEPT_ANY_PUBLIC_KEY;
            break;
            
        case RNPublicKeyModeUseKnownPublicKey:
            _publicKey->publicKeyMode = PKM_USE_KNOWN_PUBLIC_KEY;
            break;
            
        case RNPublicKeyModeUseTwoWayAuthentication:
            _publicKey->publicKeyMode = PKM_USE_TWO_WAY_AUTHENTICATION;
            break;
    }
}

- (NSData *)serverPublicKey {
    if (_serverPublicKeyLength > 0) {
        char *data = _publicKey->remoteServerPublicKey;
        return [NSData dataWithBytes:data length:_serverPublicKeyLength];
    } else {
        return nil;
    }
}

- (void)setServerPublicKey:(NSData *)publicKey {
    if (_publicKey->remoteServerPublicKey != NULL) {
        delete _publicKey->remoteServerPublicKey;
    }
    
    _serverPublicKeyLength = publicKey != nil ? [publicKey length] : 0;
    
    if (_serverPublicKeyLength > 0) {
        char *data = new char[_serverPublicKeyLength];
        std::memcpy(data, [publicKey bytes], _serverPublicKeyLength);
        
        _publicKey->remoteServerPublicKey = data;
    } else {
        _publicKey->remoteServerPublicKey = NULL;
    }
}

- (NSData *)ownPublicKey {
    if (_ownPublicKeyLength > 0) {
        char *data = _publicKey->myPublicKey;
        return [NSData dataWithBytes:data length:_ownPublicKeyLength];
    } else {
        return nil;
    }
}

- (void)setOwnPublicKey:(NSData *)publicKey {
    if (_publicKey->myPublicKey != NULL) {
        delete _publicKey->myPublicKey;
    }
    
    _ownPublicKeyLength = publicKey != nil ? [publicKey length] : 0;
    
    if (_ownPublicKeyLength > 0) {
        char *data = new char[_ownPublicKeyLength];
        std::memcpy(data, [publicKey bytes], _ownPublicKeyLength);
        
        _publicKey->myPublicKey = data;
    } else {
        _publicKey->myPublicKey = NULL;
    }
}

- (NSData *)ownPrivateKey {
    if (_ownPrivateKeyLength > 0) {
        char *data = _publicKey->myPrivateKey;
        return [NSData dataWithBytes:data length:_ownPrivateKeyLength];
    } else {
        return nil;
    }
}

- (void)setOwnPrivateKey:(NSData *)privateKey {
    if (_publicKey->myPrivateKey != NULL) {
        delete _publicKey->myPrivateKey;
    }
    
    _ownPrivateKeyLength = privateKey != nil ? [privateKey length] : 0;
    
    if (_ownPrivateKeyLength > 0) {
        char *data = new char[_ownPrivateKeyLength];
        std::memcpy(data, [privateKey bytes], _ownPrivateKeyLength);
        
        _publicKey->myPrivateKey = data;
    } else {
        _publicKey->myPrivateKey = NULL;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _publicKey = new PublicKey();
        
        _serverPublicKeyLength = 0;
        _ownPublicKeyLength = 0;
        _ownPrivateKeyLength = 0;
    }
    return self;
}

- (void)dealloc
{
    if (_publicKey->remoteServerPublicKey != NULL) {
        delete _publicKey->remoteServerPublicKey;
    }
    
    if (_publicKey->myPublicKey != NULL) {
        delete _publicKey->myPublicKey;
    }
    
    if (_publicKey->myPrivateKey != NULL) {
        delete _publicKey->myPrivateKey;
    }
    
    delete _publicKey;
}

@end
