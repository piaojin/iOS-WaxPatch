//
//  PJView.m
//  PJWaxPatch
//
//  Created by administrator on 16/6/16.
//  Copyright © 2016年 piaojin. All rights reserved.
//

#import "PJView.h"
#import "PJModel.h"

@interface PJView()

@property(nonatomic,strong)UILabel *label;

@end

@implementation PJView

-(void)showPrompt:(PJModel *)model{
    self.label.text = model.prompt;
    [self addSubview:_label];
}

//这边原本是没有任何内容的，通过waxpatch为其修改方法实现
-(void)updateView{
    
}

-(UILabel *)label{
    if(!_label){
        _label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    }
    return _label;
}

@end
