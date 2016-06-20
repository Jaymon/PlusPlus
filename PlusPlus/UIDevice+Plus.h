//  Created by Jay Marcyes on 6/20/16.


@import UIKit;

@interface UIDevice (Plus)

/**
 *  contains the model type of the iDevice (iPhone 4, iPad Mini, etc)
 */
@property (readonly, nonatomic, nonnull) NSString *modelGeneration;

/**
 *  return YES if we are currently in the simulator
 *
 *  @return YES if running in simulator, NO otherwise
 */
+ (bool)isSimulator;

/**
 *  YES if this is an iPad
 *
 *  @return YES if running on iPad, NO otherwise
 */
+ (bool)isPad;

/**
 *  YES if this is an iPhone
 *
 *  @return YES if running on iPhone, NO otherwise
 */
+ (bool)isPhone;

@end
