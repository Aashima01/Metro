//
//  StationTableViewController.m
//  MyWmataApp
//
//  Created by Aashima Singh on 6/22/16.
//  Copyright © 2016 Aashima Singh. All rights reserved.
//

#import "StationTableViewController.h"
#import "NextTrain.h"

@interface StationTableViewController ()

@end

@implementation StationTableViewController {
    
    NSMutableArray *nextTrainTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *nextURL = [NSString stringWithFormat:@"https://api.wmata.com/StationPrediction.svc/json/GetPrediction/%@?api_key=6b700f7ea9db408e9745c207da7ca827",self.stCode];
    
    NSData *nextData = [NSData dataWithContentsOfURL:[NSURL URLWithString:nextURL]];
    
    NSDictionary *nextDict = [NSJSONSerialization JSONObjectWithData:nextData options:NSJSONReadingMutableContainers error:nil];
    
    nextTrainTime = [[NSMutableArray alloc] init];
    
    for(NSDictionary *st in [nextDict objectForKey:@"Trains"]){
        NextTrain *next = [[NextTrain alloc] init];
        next.dest = [st objectForKey:@"Destination"];
        next.onLine = [st objectForKey:@"Line"];
        next.minutes = [st objectForKey:@"Min"];
        
        [nextTrainTime addObject:st];
        
    }
    

}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return nextTrainTime.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nextTrain" forIndexPath:indexPath];
    
    
    NextTrain *nt = [nextTrainTime objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",nt.dest];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", nt.minutes];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
