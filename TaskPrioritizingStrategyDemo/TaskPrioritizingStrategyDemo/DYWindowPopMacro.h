//
//  DYWindowPopMacro.h
//  huhuAudio
//
//  Created by Kevin Chen on 2021/10/25.
//  Copyright © 2021 XYWL. All rights reserved.
//


#ifndef DYWindowPopMacro_h
#define DYWindowPopMacro_h

#import "DYWindowPopHelperConfig.h"

typedef NS_ENUM(NSInteger, DYWindowPopCoverPriority) {
    
    DYWindowPopCoverPriorityChooseGender = 1501,
    DYWindowPopCoverPriorityBindPhone = 1500,
    DYWindowPopCoverPriorityDYCPTelephoneViewInProcess = 1499,

    DYWindowPopCoverPriorityDYCPPopView = 1498,
    
    DYWindowPopCoverPriorityHigh = 1000,
    DYWindowPopCoverPriorityDYCPTelephoneViewCompleted = DYWindowPopCoverPriorityHigh - 1,

    DYWindowPopCoverPrioritySemiHigh = 750,
    DYWindowPopCoverPriorityNormal = DYWindowPopHelperConfigDefaultCoverPriority,
};

typedef NS_ENUM(NSInteger, DYWindowPopAntiCoverPriority) {
    
    DYWindowPopAntiCoverPriorityChooseGender = 1501,
    DYWindowPopAntiCoverPriorityBindPhone = 1500,
    DYWindowPopAntiCoverPriorityDYCPTelephoneViewInProcess = 1499,

    DYWindowPopAntiCoverPriorityDYCPPopView = 1498,
    
    DYWindowPopAntiCoverPriorityHigh = 1000,
    DYWindowPopAntiCoverPriorityDYCPTelephoneViewCompleted = DYWindowPopAntiCoverPriorityHigh - 1,

    DYWindowPopAntiCoverPrioritySemiHigh = 750,
    DYWindowPopAntiCoverPriorityNormal = DYWindowPopHelperConfigDefaultAntiCoverPriority,
};

typedef NS_ENUM(NSInteger, DYWindowPopOccupyPriority) {
    
    DYWindowPopOccupyPriorityChooseGender = 1501,
    DYWindowPopOccupyPriorityBindPhone = 1500,
    DYWindowPopOccupyPriorityDYCPTelephoneViewInProcess = 1499,

    DYWindowPopOccupyPriorityDYCPPopView = 1498,
    
    DYWindowPopOccupyPriorityHigh = 1000,
    DYWindowPopOccupyPriorityDYCPTelephoneViewCompleted = DYWindowPopOccupyPriorityHigh - 1,
    
    DYWindowPopOccupyPrioritySemiHigh = 750,
    DYWindowPopOccupyPriorityNormal = DYWindowPopHelperConfigDefaultOccupyPriority,

};

typedef NS_ENUM(NSInteger, DYWindowPopAntiOccupyPriority) {
    
    DYWindowPopAntiOccupyPriorityChooseGender = 1501,
    DYWindowPopAntiOccupyPriorityBindPhone = 1500,
    DYWindowPopAntiOccupyPriorityDYCPTelephoneView = 1499,

    DYWindowPopAntiOccupyPriorityDYCPPopView = 1498,
    
    DYWindowPopAntiOccupyPriorityHigh = 1000,
    DYWindowPopAntiOccupyPrioritySemiHigh = 750,
    DYWindowPopAntiOccupyPriorityNormal = DYWindowPopHelperConfigDefaultAntiOccupyPriority,
};


#endif /* DYWindowPopMacro_h */
