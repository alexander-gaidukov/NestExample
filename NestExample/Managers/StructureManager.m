//
//  StructureManager.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "StructureManager.h"
#import "RESTClient.h"
#import "Constants.h"
#import "Structure.h"

@interface StructureManager()
@property(nonatomic, strong) RESTClient *client;
@property(nonatomic, strong) NSMutableArray<Structure *> *mutableStructures;
@end

@implementation StructureManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static StructureManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        RESTClient *restClient = [[RESTClient alloc] initWithBaseURL:[NSURL URLWithString:NestAPIEndpoint]];
        sharedInstance = [[StructureManager alloc] initWithRESTClient: restClient];
    });
    
    return sharedInstance;
}

- (instancetype)initWithRESTClient: (RESTClient *)client {
    if(self = [super init]) {
        self.client = client;
        self.mutableStructures = [@[] mutableCopy];
    }
    return self;
}

- (NSArray<Structure *> *)structures {
    return [self.mutableStructures copy];
}

- (void)loadStructuresWithCompletion:(void (^)(NSError *))completionBlock {
    
    __weak typeof(self) weakSelf = self;
    
    [self.client loadFromPath:@"structures" method:HTTPMethodGET params:[NSDictionary dictionary] success:^(NSDictionary *json) {
        if(!weakSelf) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.mutableStructures removeAllObjects];
        NSArray *allValues = json.allValues;
        for (NSDictionary *structureJSON in allValues) {
            Structure *structure = [[Structure alloc] initWith:structureJSON];
            [strongSelf.mutableStructures addObject:structure];
            if (strongSelf.delegate) {
                [strongSelf.delegate structureManagerDidUpdateData:self];
            }
        }
        
        if (completionBlock) {
            completionBlock(nil);
        }
    } failure:^(NSError *error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

@end
