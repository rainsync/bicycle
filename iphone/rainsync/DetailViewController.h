//
//  DetailViewController.h
//  rainsync
//
//  Created by 승원 김 on 12. 11. 6..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <MKMapViewDelegate>
{
    MKPolyline *line;
    MKPolylineView *view;
    
    UITableViewCell *_mapCell;
    BOOL _preferCoord;
}
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;

@property (retain, nonatomic) IBOutlet UILabel *recordingDay;
@property (strong, nonatomic) IBOutlet UILabel *recordingTime;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *altitude;
@property (strong, nonatomic) IBOutlet UILabel *averageSpeed;
@property (strong, nonatomic) IBOutlet UILabel *calorie;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *rectime;
@property (strong, nonatomic) NSString *dist;
@property (strong, nonatomic) NSString *altit;
@property (strong, nonatomic) NSString *avgs;
@property (strong, nonatomic) NSString *calo;

// cell generators
- (UITableViewCell *)blankCell;
- (UITableViewCell *)cellForAddressDictionaryIndex:(NSInteger)index; // 10
- (UITableViewCell *)cellForLocationIndex:(NSInteger)index; // 8
- (UITableViewCell *)cellForRegionIndex:(NSInteger)index; // 4
- (UITableViewCell *)cellForMapView;
- (UITableViewCell *)cellForMapURL;

@end
