//
//  StructureTableViewCell.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 07/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "StructureTableViewCell.h"
#import "Structure.h"

@interface StructureTableViewCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonnull, strong) UILabel *thermostatsCountLabel;
@end

@implementation StructureTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureSubviews];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)configureSubviews {
    
    // image view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [imageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [imageView.widthAnchor constraintEqualToConstant:30.0],
                                              [imageView.heightAnchor constraintEqualToConstant:30.0],
                                              [imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10.0]
                                              ]];
    // Name label
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:nameLabel];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [nameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [NSLayoutConstraint activateConstraints:@[
                                              [nameLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [nameLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:10.0]
                                              ]];
    self.nameLabel = nameLabel;
    
    // Thermostats count label
    
    UILabel *thermostatsCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    thermostatsCountLabel.font = [UIFont systemFontOfSize:13.0];
    thermostatsCountLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:thermostatsCountLabel];
    thermostatsCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [thermostatsCountLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [thermostatsCountLabel.leadingAnchor constraintEqualToAnchor:nameLabel.trailingAnchor constant:10.0],
                                              [thermostatsCountLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10.0]
                                              ]];
    self.thermostatsCountLabel = thermostatsCountLabel;
}

- (void)configureWithStructure:(Structure *)structure {
    self.nameLabel.text = structure.name;
    self.thermostatsCountLabel.text = [NSString stringWithFormat:@"%ld", structure.thermostats.count];
}

@end
