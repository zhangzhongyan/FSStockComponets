//
//  FSFontMacro.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/26.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#ifndef FSFontMacro_h
#define FSFontMacro_h

#define FONT_SIZE_SCALE       autoSizeScale()
#define FONT(NAME,FONTSIZE) [UIFont fontWithName:(NAME) size:(FONTSIZE) * FONT_SIZE_SCALE]
#define S_FONT(FONTSIZE)    [UIFont systemFontOfSize:(FONTSIZE) * FONT_SIZE_SCALE]
#define S_BOLD_FONT(FONTSIZE)   [UIFont boldSystemFontOfSize:(FONTSIZE) * FONT_SIZE_SCALE]

#endif /* FSFontMacro_h */
