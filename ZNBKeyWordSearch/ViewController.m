//
//  ViewController.m
//  ZNBKeyWordSearch
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

#import "ViewController.h"
#import "ZNBAttributedString.h"
@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textF;


@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *totalStr = @"CoderZNB 春水初生，春林初盛，春风十里，不如你。秋池渐涨,秋叶渐黄,秋思一半,赋予卿 真你比";
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:totalStr];
    self.label.attributedText = attr;
    self.label.numberOfLines = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFDidChange:(NSNotification *)notice {

    NSLog(@"%@",self.textF.text);

    self.label.attributedText = [ZNBAttributedString setAllText:self.label.attributedText.string andKeyWords:self.textF.text withKeyWordsColor:[UIColor redColor] KeyWordsFont:[UIFont fontWithName:@"Arial-BoldMT" size:22]];
}

@end
