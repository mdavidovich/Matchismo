//
//  PlayingCard.m
//  Matchismo
//
//  Created by Michael Davidovich on 3/27/13.
//  Copyright (c) 2013 Michael Davidovich. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count]) {
        for (PlayingCard *otherCard in otherCards) {
                
            // PlayingCard *otherCard = [otherCards lastObject];
            if ([otherCard.suit isEqualToString:self.suit]) {
                score += 1;
            } else if (otherCard.rank == self.rank) {
                score += 4;
            } else {
                score = 0;
                break;
            }
        }
    }
    return score;
}

-(NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankString];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; //because we provide setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [self rankString].count-1; }

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}
@end
