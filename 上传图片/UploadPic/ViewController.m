//
//  ViewController.m
//  UploadPic
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 LoveSpending. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImage+AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"icon_head"];
    
    //发送图片请求
    NSData *data = UIImagePNGRepresentation(image);
    
    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    NSDictionary *iconDic = @{
                              @"avatar":@"",
                              };
    AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];//初始化请求对象
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    //上传图片/文字，只能同POST
    [manager2 POST:@"http://..." parameters:iconDic constructingBodyWithBlock:^(id  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"avatar" fileName:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"resultData:%@",resultData);
        
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numFormatter stringFromNumber:[resultData objectForKey:@"code"]];
        
        if ([code isEqualToString:@"200"]){
            
            NSLog(@"上传成功");
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
