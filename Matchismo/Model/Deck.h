//
//  Deck.h
//  Matchismo
//
//  Created by Michael Davidovich on 3/27/13.
//  Copyright (c) 2013 Michael Davidovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
// this method will take 2 arguments, add a card to the deck and bool Yes or No to put it at the top or not.

- (Card *)drawRandomCard;
// this method takes no arguments, but will return an object Card.


@end
