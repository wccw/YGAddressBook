//
//  ViewController.m
//  YGAddressBook
//
//  Created by wyg_mac on 16/10/10.
//  Copyright © 2016年 wangyaoguo. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import "ContactTableViewCell.h"
#import "ContactModel.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *totalArray;
    NSMutableArray *titleArray;
    UITableView *addressbookTable;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"通讯录";

    addressbookTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    addressbookTable.dataSource = self;
    addressbookTable.delegate = self;
    [self.view addSubview:addressbookTable];
    [addressbookTable registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"contactCell"];
    
    [self addressBook];
}


#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return totalArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactModel *mod = totalArray[indexPath.section][indexPath.row];
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    cell.contactAbbr.text = mod.contactNameLastCharacter;
    cell.contactName.text = mod.contactName;
    cell.contactPhone.text = mod.contactPhone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 30)];
    label.text = titleArray[section];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.layer.cornerRadius = 15;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.layer.backgroundColor = [UIColor greenColor].CGColor;
    [view addSubview:label];
    return view;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [NSMutableArray new];
    for (char c = 'a'; c <= 'z'; ++c) {
        [array addObject:[NSString stringWithFormat:@"%c",c]];
    }
    return array;
}


#pragma mark - get addressbook
-(void)addressBook
{
    ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
        if (granted == YES) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            NSArray *arrayAllPerson = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressbook);
            for(int i = 0; i < arrayAllPerson.count; i ++) {
                ABRecordRef person = (__bridge ABRecordRef)(arrayAllPerson[i]);
                NSString *name = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                ABMultiValueRef ref = ABRecordCopyValue(person, kABPersonPhoneProperty);
                NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(ref, 0));
                if (name != nil && phone != nil) {
                    ContactModel *model = [ContactModel new];
                    model.contactName = name;
                    model.contactPhone = phone;
                    model.contactNamePinyin = [self chineseTranslateEnglish:name];
                    model.contactNameLastCharacter = [name substringFromIndex:name.length - 1];
                    model.contactNameFirstCharacter = [NSString stringWithFormat:@"%c",[model.contactNamePinyin characterAtIndex:0]];
                    [array addObject:model];
                }
            }
            [self sortAddressBook:array];
        }
    });
}

#pragma mark - sort addressbook
-(void)sortAddressBook:(NSMutableArray *)array
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"contactNamePinyin" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    
    NSArray *arrayData = (NSArray *)array;
    NSMutableArray *temp = [NSMutableArray new];
    for (ContactModel *mod in arrayData) {
        [temp addObject:mod.contactNameFirstCharacter];
    }
    NSSet *titleSet = [NSSet setWithArray:temp];
    titleArray = [NSMutableArray new];
    for (NSString *str in titleSet) {
        [titleArray addObject:str];
    }
    NSMutableArray *arrayRes = [NSMutableArray new];
    for (NSString *str in titleArray) {
        NSMutableArray *arraySection = [NSMutableArray new];
        for (ContactModel *mod in arrayData) {
            if ([mod.contactNameFirstCharacter isEqualToString:str]) {
                [arraySection addObject:mod];
            }
        }
        [arrayRes addObject:arraySection];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        totalArray = arrayRes;
        [addressbookTable reloadData];
    });
}

#pragma mark - chinese -> english
-(NSString *)chineseTranslateEnglish:(NSString *)string
{
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    mutableString = (NSMutableString *)[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mutableString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
