//
//  ViewController.m
//  Note
//
//  Created by syj on 16/4/17.
//  Copyright © 2016年 syj. All rights reserved.
//

#import "ViewController.h"
#import "AllFileViewController.h"

#define needCopyFile YES

@interface ViewController ()
{
    int currentIndex;
}
@property (weak, nonatomic) IBOutlet RichTextEditor *textView;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (strong, nonatomic) NSMutableArray *fileArray;
@property (strong, nonatomic) UIAlertAction *secureTextAlertAction;

- (IBAction)nextBtnDone:(id)sender;
- (IBAction)finishBtnDown:(id)sender;
- (IBAction)allFile:(id)sender;
- (IBAction)addAction:(id)sender;
- (IBAction)resign:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *textPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/study"];

    NSLog(@"pngPath:%@",textPath);
    
    
    currentIndex = 0;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *lastFile = [userdefault objectForKey:@"file"];
    
    if(lastFile)
    {
    
    }
    else
    {
        currentIndex = 0;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName;
    self.fileArray = [NSMutableArray array];
    for (fileName in [fileManager enumeratorAtPath:textPath]) {
        NSLog(@"fileName:%@",fileName);
        [self.fileArray addObject:fileName];
    }
    [self.fileArray removeObject:@".DS_Store"];
    
    //todo
    for (int i = 0; i < self.fileArray.count; i++) {
        NSString *file = [self.fileArray objectAtIndex:i];
        if([file isEqualToString:lastFile])
        {
            currentIndex = i;
        }
    }
    
    if(![fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/textData"]])
    {
        [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/textData"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self showText:[self.fileArray objectAtIndex:currentIndex]];
    
    if(needCopyFile)
    {
        
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)showText:(NSString *)title
{
    self.titleText.text = title;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/textData"],[[title componentsSeparatedByString:@"."]firstObject]]])
    {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/textData"],[[title componentsSeparatedByString:@"."]firstObject]];
        NSData *attrStrData = [NSData dataWithContentsOfFile:path];
        NSAttributedString *myAttrString = [NSKeyedUnarchiver unarchiveObjectWithData: attrStrData];
        self.textView.attributedText = myAttrString;
    }
    else
    {
        NSString *textPath = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/study/"],title];
        NSData *data = [NSData dataWithContentsOfFile:textPath];
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *temp = [[NSString alloc]initWithData:data encoding:encoding];
        self.textView.text = temp;
    }
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
    AllFileViewController *view = [[AllFileViewController alloc]init];
    view.dataSource = self.fileArray;
    view.select = ^(int index){
         currentIndex = index;
         [self showText:[self.fileArray objectAtIndex:index]];
    };
    [self.navigationController pushViewController:view animated:YES];
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

- (IBAction)resign:(id)sender {
    [self.textView resignFirstResponder];
}

-(void)nextFile
{
    currentIndex += 1;
    if(self.fileArray.count > 0)
    {
        [self showText:[self.fileArray objectAtIndex:currentIndex]];
    }
    else
    {
        self.textView.text = @"最后一篇";
    }
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setObject:[self.fileArray objectAtIndex:currentIndex] forKey:@"file"];
    [userdefault synchronize];
}


- (RichTextEditorFeature)featuresEnabledForRichTextEditor:(RichTextEditor *)richTextEditor
{
    return RichTextEditorFeatureFontSize | RichTextEditorFeatureFont | RichTextEditorFeatureAll;
}

- (IBAction)touchBtn:(id)sender {
    NSLog(@"text:%@",self.textView.attributedText);
    //  NSData *attrStrData = [self.textView.attributedText dataFromRange:NSMakeRange(0, self.textView.attributedText.length) documentAttributes:NULL error:nil];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [NSString stringWithFormat:@"%@/textData/%@",pngPath,[[self.titleText.text componentsSeparatedByString:@"."]firstObject]];
    
    NSMutableData *data = [NSKeyedArchiver archivedDataWithRootObject:self.textView.attributedText];
    [data writeToFile:path atomically:YES];
    
}

@end
