//
//  AllContactTableViewViewController.h
//  Task2_KVStore_Objc
//
//  Created by Smita Tamboli on 1/10/16.
//  Copyright © 2016 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllContactTableViewViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray* allContactArray;
@end
