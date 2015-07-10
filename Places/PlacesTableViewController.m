//
//  PlacesTableViewController.m
//  Places
//
//  Created by ios2 on 7/9/15.
//  Copyright (c) 2015 Gabriela. All rights reserved.
//

#import "PlacesTableViewController.h"
#import  <GoogleMaps/GoogleMaps.h>
#import "DetailsViewController.h"
#import "PlacesTableViewCell.h"

@interface PlacesTableViewController ()
@property(strong,nonatomic) GMSPlacesClient * placesClient;

@property(weak,nonatomic) GMSAutocompletePrediction *result;
@property(strong,nonatomic) NSMutableDictionary *dictionary;
@property(strong,nonatomic) NSMutableArray *letters;
@property(strong,nonatomic) GMSPlace * places;
@end

@implementation PlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _placesClient =[[GMSPlacesClient alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _dictionary=[[NSMutableDictionary alloc]init];
    _letters=[[NSMutableArray alloc]init];
    for(char a='a'; a<='z';a++)
    {
        [_letters addObject:[NSString stringWithFormat:@"%c",a]];
    }
    for(NSString *key in _letters)
    {
        [self placeAutocomplete:key];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailsViewController *detailsViewController=segue.destinationViewController;
    detailsViewController.place=_places;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_letters count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *key=[_letters objectAtIndex:section];
    NSArray *results=[self.dictionary objectForKey:key];
    return [results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
static    NSString *MyIdentifierOdd = @"OddCell";
static    NSString *MyIdentifierEven = @"EvenCell";
   
    PlacesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:(indexPath.row %2 == 0) ? MyIdentifierEven : MyIdentifierOdd];
    if(cell==nil){
        cell=[[PlacesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(indexPath.row %2 == 0) ? MyIdentifierEven : MyIdentifierOdd ];
        
    }
    
    NSString *key=[_letters objectAtIndex:indexPath.section];
    NSArray *results=[self.dictionary objectForKey:key];
    GMSAutocompletePrediction *result= results[indexPath.row];
    [cell.labels setText:[[ result attributedFullText] string]];
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return [NSString stringWithFormat:@"%@",[_letters objectAtIndex:section]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (void)placeAutocomplete:(NSString*)key {
    CLLocationCoordinate2D left= CLLocationCoordinate2DMake(44.437714,26.070900);
    CLLocationCoordinate2D right= CLLocationCoordinate2DMake(44.431278,26.082401);
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:left
                                                                       coordinate:right];
   
    [ _placesClient autocompleteQuery:key
                              bounds:bounds
                              filter:nil
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                                
                                for (GMSAutocompletePrediction* result in results) {
                                    NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                                
                                }
                                
                                [self.dictionary setObject:results forKey:key];
                                [self.tableView reloadData];
                            }];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key=[_letters objectAtIndex:indexPath.section];
    NSArray *results=[self.dictionary objectForKey:key];
    GMSAutocompletePrediction *result= results[indexPath.row];
    
    NSString *placeID=[result placeID];
    [_placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        _places=place;
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        

        [self performSegueWithIdentifier:@"ShowDetails" sender:self];
    }];
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
