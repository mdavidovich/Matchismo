//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Michael Davidovich on 3/27/13.
//  Copyright (c) 2013 Michael Davidovich. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"


@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;

// this property holds an a collection of buttons on the screen
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

// this property points to our model
@property (strong, nonatomic) CardMatchingGame *game;

@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;

@property (weak, nonatomic) IBOutlet UIButton *dealButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSelector;

@end

@implementation CardGameViewController


-(CardMatchingGame *) game
{
    if (!_game) {
        
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                                  usingDeck:[[PlayingCardDeck alloc] init]];
        [self selectGameStyle:self.gameTypeSelector];
    }
    return _game;
}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}



-(void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.lastFlipResultLabel.text = [NSString stringWithFormat:@"%@",self.game.lastFlipResult];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.gameTypeSelector.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    
}

- (IBAction)dealNewGame:(UIButton *)sender

{
    self.game = nil;
    self.flipCount = 0;
    self.gameTypeSelector.enabled = YES;
    [self updateUI];
    
}

- (IBAction)selectGameStyle:(UISegmentedControl*)sender
{
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.game.numberOfMatchingCards = 2;
            break;
        case 1:
            self.game.numberOfMatchingCards = 3;
            break;
        default:
            self.game.numberOfMatchingCards = 2;
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

@end
