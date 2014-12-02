//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "DivvyBikeStation.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *bikeStationArray;
@property NSMutableArray *stationsArray;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataTextString];
    
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
    return self.stationsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    DivvyBikeStation *bike = [self.stationsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = bike.name;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Available: %@", bike.availableBikes ];
    
    return cell;
}


-(void)loadDataTextString{
    self.bikeStationArray = [[NSMutableArray alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.divvybikes.com/stations/json/"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError *jsonError = nil;
        NSDictionary *aux  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        [self.tableView reloadData];
        
        self.bikeStationArray =[NSArray arrayWithArray:[aux objectForKey:@"stationBeanList"]];
        
        [self createStationsList];
        
        [self.tableView reloadData];
        
        NSLog(@"Connection error : %@",connectionError);
        NSLog(@"JSon Error : %@",jsonError);
    }];
}

-(void)createStationsList{
    
    self.stationsArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in self.bikeStationArray ) {
        
        //busStopAnnotation = [[MKPointAnnotation alloc] init];
        
        DivvyBikeStation *bike = [[DivvyBikeStation alloc]initWithDictionary:dic];
        
        
        [self.stationsArray addObject:bike];

    }
}

@end
