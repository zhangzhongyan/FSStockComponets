//
//  FSColorMacro.h
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/22.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#ifndef FSColorMacro_h
#define FSColorMacro_h

/** 颜色(0xFFFFFF) */
#define HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEX_RGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


#endif /* FSColorMacro_h */
