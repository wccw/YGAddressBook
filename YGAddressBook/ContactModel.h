//
//  ContactModel.h
//  YGAddressBook
//
//  Created by wyg_mac on 16/10/11.
//  Copyright © 2016年 wangyaoguo. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * contactName               联系人姓名
 * contactPhone              联系人电话
 * contactImage              联系人头像
 * contactNameLastCharacter  联系人姓名最后一个字符（无头像时，用字符代替）
 * contactNameFirstCharacter 联系人姓名拼音第一个字符，用于分组
 * contactNamePinyin         联系人姓名拼音(用于排序)
 *
 */
@interface ContactModel : NSObject

@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *contactImage;
@property (nonatomic, copy) NSString *contactNameLastCharacter;
@property (nonatomic, copy) NSString *contactNameFirstCharacter;
@property (nonatomic, copy) NSString *contactNamePinyin;

@end
