#import "ClosedGroupCiphertextMessage.h"
#import "AxolotlExceptions.h"
#import <SessionAxolotlKit/SessionAxolotlKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@implementation ClosedGroupCiphertextMessage

- (instancetype)init_throws_withIVAndCiphertext:(NSData *)ivAndCiphertext senderPublicKey:(NSString *)senderPublicKey keyIndex:(uint32_t)keyIndex {
    if (self = [super init]) {
        _ivAndCiphertext = ivAndCiphertext;
        _senderPublicKey = senderPublicKey;
        _keyIndex = keyIndex;

        SPKProtoClosedGroupCiphertextMessageBuilder *builder = [SPKProtoClosedGroupCiphertextMessage builderWithCiphertext:ivAndCiphertext
                                                                                                           senderPublicKey:senderPublicKey
                                                                                                                  keyIndex:keyIndex];

        NSError *error;
        NSData *_Nullable serialized = [builder buildSerializedDataAndReturnError:&error];
        if (serialized == nil || error != nil) {
            OWSFailDebug(@"Couldn't serialize proto due to error: %@.", error);
            OWSRaiseException(InvalidMessageException, @"Couldn't serialize proto.");
        }
        
        _serialized = serialized;
    }
    return self;
}

- (CipherMessageType)cipherMessageType {
    return CipherMessageType_ClosedGroupCiphertext;
}

@end

NS_ASSUME_NONNULL_END