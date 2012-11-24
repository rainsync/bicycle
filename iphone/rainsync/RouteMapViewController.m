//
//  MapManager.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 19..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "RouteMapViewController.h"

@implementation RouteMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        users = [[NSMutableArray alloc] init];
        route_lines = [[NSMutableArray alloc]init];
        route_views = [[NSMutableArray alloc]init];
        
        profile_annotation = [[NSMutableArray alloc]init];
        profile_views = [[NSMutableArray alloc]init];
    line_color = [[NSArray alloc] initWithArray:@[[UIColor redColor],[UIColor colorWithHexString:@"008fd5"], [UIColor colorWithHexString:@"e6a9b8"], [UIColor blackColor], [UIColor whiteColor]]];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clear:) name:@"clear" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPoint:) name:@"addPoint" object:nil];
        width=1;
        // Custom initialization
    }
    return self;
}

- (NSInteger) getUserNum:(NSInteger)userid
{
    for(int i=0; i<[users count]; ++i){
        NSInteger name= [[users objectAtIndex:i] intValue];
        if(name==userid)
            return i;
    }
    
    return -1;
    
}

- (NSInteger) createUser:(NSInteger)userid
{
    [users addObject:[NSNumber numberWithInt:userid]];
    [route_lines addObject:[NSNull null]];
    [route_views addObject:[NSNull null]];
    [profile_annotation addObject:[NSNull null]];
    [profile_views addObject:[NSNull null]];
    int i=[users count]-1;
    return i;
}



- (void) addPoint:(NSNotification *)noti
{
    
    int userid = [[[noti userInfo] objectForKey:@"uid"] intValue];
    CLLocation *newLocation = [[noti userInfo] objectForKey:@"location"];
    
    
    int pos=[self getUserNum:userid];
    if(pos==-1)
        pos = [self createUser:userid];
    
    

    CrumbPath *prev_line = [route_lines objectAtIndex:pos];
    if(prev_line == [NSNull null])
    {
        prev_line = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
        [route_lines replaceObjectAtIndex:pos withObject:prev_line];
        [_mapView addOverlay:prev_line];
        MKPointAnnotation *point =[[MKPointAnnotation alloc] init];
        [profile_annotation replaceObjectAtIndex:pos withObject:point];
        [_mapView addAnnotation:point];
        [point release];
        
        NSLog(@"changed..");
        
        
    }else{
        
        [[profile_annotation objectAtIndex:pos] setCoordinate:newLocation.coordinate];
        
        MKMapRect updateRect = [prev_line addCoordinate:newLocation.coordinate];
        CrumbPathView *view = [route_views objectAtIndex:pos];
        
        if (!MKMapRectIsNull(updateRect) && view != [NSNull null])
        {
            

            // There is a non null update rect.
            // Compute the currently visible map zoom scale
            MKZoomScale currentZoomScale = (CGFloat)(_mapView.bounds.size.width / _mapView.visibleMapRect.size.width);
            // Find out the line width at this zoom scale and outset the updateRect by that amount
            CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
            // Ask the overlay view to update just the changed area.
            [view setNeedsDisplayInMapRect:updateRect];
            

        }
        
    }


    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *AnnotationViewID= @"annotationViweID";
    
    PictureAnnotationView *reuse =
    (PictureAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if(reuse){
        reuse.annotation = annotation;
        return reuse;
    }
    
    MKAnnotationView* annotatioView = nil;
    
    
    for(int i=0; i<[profile_views count]; ++i){
        if(annotation == [profile_annotation objectAtIndex:i]){
            PictureAnnotationView *view = [profile_views objectAtIndex:i];
            
            if(view == [NSNull null])
            {
                view = [[PictureAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
                [profile_views replaceObjectAtIndex:i withObject:view];
                
            }
            view.annotation=annotation;
            
            annotatioView = view;
            break;
        }
    }
    
    return annotatioView;
    
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    
	MKOverlayView* overlayView = nil;

    
    for(int i=0; i<[route_lines count]; ++i){
        if(overlay == [route_lines objectAtIndex:i]){
            CrumbPathView *view = [route_views objectAtIndex:i];
            
            if(view == [NSNull null])
            {
                view = [[CrumbPathView alloc] initWithOverlay:overlay];
                [view setColor:line_color[i]];
                width+=1;
                [view setWidth:(double)10/(1<<width)];
                
                [route_views replaceObjectAtIndex:i withObject:view];
                
                //view.fillColor = [UIColor redColor];
                //view.strokeColor = [UIColor redColor];
                //view.lineWidth = 3;
            }
            overlayView = view;
            break;
        }
    }
    
    return overlayView;
    
}



- (void) clear:(NSNotification *)noti
{
    [_mapView removeOverlays:route_lines];
    [_mapView removeAnnotations:profile_annotation];
    [users removeAllObjects];
    [route_lines removeAllObjects];
    [route_views removeAllObjects];
    [profile_annotation removeAllObjects];
    [profile_views removeAllObjects];
    width=1;
}

@end
