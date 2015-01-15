//
//  ViewController.m
//  GoodnightMoon
//
//  Created by Kyle Magnesen on 1/15/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollisionBehaviorDelegate>

@property NSMutableArray *moonImagesArray;
@property NSMutableArray *sunImagesArray;
@property NSMutableArray *currentImagesArray;

@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;


@property (strong, nonatomic) IBOutlet UIView *shadeView;

@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;

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

    self.sunImagesArray = [NSMutableArray new];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"sun_1"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"sun_2"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"sun_3"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"sun_4"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"sun_5"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"sun_6"]];

    self.currentImagesArray = self.moonImagesArray;


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView] mode:UIPushBehaviorModeContinuous];

    [self.collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                            fromPoint:CGPointMake(0, self.view.frame.size.height)
                                              toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];



    [self.gravityBehavior setGravityDirection:CGVectorMake(0, 0)];  // no gravity when the view loads

    [self.dynamicItemBehavior setElasticity:0.25];   // for bouncing off the boundaries

    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.pushBehavior];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehavior];

    self.collisionBehavior.collisionDelegate = self;
}

- (IBAction) handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:gesture.view];
    gesture.view.center = CGPointMake(gesture.view.center.x, gesture.view.center.y + point.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];

    CGFloat yVelocity = [gesture velocityInView:gesture.view].y;  // get the y velocity

    if (gesture.state == UIGestureRecognizerStateEnded) {

        [self.dynamicAnimator updateItemUsingCurrentState:self.shadeView];

        if (yVelocity < -500.0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        }
        else if (yVelocity >= -500.0 && yVelocity < 0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, -500.0)];
        }
        else if (yVelocity >= 0 && yVelocity < 500.0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, 500.0)];
        } else {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        }
    }
}


#pragma mark UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentImagesArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.imageView.image = [self.currentImagesArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {

    self.currentImagesArray = self.sunImagesArray;
    [self.imageCollectionView reloadData];
}

@end
