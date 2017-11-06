//
//  Keychain.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "Keychain.h"

@implementation Keychain

+ (NSMutableDictionary *) setupSearchDictionaryForIdentifier: (NSString *)identifier {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [dictionary setObject:@"NestExample" forKey:(__bridge id)kSecAttrService];
    NSData* encodedIndentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject: encodedIndentifier forKey:(__bridge id)kSecAttrGeneric];
    [dictionary setObject: encodedIndentifier forKey:(__bridge id)kSecAttrAccount];
    return dictionary;
}

+ (BOOL)updateKeychainValue:(NSData *)value forIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [Keychain setupSearchDictionaryForIdentifier:identifier];
    NSDictionary *updateDictionary = @{(__bridge id)kSecValueData: value};
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef) searchDictionary, (__bridge CFDictionaryRef) updateDictionary);
    return status == errSecSuccess;
}

#pragma mark - Facade methods

+ (NSData *)loadForIdentifier: (NSString *)identifier {
    NSMutableDictionary *searchDictionary = [Keychain setupSearchDictionaryForIdentifier:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    NSData *result = nil;
    CFTypeRef foundDict = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &foundDict);
    if (status == noErr) {
        result = (__bridge_transfer NSData *)foundDict;
    }
    
    return result;
}

+ (BOOL)saveValue:(NSData *)value forIdentifier:(NSString *)identifier {
    NSMutableDictionary *setupDictionary = [Keychain setupSearchDictionaryForIdentifier:identifier];
    [setupDictionary setObject:value forKey:(__bridge id)kSecValueData];
    [setupDictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef) setupDictionary, NULL);
    if (status == errSecSuccess) {
        return YES;
    }
    if (status == errSecDuplicateItem) {
        return [Keychain updateKeychainValue:value forIdentifier:identifier];
    }
    return NO;
}

+ (void)deleteItemForIdentifier: (NSString *)identifier {
    NSDictionary *setupDictionary = [Keychain setupSearchDictionaryForIdentifier:identifier];
    SecItemDelete((__bridge CFDictionaryRef)setupDictionary) ;
}

@end
