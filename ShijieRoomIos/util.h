//
//  util.h
//  ShijeRoomIos
//
//  Copyright (c) 2015 Shisu.Inc. All rights reserved.
//

#ifndef ShijeRoomIos_util_h
#define ShijeRoomIos_util_h

inline NSString* generateUserId()
{
    NSString *userId = [NSString stringWithFormat: @"%lu", [[UIDevice currentDevice] identifierForVendor].hash % 1000];
    return userId;
}
#endif
