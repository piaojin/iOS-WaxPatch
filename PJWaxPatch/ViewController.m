//
//  ViewController.m
//  PJWaxPatch
//
//  Created by administrator on 16/6/16.
//  Copyright © 2016年 piaojin. All rights reserved.
//

#import "ViewController.h"
#import "PJView.h"
#import "PJModel.h"
//引入lua相关头文件
#import "wax/lib/lua/lauxlib.h"
#import "wax/lib/wax.h"
//解压缩头文件
#import "ZipArchive.h"

//这边为patch.zip所在的服务器地址
#define WAX_PATCH_URL @"https://github.com/piaojin/iOS-WaxPatch/blob/master/PJWaxPatch/patch/patch.zip?raw=true"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong)PJView *pjView;
@property(nonatomic,strong)PJModel *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    [self initCustomeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initView{
    self.textView.backgroundColor = [UIColor redColor];
    self.textView.text = @"未通过waxpatch修改前";
}

-(void)initCustomeView{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.pjView = [[PJView alloc] initWithFrame:CGRectMake(0, size.height - 200.0, size.width, 200.0)];
    self.pjView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.pjView];
    self.model = [[PJModel alloc] init];
    [self.pjView showPrompt:self.model];
}

/**
 * 个人认为一般是在程序加载运行的时候就去判断服务器时候有可用的patch.zip更新，所以应该在 AppDelegate.h中就应该去做这些逻辑，并且如果有更新则需要执行更新（即修复bug），执行完才去加载其他页面，因为这时候其他页面的bug应该已经修复，执行完patch后去下载其他页面才是正确的（修复完bug）页面.这边是示例故执行加载patch都在ViewController里面
 *
 *
 */
- (IBAction)updateViewControllerClick:(id)sender {
    [self updateLocalWaxPatch];
//    [self updateServerWaxPatch];
    [self initView];
}

//修改任意类（这边修改一个UIView类和NSObject类）
- (IBAction)updateClasses:(id)sender {
    [self updateLocalWaxPatch];
//    [self updateServerWaxPatch];
    [self updateCustomeView];
}

//这边原本是没有任何内容的，通过waxpatch为其修改方法实现
-(void)updateCustomeView{
    
}

//查看某个路径下的文件（可以用来查看解压的patch.zip路径等等是否正确）
-(void)lsFile:(NSString *)path{
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator;
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    if(![myDirectoryEnumerator nextObject]){
        NSLog(@"path中没有其他目录或文件！");
        return;
    }
    //列举目录内容
    while((path=[myDirectoryEnumerator nextObject])!=nil)
    {
        NSLog(@"path:%@",path);
    }
}

/**
 *  本地模拟测试，即跳过去服务器下载patch.zip的步骤，假设已经下载好patch.zip文件，并且我这边是把patch.zip放入了项目的patch/目录下（方便代码查找）
 */
-(void)updateLocalWaxPatch{
    //获取到本地的patch.zip的路径
    NSString *patchZip=[[NSBundle mainBundle] pathForResource:@"patch" ofType:@"zip"];
    [self wax_Patch:patchZip];
}

-(void)updateServerWaxPatch{
    //patch.zip在服务器的地址（这边是在我的github上）
    NSURL *patchUrl = [NSURL URLWithString:WAX_PATCH_URL];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:patchUrl] returningResponse:NULL error:NULL];
    if(data) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *patchZip = [doc stringByAppendingPathComponent:@"patch.zip"];
        
        [[NSFileManager defaultManager] removeItemAtPath:patchZip error:NULL];
        
        [data writeToFile:patchZip atomically:YES];
        
        [self wax_Patch:patchZip];
    }
}

//加载编译运行lua文件
-(void)wax_Patch:(NSString *)patchZipPath{
    if(patchZipPath){
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dir = [doc stringByAppendingPathComponent:@"lua"];
        [[NSFileManager defaultManager] removeItemAtPath:dir error:NULL];
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
        
        ZipArchive *zip = [[ZipArchive alloc] init];
        [zip UnzipOpenFile:patchZipPath];
        [zip UnzipFileTo:dir overWrite:YES];
        
        [self lsFile:dir];
        
        NSString *pp = [[NSString alloc ] initWithFormat:@"%@/patch/?.lua;%@/?/init.lua;", dir, dir];
        setenv(LUA_PATH, [pp UTF8String], 1);
        wax_start("patch", nil);
    }else{
        NSLog(@"patchZipPath路径为空！");
    }
}

//由于waxpatch不支持点语法，故这边余姚给出textView熟悉的getter方法
-(UITextView *)textView{
    return _textView;
}

-(PJView *)pjView{
    return _pjView;
}

-(PJModel *)model{
    return _model;
}

@end
