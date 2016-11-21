//
//  RNPublicKey+Internal.h
//  RakNetWrapper
//
//  Created by Sergey Abramchuk on 06.11.16.
//
//

#import "RNPublicKey.h"

#import "RakNetTypes.h"

using namespace RakNet;

@interface RNPublicKey (Internal)

@property (nonatomic, assign, readonly) PublicKey *publicKey;

@end
