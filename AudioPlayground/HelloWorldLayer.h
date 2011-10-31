//
//  HelloWorldLayer.h
//  dodgeball
//
//  Created by Kevin Loken on 11-09-22.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CDAudioManager.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	CDAudioManager	*audioManager_;
    
	double			filterSmooth_;
	double			*filteredPeak_;
	double			*filteredAverage_;    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
