/*   Copyright 2017 Prebid.org, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "PBAnalyticsManager.h"
#import "PBAnalyticsService.h"

@interface PBAnalyticsManager ()

@property (atomic, strong) NSMutableSet *__nullable services;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation PBAnalyticsManager

+ (instancetype)sharedInstance {
    static PBAnalyticsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.services = [[NSMutableSet alloc] init];
        sharedInstance.queue = dispatch_queue_create("PBAnalyticsManagerQueue", DISPATCH_QUEUE_SERIAL);
        sharedInstance.enabled = YES;
    });
    return sharedInstance;
}

- (void)initializeWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    [self doServiceWithExecutionHandler:^(id<PBAnalyticsService> service) {
        [service initializeWithApplication:application launchOptions:launchOptions];
    }];
}

- (void)trackEvent:(PBAnalyticsEvent *)event {
    if (!_enabled) {
        return;
    }
        
    [self doServiceWithExecutionHandler:^(id<PBAnalyticsService> service) {
        [service trackEvent:event];
    }];
}

- (void)trackEventType:(PBAnalyticsEventType)type
                  info:(NSDictionary*)info {
    PBAnalyticsEvent *event = [[PBAnalyticsEvent alloc] initWithEventType:type];
    event.info = info;
    [self trackEvent:event];
}

- (void)doServiceWithExecutionHandler:(void (^)(id<PBAnalyticsService>))handler {
    dispatch_sync(self.queue, ^{
        [self.services enumerateObjectsUsingBlock:^(id<PBAnalyticsService> service, BOOL *stop) {
            handler(service);
        }];
    });
}

- (void)addService:(id<PBAnalyticsService>)service {
    dispatch_async(self.queue, ^{
        [self.services addObject:service];
    });
}

- (void)removeService:(id<PBAnalyticsService>)service {
    dispatch_async(self.queue, ^{
        [self.services removeObject:service];
    });
}

- (void)removeAllServices {
    dispatch_async(self.queue, ^{
        [self.services removeAllObjects];
    });
}

@end
