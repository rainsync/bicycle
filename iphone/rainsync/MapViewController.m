//
//  MapViewController.m
//  rainsync
//
//  Created by xorox64 on 12. 10. 22..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _routeViews = [[NSMutableDictionary alloc] init];
        
        //[self.mapView addAnnotation:];
        t=false;
        

         

        
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!t){
    RidingManager *ridingManager =[RidingManager getInstance];
    CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:[ridingManager getlocations]] autorelease];
    [self.mapView addAnnotation:routeAnnotation];
        t=true;
    }
    

        // Do any additional setup after loading the view from its nib.
}


- (IBAction)changeToMap:(id)sender {
    self.mapView.mapType = MKMapTypeStandard;
}
- (IBAction)changeToSatellite:(id)sender {
    self.mapView.mapType = MKMapTypeSatellite;
}
- (IBAction)changeToHybrid:(id)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition.
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = YES;
	}
	
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display.
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}
	
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKAnnotationView* annotationView = nil;
	
    
    /*
	if([annotation isKindOfClass:[CSMapAnnotation class]])
	{
		// determine the type of annotation, and produce the correct type of annotation view for it.
		CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
		if(csAnnotation.annotationType == CSMapAnnotationTypeStart ||
		   csAnnotation.annotationType == CSMapAnnotationTypeEnd)
		{
			NSString* identifier = @"Pin";
			MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			
			if(nil == pin)
			{
				pin = [[[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier] autorelease];
			}
			
			[pin setPinColor:(csAnnotation.annotationType == CSMapAnnotationTypeEnd) ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen];
			
			annotationView = pin;
		}
		else if(csAnnotation.annotationType == CSMapAnnotationTypeImage)
		{
			NSString* identifier = @"Image";
			
			CSImageAnnotationView* imageAnnotationView = (CSImageAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			if(nil == imageAnnotationView)
			{
				imageAnnotationView = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
				imageAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			}
			
			annotationView = imageAnnotationView;
		}
		
		[annotationView setEnabled:YES];
		[annotationView setCanShowCallout:YES];
	}
	
	else 
    */
    
    if([annotation isKindOfClass:[CSRouteAnnotation class]])
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annotationView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annotationView)
		{
			CSRouteView* routeView = [[[CSRouteView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)] autorelease];
            
			routeView.annotation = routeAnnotation;
			routeView.mapView = mapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annotationView = routeView;
		}
	}
	
	return annotationView;
}



         - (void)viewDidUnload {
             [_mapView release];
             _mapView = nil;
             [super viewDidUnload];
         }
         - (void)dealloc {
             [_mapView release];
             [super dealloc];
         }

@end
