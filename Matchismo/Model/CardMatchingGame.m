//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Michael Davidovich on 3/31/13.
//  Copyright (c) 2013 Michael Davidovich. All rights reserved.
//  Project has been commited to git


#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *lastFlipResult;
@property (strong, nonatomic) NSMutableArray *cards; // of Card

@end

@implementation CardMatchingGame

@synthesize numberOfMatchingCards = _numberOfMatchingCards;

// lazy instantiation
-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}


//getter is used to “lazy instantiate” and to set a default value of 2
- (int)numberOfMatchingCards
{
    if (!_numberOfMatchingCards) {
        _numberOfMatchingCards = 2;
    }
    return _numberOfMatchingCards;
}

// setter checks the validity of the numberOfMatchingCards and sets it to 3 if invalid
- (void)setNumberOfMatchingCards:(int)numberOfMatchingCards
{
    if (numberOfMatchingCards < 2) _numberOfMatchingCards = 2;
    else if (numberOfMatchingCards > 3) _numberOfMatchingCards = 3;
    else _numberOfMatchingCards = numberOfMatchingCards;
}


#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1


-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    //if current card is good and is playable, let's get to matching
    if (card && !card.isUnplayable) {
        
        //if card to compare is not face up, loop through other cards to find one that is face up and playable.
        if (!card.isFaceUp) {
            
            //Will create two arrays by looping over all cards to see witch one is face up.
            //At the end one array will hold those cards,
            //the other one will contain their contents which is used to generate the text messages.
            
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            NSMutableArray *otherContents = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                
                //if you find a card that is face up and is playable, match to current card
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    
                    //add the card to the array that is holding fliped cards
                    [otherCards addObject:otherCard];
                    
                    //add the contents of the card to the array that is holding fliped cards
                    [otherContents addObject:otherCard.contents];
                }
            }
            if ([otherCards count] < self.numberOfMatchingCards -1) {
                self.lastFlipResult = [NSString stringWithFormat:@"Flipped up %@",card.contents];
            } else {
            
                    //matchscore int will equal to return of the card method match
                    int matchScore = [card match:otherCards];
                    
                    //if matchscore is good, do some housekeeping
                    if (matchScore) {
                        //set current card to unplayable status
                        card.unplayable = YES;
                        for (Card *otherCard in otherCards) {
                            //set other card to unplayable status
                            otherCard.unplayable = YES;
                        }
                        //increment score with bonus
                        self.score += matchScore * MATCH_BONUS;
                        //report status
                        self.lastFlipResult = [NSString stringWithFormat:@"Matched %@ & %@ for %d!",card.contents,
                                               [otherContents componentsJoinedByString:@" & "],self.score];
                    } else {
                        for (Card *otherCard in otherCards) {
                            otherCard.faceUp = NO;
                        }
                        //if nothing is matched, turn other card over and increment score with penalty
                        self.score -=MISMATCH_PENALTY;
                        self.lastFlipResult = [NSString stringWithFormat:@"%@ & %@ don't match!",card.contents,
                                               [otherContents componentsJoinedByString:@" & "]];
                    }
            
                }
        
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
    
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;
{
    self = [super init];
    
    if (self) {
        //loop through the specified count of cards
        for (int i = 0; i < count; i++) {
            
            //draw random card from specified deck
            Card *card = [deck drawRandomCard];
            
            // if we can not initialize property given the argument passed, it will return nil
            if (card) {
                self.cards[i] = card;
            } else {
                // we will protect our self from bad of insufficient decks and break for loop
                self = nil;
                break;
            }
            
        }
    }
    self.score = 0;
    self.lastFlipResult = [NSString stringWithFormat:@"Let's Play!"];
    return self;
}

@end
