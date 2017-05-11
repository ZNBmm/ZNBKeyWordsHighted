//
//  ZNBAttributedString.h
//  ZNBKeyWordSearch
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNBAttributedString : NSMutableAttributedString
/**
 *  设置在一个文本中所有特殊字符的特殊颜色
 *  @pragma  allStr      所有字符串
 *  @pragma  specifiStr  特殊字符
 *  @pragma  color       默认特殊字符颜色    红色
 *  @pragma  font        默认字体           systemFont 17.号字
 **/
+ (NSMutableAttributedString *)setAllText:(NSString *)allStr andKeyWords:(NSString *)keyWords withKeyWordsColor:(UIColor *)color KeyWordsFont:(UIFont *)font;
@end
