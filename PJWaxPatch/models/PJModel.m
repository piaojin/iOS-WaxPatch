//
//  PJModel.m
//  PJWaxPatch
//
//  Created by administrator on 16/6/16.
//  Copyright © 2016年 piaojin. All rights reserved.
//

#import "PJModel.h"

@implementation PJModel

//这边会通过waxpatch修改方法实现
-(NSString *)prompt{
    _prompt = @"普通类修改前";
    return _prompt;
}

@end
