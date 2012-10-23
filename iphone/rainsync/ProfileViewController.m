//
//  ProfileViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 23..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "ProfileViewController.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self test];
}




- (void)test
{
    NetUtility* net = [[[NetUtility alloc] init] autorelease];
    [net getURL:@"http://www.search.twitter.com/search.json?q=from:nathanhjones" withBlock:^(NSData* result){
        
        //NSString* test= [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding ];
        
         // convert to JSON
         NSError *myError = nil;
         NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"error %@", myError);
        
         // show all values
         for(id key in res) {
         
         id value = [res objectForKey:key];
         
         NSString *keyAsString = (NSString *)key;
         NSString *valueAsString = (NSString *)value;
         
         NSLog(@"key: %@", keyAsString);
         NSLog(@"value: %@", valueAsString);
         }
         
         // extract specific value...
         NSArray *results = [res objectForKey:@"results"];
         
         for (NSDictionary *result in results) {
         NSString *icon = [result objectForKey:@"icon"];
         NSLog(@"icon: %@", icon);
         }
        
     [result release];
     
     

    }];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
