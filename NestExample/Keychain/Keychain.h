//
//  Keychain.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

+ (NSData *)loadForIdentifier: (NSString *)identifier;
+ (BOOL)saveValue:(NSData *)value forIdentifier:(NSString *)identifier;
+ (void)deleteItemForIdentifier: (NSString *)identifier;

@end
