//
//  StructureTableViewCell.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 07/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Structure;

@interface StructureTableViewCell : UITableViewCell

- (void)configureWithStructure:(Structure *)structure;

@end
