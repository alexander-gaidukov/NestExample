//
//  StructureManager.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StructureManager;

@protocol StructureManagerDelegate<NSObject>

- (void)structureManagerDidUpdateData:(StructureManager *)structureManager;

@end

@interface StructureManager : NSObject

@property (nonatomic, strong, readonly) NSArray *structures;
@property (nonatomic, weak) id<StructureManagerDelegate> delegate;

+ (instancetype) sharedInstance;

- (void)loadStructuresWithCompletion:(void (^)(NSError *error))completionBlock;

@end
