//
//  cccc.m
//  ccc
//
//  Created by 徐汉卿 on 16/6/7.
//  Copyright © 2016年 jxk. All rights reserved.
//

#import "cccc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

@implementation cccc

+(NSString *)XorDencodeWithKey:(NSString *)keyOC str:(NSString *)strOC
{
    char *szKey = keyOC.UTF8String;
    char *szRes = strOC.UTF8String;
    
    
    char * xxxReturn =XorDencode(szKey, szRes);
    return [NSString stringWithUTF8String:xxxReturn];
    
//    int nKeyLenth = strlen(key);
//    int nStrLenth = nstr;
//    //string strDecode(nStrLenth, 0);
//    char *strDecode = malloc(nStrLenth+1);
//    memset(strDecode, 0, nStrLenth + 1);
//    
//    char szDate;
//    for (int n = 0; n < nStrLenth; n++)
//    {
//        szDate = str[n];
//        for (int j = 0; j < nKeyLenth; j++)
//        {
//            szDate ^= key[j];
//        }
//        
//        strDecode[n] = (szDate);
//    }
////    free(str);
////    return strDecode;
//    return [NSString stringWithUTF8String:strDecode];
}


char * XorEncode2(char* key, char* str, int nstr)
{
    int nKeyLenth = strlen(key);
    int nStrLenth = nstr;
    //string strDecode(nStrLenth, 0);
    char *strDecode = malloc(nStrLenth+1);
    memset(strDecode, 0, nStrLenth + 1);
    
    char szDate;
    for (int n = 0; n < nStrLenth; n++)
    {
        szDate = str[n];
        for (int j = 0; j < nKeyLenth; j++)
        {
            szDate ^= key[j];
        }
        
        strDecode[n] = (szDate);
    }
    free(str);
    return strDecode;
}

char *XorDencode(char* key, char* str)
{
    
    int len = strlen(str);
    //string strDecode(len / 2, 0);
    char *strDecode = malloc(len / 2);
    char high, low;
    int idx = 0;
    int ii = 0;
    for (idx = 0; idx < len; idx += 2)
    {
        high = str[idx];
        low = str[idx + 1];
        
        if (high >= '0' && high <= '9')
            high = high - '0';
        else if (high >= 'A' && high <= 'F')
            high = high - 'A' + 10;
        else if (high >= 'a' && high <= 'f')
            high = high - 'a' + 10;
        else
            return "";
        
        if (low >= '0' && low <= '9')
            low = low - '0';
        else if (low >= 'A' && low <= 'F')
            low = low - 'A' + 10;
        else if (low >= 'a' && low <= 'f')
            low = low - 'a' + 10;
        else
            return "";
        
        strDecode[ii++] = high << 4 | low;
    }
    
    return XorEncode2(key,  strDecode, len / 2);
}

//




//void main()
//{
//    char *szRes = "363530293729372936";
//    
//    
//    
//    
//    //int nstr = strlen(szRes);
//    char *szKey = "123456";
//    //int nkey = strlen(szKey);
//    
//    char *szbuffer = XorDencode(szKey, szRes);
//    printf(szbuffer);
//    free(szbuffer);
//    getchar();
//}

@end
