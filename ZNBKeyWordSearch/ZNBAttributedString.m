//
//  ZNBAttributedString.m
//  ZNBKeyWordSearch
//
//  Created by mac on 2017/5/11.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

#import "ZNBAttributedString.h"
#import "PinYin4Objc.h"

@interface ZNBAttributedString ()

@end
@implementation ZNBAttributedString

BOOL isJump = NO;


+ (NSMutableAttributedString *)setAllText:(NSString *)allStr andKeyWords:(NSString *)keyWords withKeyWordsColor:(UIColor *)color KeyWordsFont:(UIFont *)font {
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    if (color == nil) {
        color = [UIColor redColor];
    }
    if (font == nil) {
        font = [UIFont systemFontOfSize:17];
    }
    __block NSUInteger znb_index = 0;
    
    __block NSMutableString *mutableStr = [NSMutableString stringWithString:keyWords];
    __block NSMutableArray *mutableArr = [NSMutableArray array];
    if ([PinyinHelper isIncludeChineseInString:keyWords]) { // 中文
        for (NSInteger j=0; j<=keyWords.length-1; j++) {
            
            NSRange searchRange = NSMakeRange(0, [allStr length]);
            NSRange range;
            NSString *singleStr = [keyWords substringWithRange:NSMakeRange(j, 1)];
            while
                ((range = [allStr rangeOfString:singleStr options:0 range:searchRange]).location != NSNotFound) {
                    //改变多次搜索时searchRange的位置
                    searchRange = NSMakeRange(NSMaxRange(range), [allStr length] - NSMaxRange(range));
                    //设置富文本
                    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
                    [mutableAttributedStr addAttribute:NSFontAttributeName value:font range:range];
                }
        }

    }else { // 拼音
        
        
        [allStr enumerateSubstringsInRange:NSMakeRange(0, allStr.length) options:NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            NSLog(@"substring--%@--mutableStr--%@",substring,mutableStr);
            isJump = NO;
            
            HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
            formatter.caseType = CaseTypeUppercase;
            formatter.vCharType = VCharTypeWithV;
            formatter.toneType = ToneTypeWithoutTone;
            // 讲汉语转成拼音
            NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:substring withHanyuPinyinOutputFormat:formatter withNSString:@""] lowercaseString];
            
            NSLog(@"outputPinyin--%@",outputPinyin);
            
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",outputPinyin];
            
            BOOL isBeginWithSubKey =  [predicate1 evaluateWithObject:keyWords];
            if ( isBeginWithSubKey) {
                
                if (outputPinyin.length > 1) {
                    
                    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:color range:substringRange];
                    [mutableAttributedStr addAttribute:NSFontAttributeName value:font range:substringRange];
                }
                isJump = YES;
                
                [mutableArr addObject:substring];
                NSLog(@"mutableArr--%@",mutableArr);
                
                
            }
        }];
        
        
        
        
        NSMutableString *tempStr = [NSMutableString string];
        NSUInteger maxLength = 0;
        
        for (NSString *string in mutableArr) {
            
            [tempStr appendString:string];
            HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
            formatter.caseType = CaseTypeUppercase;
            formatter.vCharType = VCharTypeWithV;
            formatter.toneType = ToneTypeWithoutTone;
            
            NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:string withHanyuPinyinOutputFormat:formatter withNSString:@""] lowercaseString];
            maxLength = outputPinyin.length > maxLength ? outputPinyin.length : maxLength;
            
        }
        
        [tempStr enumerateSubstringsInRange:NSMakeRange(0, tempStr.length) options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            NSLog(@"tempStr- substring %@",substring);
            HanyuPinyinOutputFormat *formatter =  [[HanyuPinyinOutputFormat alloc] init];
            formatter.caseType = CaseTypeUppercase;
            formatter.vCharType = VCharTypeWithV;
            formatter.toneType = ToneTypeWithoutTone;
            
            NSString *outputPinyin=[[PinyinHelper toHanyuPinyinStringWithNSString:substring withHanyuPinyinOutputFormat:formatter withNSString:@""] lowercaseString];
            if ([outputPinyin isEqualToString:keyWords]) {
                *stop = YES;
                [mutableAttributedStr removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, allStr.length)];
                [mutableAttributedStr removeAttribute:NSFontAttributeName range:NSMakeRange(0, allStr.length)];
                NSRange range = [allStr rangeOfString:substring];
                NSLog(@"%@",NSStringFromRange(range));
                [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
                [mutableAttributedStr addAttribute:NSFontAttributeName value:font range:range];
            }
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",outputPinyin];
            
            BOOL isBeginWithSubKey =  [predicate1 evaluateWithObject:keyWords];
            if ( isBeginWithSubKey) {
                NSRange range = [allStr rangeOfString:substring];
                NSLog(@"%@",NSStringFromRange(range));
                [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
                [mutableAttributedStr addAttribute:NSFontAttributeName value:font range:range];
            }
            
          
            
            else {
                NSRange range = [allStr rangeOfString:substring];
                [mutableAttributedStr removeAttribute:NSForegroundColorAttributeName range:range];
                [mutableAttributedStr removeAttribute:NSFontAttributeName range:range];
            }
        }];
        
    }
    
    
    return mutableAttributedStr;
}
@end
