//
//  ViewController.m
//  Note
//
//  Created by syj on 16/4/17.
//  Copyright © 2016年 syj. All rights reserved.
//

#import "ViewController.h"

#define needCopyFile YES

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *TextView;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) NSMutableArray *fileArray;
@property (strong, nonatomic) UIAlertAction *secureTextAlertAction;

- (IBAction)nextBtnDone:(id)sender;
- (IBAction)finishBtnDown:(id)sender;
- (IBAction)allFile:(id)sender;
- (IBAction)addAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *textPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/study"];

    NSLog(@"pngPath:%@",textPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName;
    self.fileArray = [NSMutableArray array];
    for (fileName in [fileManager enumeratorAtPath:textPath]) {
        NSLog(@"fileName:%@",fileName);
        [self.fileArray addObject:fileName];
    }
    
    [self showText:[self.fileArray lastObject]];
    
    if(needCopyFile)
    {
        
    }
}

-(void)showText:(NSString *)title
{
    self.titleText.text = title;
    NSString *textPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/study/"],title];
    NSData *data = [NSData dataWithContentsOfFile:textPath];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *temp = [[NSString alloc]initWithData:data encoding:encoding];
    self.TextView.text = temp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextBtnDone:(id)sender {
    [self nextFile];
}

- (IBAction)finishBtnDown:(id)sender {
    [self nextFile];
}

- (IBAction)allFile:(id)sender {
    
}

- (IBAction)addAction:(id)sender {
    NSString *title = @"Add";
    NSString *message = @"Input name";
    NSString *cancelButtonTitle = @"Cancel";
    NSString *otherButtonTitle = @"OK";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *name = alertController.textFields.firstObject.text;
        
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        NSString *textPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/study"];
        NSString *path = [NSString stringWithFormat:@"%@/%@",textPath,name];
        if([fileManager fileExistsAtPath:path])
        {
            [self addAction:nil];
        }
        else
        {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
    }];
    
    self.secureTextAlertAction = otherAction;
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)nextFile
{
    if(self.fileArray.count > 0)
    {
        [self.fileArray removeLastObject];
        [self showText:[self.fileArray lastObject]];
    }
    else
    {
        self.TextView.text = @"最后一篇";
    }
}
@end
