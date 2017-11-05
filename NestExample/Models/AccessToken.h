//
//  AccessToken.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONDecodable.h"

@interface AccessToken : NSObject<JSONDecodable, NSCoding>

@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSDate *expirationDate;

@end
