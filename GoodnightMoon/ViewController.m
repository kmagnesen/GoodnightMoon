//
//  ViewController.m
//  GoodnightMoon
//
//  Created by Kyle Magnesen on 1/15/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSMutableArray *moonImagesArray;
@property (strong, nonatomic) IBOutlet UIView *shadeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moonImagesArray = [NSMutableArray new];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_1"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_2"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_3"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_4"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_5"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_6"]];
}

- (IBAction) handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:gesture.view];
    gesture.view.center = CGPointMake(gesture.view.center.x, gesture.view.center.y + point.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];

}


#pragma mark UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.moonImagesArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.imageView.image = [self.moonImagesArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
