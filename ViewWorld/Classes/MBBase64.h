//
//  MBBase64.h
//  NordjyskeiPad
//
//  Created by Uffe Overgaard Koch on 29/11/10.
//  Copyright 2010 HUGE LAWN SOFTWARE ApS All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end
