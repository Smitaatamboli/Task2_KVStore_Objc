//
//  AllContactTableViewViewController.m
//  Task2_KVStore_Objc
//
//  Created by Smita Tamboli on 1/10/16.
//  Copyright © 2016 Cybage. All rights reserved.
//

#import "AllContactTableViewViewController.h"
#import "Contacts.h"
@interface AllContactTableViewViewController ()

@end

@implementation AllContactTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.allContactArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Contacts *contact = self.allContactArray[indexPath.row];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.address;
    
    return cell;
}

@end
