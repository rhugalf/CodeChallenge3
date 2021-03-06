//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "DivvyBikeStation.h"
#import "MapViewController.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *bikeStationArray;
@property NSMutableArray *stationsArray;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataTextString:@""];
    
    self.searchBar.delegate = self;
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self loadDataTextString:self.searchBar.text];
    
    self.searchBar.text=@"";
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


-(void)loadDataTextString:(NSString *) param{
    self.bikeStationArray = [[NSMutableArray alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.divvybikes.com/stations/json"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError *jsonError = nil;
        NSDictionary *aux  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        [self.tableView reloadData];
        
        self.bikeStationArray =[NSArray arrayWithArray:[aux objectForKey:@"stationBeanList"]];
        
        [self createStationsList:param];
        
        [self.tableView reloadData];
        
        NSLog(@"Connection error : %@",connectionError);
        NSLog(@"JSon Error : %@",jsonError);
    }];
}

-(void)createStationsList:(NSString *) param{
    
    self.stationsArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in self.bikeStationArray ) {
        
        DivvyBikeStation *bike = [[DivvyBikeStation alloc]initWithDictionary:dic];
        
        if([param isEqualToString:@""])
        {
            [self.stationsArray addObject:bike];
        }else if([bike.name containsString:param]){
            [self.stationsArray addObject:bike];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell{
    if([segue.identifier isEqualToString:@"ToMapSegue"]){
        MapViewController *mapView = segue.destinationViewController;
        
        mapView.divvyBikesSt = [self.stationsArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
    }
}

@end
