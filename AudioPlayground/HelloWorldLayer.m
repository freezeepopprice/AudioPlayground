//
//  HelloWorldLayer.m
//  dodgeball
//
//  Created by Kevin Loken on 11-09-22.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

enum {
	kTagHead1,
	kTagHead2,
};


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *sprite = [CCSprite spriteWithFile:@"head.png"];
		// position the label on the center of the screen
		sprite.position =  ccp( size.width /2 - 100, size.height/2 - 60 );
		sprite.anchorPoint = ccp(.5f,0.f);
        sprite.tag = kTagHead1;
		[self addChild: sprite];

        CCSprite *sprite2 = [CCSprite spriteWithFile:@"head.png"];
		// position the label on the center of the screen
		sprite2.position =  ccp( size.width /2 + 100, size.height/2 - 60 );
		sprite2.anchorPoint = ccp(.5f,0.f);
        sprite2.tag = kTagHead2;
		[self addChild: sprite2];        
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"thump.mp3" loop:YES];
        
        audioManager_ = [CDAudioManager sharedManager];
        AVAudioPlayer *asp = audioManager_.backgroundMusic.audioSourcePlayer;
        asp.meteringEnabled = YES;
        
        filteredPeak_ = malloc(asp.numberOfChannels * sizeof(double));
        filteredAverage_ = malloc(asp.numberOfChannels * sizeof(double));
        bzero(filteredPeak_, asp.numberOfChannels * sizeof(double));
        bzero(filteredPeak_, asp.numberOfChannels * sizeof(double));        
        
        filterSmooth_ = .2f;

        [self schedule: @selector(tick:) interval:0.04f];
                
	}
	return self;
}

-(void)tick:(ccTime) dt
{
	if (!audioManager_) return;
		
    AVAudioPlayer *asp = audioManager_.backgroundMusic.audioSourcePlayer;
    
    [asp updateMeters];
    double peakPowerForChannel = 0.f,avgPowerForChannel = 0.f;
    for(ushort i = 0; i < asp.numberOfChannels; ++i){
        //	convert the -160 to 0 dB to [0..1] range
        peakPowerForChannel = pow(10, (0.05 * [asp peakPowerForChannel:i]));
        avgPowerForChannel = pow(10, (0.05 * [asp averagePowerForChannel:i]));
			
        filteredPeak_[i] = filterSmooth_ * peakPowerForChannel + (1.0 - filterSmooth_) * filteredPeak_[i];
        filteredAverage_[i] = filterSmooth_ * avgPowerForChannel + (1.0 - filterSmooth_) * filteredAverage_[i];
    }
    [self getChildByTag:kTagHead1].scale = 0.7f + (1.0f * filteredAverage_[0]);    
    [self getChildByTag:kTagHead2].scale = 0.7f + (1.0f * filteredAverage_[1]);    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	if(filteredPeak_)
		free(filteredPeak_);
	if(filteredAverage_)
		free(filteredAverage_);
    
    [self unschedule: @selector(tick:)];	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
