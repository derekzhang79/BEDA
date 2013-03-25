//
//  DataManager.h
//  BEDA
//
//  Created by Jennifer Kim on 2/17/13.
//  Copyright (c) 2013 Jennifer Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>

@interface DataManager : NSObject {
    QTMovie* movie1;
    QTMovie* movie2;
}

@property (retain) QTMovie* movie1;
@property (retain) QTMovie* movie2;
@property (retain) NSMutableArray* sensor1;
@property (retain) NSDate* basedate;

-(double) getMaximumTime;

@end
