//
//  LinesTableViewController.m
//  MyWmataApp
//
//  Created by Aashima Singh on 6/21/16.
//  Copyright © 2016 Aashima Singh. All rights reserved.
//

#import "LinesTableViewController.h"
#import "Line.h"
#import "Stations.h"
#import "StationTableViewController.h"

@interface LinesTableViewController () {
    
    NSMutableArray *mainLines;
}

@end

@implementation LinesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strLines = @"https://api.wmata.com/Rail.svc/json/jLines?api_key=6b700f7ea9db408e9745c207da7ca827";
    
    NSData *lineData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strLines]];
    
    NSDictionary *allLinesDict = [NSJSONSerialization JSONObjectWithData:lineData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@", allLinesDict);
    
    mainLines = [[NSMutableArray alloc] init];
    
    for(NSDictionary *eachLineDict in [allLinesDict objectForKey:@"Lines"]){
        Line *eachLine = [[Line alloc] init];
        eachLine.lineCode = [eachLineDict objectForKey:@"LineCode"];
        eachLine.lineName = [eachLineDict objectForKey:@"DisplayName"];
        
        NSString *path;
        if([eachLine.lineCode isEqualToString:@"BL"]){
            path = [[NSBundle mainBundle] pathForResource:@"blue" ofType:@"json"];
        }
        if([eachLine.lineCode isEqualToString:@"GR"]){
            path = [[NSBundle mainBundle] pathForResource:@"green" ofType:@"json"];
        }
        if([eachLine.lineCode isEqualToString:@"YL"]){
            path = [[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"json"];
        }
        if([eachLine.lineCode isEqualToString:@"OR"]){
            path = [[NSBundle mainBundle] pathForResource:@"orange" ofType:@"json"];
        }
        if([eachLine.lineCode isEqualToString:@"RD"]){
            path = [[NSBundle mainBundle] pathForResource:@"red" ofType:@"json"];
        }
        if([eachLine.lineCode isEqualToString:@"SV"]){
            path = [[NSBundle mainBundle] pathForResource:@"silver" ofType:@"json"];
        }
        
//        NSString *stURL = [NSString stringWithFormat:@"https://api.wmata.com/Rail.svc/json/jStations?LineCode=%@&api_key=6b700f7ea9db408e9745c207da7ca827",eachLine.lineCode];
        
        NSData *stData = [NSData dataWithContentsOfFile:path];
        
        NSDictionary *allStations = [NSJSONSerialization JSONObjectWithData:stData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *stationArray = [[NSMutableArray alloc] init];
        
        for(NSDictionary *eachStation in [allStations objectForKey:@"Stations"]){
            Stations *station = [[Stations alloc] init];
            station.stationName = [eachStation objectForKey:@"Name"];
            station.stationCode = [eachStation objectForKey:@"Code"];
            [stationArray addObject:station];
        }
        
        eachLine.stationList = stationArray;
        
        
        [mainLines addObject:eachLine];
        
    }

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return mainLines.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Line *eachLine = [mainLines objectAtIndex:section];
    return eachLine.stationList.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    Line *eachLine = [mainLines objectAtIndex:section];
    
    return eachLine.lineName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Line *eachLine = [mainLines objectAtIndex:indexPath.section];
    
    Stations *station = [eachLine.stationList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = station.stationName;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    StationTableViewController *svc = segue.destinationViewController;
    
//    getting index path for each row that is selected
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
//    getting each Line from mainLines array, They are stored in section headers
    Line *line = [mainLines objectAtIndex:path.section];
    
// getting each station from line for each section. Sections are stored in row
    Stations *station = [line.stationList objectAtIndex:path.row];
    
    svc.title = station.stationName;
    svc.stCode = station.stationCode;
    
    
    
    
    
}


@end
