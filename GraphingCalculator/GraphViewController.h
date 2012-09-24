//
//  GraphViewController.h
//  GraphingCalculator
//
//  Created by Arman Shan on 8/17/12.
//  Copyright (c) 2012 Arman Shan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic) id program;
@property (nonatomic, weak) IBOutlet UILabel *programLabel;
@property (weak, nonatomic) IBOutlet UISwitch *percisionSwitch;

@end
