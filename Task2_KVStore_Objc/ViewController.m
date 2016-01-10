//
//  ViewController.m
//  Task2_KVStore_Objc
//
//  Created by Smita Tamboli on 1/10/16.
//  Copyright © 2016 Cybage. All rights reserved.
//

#import "ViewController.h"
#import "Contacts.h"
#import "AllContactTableViewViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIAlertView *alertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(_contactDB);
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveData:(id)sender {
    
    if (self.name.text.length == 0 || self.address.text.length == 0) {
        alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Both fields are required." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        sqlite3_stmt    *statement;
        const char *dbpath = [_databasePath UTF8String];
        
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            Contacts *contact = [[Contacts alloc] init];
            contact.name = _name.text;
            contact.address = _address.text;
            
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO CONTACTS (name, address) VALUES (\"%@\", \"%@\")",
                                   contact.name, contact.address];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_contactDB, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                _name.text = @"";
                _address.text = @"";
                alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Data Saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
                
                
            } else {
                alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Failed to save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            sqlite3_finalize(statement);
            sqlite3_close(_contactDB);
        }
        
    }
}
- (IBAction)displayAllContacts:(id)sender {
    NSArray *allContactArray = [self fetchAllContacts];
    
    if (allContactArray.count == 0) {
        alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No contact found." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }else {
        AllContactTableViewViewController  *allContactViewController = (AllContactTableViewViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AllContactTableViewViewController"];
        allContactViewController.allContactArray = allContactArray;
        [self.navigationController pushViewController:allContactViewController animated:YES];
    }
}

-(NSMutableArray *)fetchAllContacts {
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT name, address FROM CONTACTS";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Contacts *contact = [[Contacts alloc] init];
                contact.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                contact.address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [contactList addObject:contact];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
    return contactList;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}
@end
