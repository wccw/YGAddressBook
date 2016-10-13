//
//  ContactTableViewCell.h
//  YGAddressBook
//
//  Created by wyg_mac on 16/10/11.
//  Copyright © 2016年 wangyaoguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contactImg;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactPhone;
@property (weak, nonatomic) IBOutlet UILabel *contactAbbr;

@end
