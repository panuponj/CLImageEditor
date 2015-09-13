//
//  PFStickerShopTBViewController.m
//  Pods
//
//  Created by Panupong Jitchopjai on 8/22/2558 BE.
//
//

#import "PFStickerShopTBViewController.h"
#import <Parse/Parse.h>
#import "StickerDownloadViewController.h"
@interface PFStickerShopTBViewController ()

@end

@implementation PFStickerShopTBViewController

- (void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(id)initWithStyle:(UITableViewStyle)style className:(nullable NSString *)className
{
    className = @"prod_cate";
    self = [super initWithStyle:style className:className];
    self.pullToRefreshEnabled = true;
    self.paginationEnabled = false;
    self.objectsPerPage = 25;
    
    self.parseClassName = className;
    return  self;
    
    
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"prod_cate"];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StickerDownloadViewController *sdvc = [[StickerDownloadViewController alloc]init];
    [self presentViewController:sdvc animated:true completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    /*
    MainTableViewCell *cell = (MainTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    // cell.textLabel.text = [object objectForKey:@"text"];
    cell.nameLabel.text = [object objectForKey:@"cate_name"];
    // cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
    // [object objectForKey:@"priority"]];
    
    
    
    PFFile *featureImageFile = [object objectForKey:@"cate_file"];
    if (featureImageFile != nil) {
        [featureImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.thumbnailImageView.image = thumbnailImage;
                cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2 ;
                cell.thumbnailImageView.clipsToBounds = true;
                
            });
            
        }];
    }
    
    */
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
  //  cell.textLabel.text = [object objectForKey:@"text"];
  //  cell.textLabel.text = @"test 1234";
     cell.textLabel.text = [object objectForKey:@"cate_name"];
    PFFile *featureImageFile = [object objectForKey:@"cate_file"];
    if (featureImageFile != nil) {
        [featureImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = thumbnailImage;
                cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2 ;
                cell.imageView.clipsToBounds = true;
                
            });
            
        }];
    }

    
    
    return cell;
}


@end
