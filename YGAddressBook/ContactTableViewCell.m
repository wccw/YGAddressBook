//
//  ContactTableViewCell.m
//  YGAddressBook
//
//  Created by wyg_mac on 16/10/11.
//  Copyright © 2016年 wangyaoguo. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _contactImg.layer.cornerRadius = 15;
    _contactImg.layer.masksToBounds = YES;
    _contactImg.layer.borderWidth = 1;
    _contactImg.layer.borderColor = [UIColor greenColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
