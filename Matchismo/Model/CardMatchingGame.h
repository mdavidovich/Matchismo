//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Michael Davidovich on 3/31/13.
//  Copyright (c) 2013 Michael Davidovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
//initializes a newly allocated game with
// certain deck and certain number of cards in it.
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;


- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

// this property is readonly publicly, but readwrite private property,
// see definition in .m file
@property (readonly, nonatomic) int score;

// to report results of the last flip
@property (readonly, nonatomic) NSString *lastFlipResult;

//To know which mode is set
@property (nonatomic) int numberOfMatchingCards;


@end
