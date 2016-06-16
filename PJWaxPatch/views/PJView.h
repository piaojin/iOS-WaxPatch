//
//  PJView.h
//  PJWaxPatch
//
//  Created by administrator on 16/6/16.
//  Copyright © 2016年 piaojin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PJModel;

@interface PJView : UIView

-(void)showPrompt:(PJModel *)model;
-(void)updateView;

@end
