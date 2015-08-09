//
//  ViewController.m
//  cross
//
//  Created by Calvin Ho on 8/3/15.
//  Copyright (c) 2015 Calvin Ho. All rights reserved.
//

#import "ViewController.h"
#import "Player.h"

const int maxSize = 9;

@implementation ViewController{
    BOOL isPlayer1;
    
    Player* player1;
    Player* player2;
    
    Player* currentPlayer;
}
//==============================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGame];
}
//==============================================================
-(void)initGame{
    [self initPlayer];
    [self initButton];
    isPlayer1 = true;
    currentPlayer = player1;
}
//==============================================================
-(void)initPlayer{
    player1 = [[Player alloc] initWithName:@"P1"];
    player2 = [[Player alloc] initWithName:@"P2"];
}
//==============================================================
-(void)initButton{
    int i;
    for(i = 0; i< maxSize; i++){
        int tag = 110+i;
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:tag];
        [tmpButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
//==============================================================
-(void)clickAction:(UIButton* )sender{
    NSString* index = [NSString stringWithFormat:@"%ld",sender.tag - 110];
    [self updatePlayerMove:currentPlayer andIndex:index andButton:sender];
    sender.enabled = NO;
    NSLog(@"\n");
    NSString* currentSteps = [self getPlayerSteps:currentPlayer];
    [self checkUserSteps:currentSteps];
    
    [self printPlayerResult:player1];
    [self printPlayerResult:player2];
    [self swapPlayer];
}
//==============================================================
-(void)updatePlayerMove: (Player*) player andIndex:(NSString* )index  andButton:(UIButton*) sender{
    [player.Moves addObject:index];
    [sender setTitle:[NSString stringWithFormat:@"%@-%@",index,player.Name] forState:UIControlStateNormal];
}
//==============================================================
-(void)swapPlayer{
    if(isPlayer1){
        currentPlayer = player2;
        isPlayer1 = false;
    }else{
        currentPlayer = player1;
        isPlayer1 = true;
    }
}
//==============================================================
-(NSString*)getPlayerSteps:(Player*) player{
    NSMutableString* playerSteps = [[NSMutableString alloc] init];
    NSArray* sortedArray;
    int i;
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
    sortedArray = [player.Moves sortedArrayUsingDescriptors:[NSArray arrayWithObject: sortOrder]];
    
    if([sortedArray count] > 1){
        for(i =0 ; i< [sortedArray count] ;i++){
            [playerSteps appendString:[NSString stringWithFormat:@"%@", sortedArray[i]]];
        }
    }else if([sortedArray count] == 1){
        [playerSteps appendString:[NSString stringWithFormat:@"%@", sortedArray[0]]];
    }
    return playerSteps;
}
//==============================================================
-(void)printPlayerResult:(Player*) player{
    NSMutableString* playerSteps = [[NSMutableString alloc] init];
    NSArray* sortedArray;
    int i;
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
    sortedArray = [player.Moves sortedArrayUsingDescriptors:[NSArray arrayWithObject: sortOrder]];
    
    if([sortedArray count] > 1){
        for(i =0 ; i< [sortedArray count] ;i++){
            [playerSteps appendString:[NSString stringWithFormat:@"%@ - ", sortedArray[i]]];
        }
    }else if([sortedArray count] == 1){
        [playerSteps appendString:[NSString stringWithFormat:@"%@ - ", sortedArray[0]]];
    }
    NSLog(@"%@: %@", player.Name, playerSteps);
}
//==============================================================
-(void)checkUserSteps:(NSString*) playerSteps{
    if([self incrementByOne:playerSteps]){
        NSLog(@"%@: incrementByOne - WON ", currentPlayer.Name);
        [self showSimpleAlert];
    }else if([self incrementByThree:playerSteps]){
        NSLog(@"%@: incrementByThree - WON", currentPlayer.Name);
        [self showSimpleAlert];
    }else if([self didCrossWin:playerSteps]){
        NSLog(@"%@: didCrossWin - WON", currentPlayer.Name);
        [self showSimpleAlert];
    }else{
        NSLog(@"Nothing");
    }
}
-(BOOL)incrementByOne:(NSString* ) steps{
    //NSLog(@"incrementByThree");
    int i;
    for (i = 0; i< steps.length; i+=3) {
        NSString* step1 = [NSString stringWithFormat:@"%d", i];
        NSString* step2 = [NSString stringWithFormat:@"%d", i+1];
        NSString* step3 = [NSString stringWithFormat:@"%d", i+2];
        if([steps containsString:step1] && [steps containsString:step2] && [steps containsString:step3]){
            [self updateButtonColor:step1 andBtn2:step2 andbtn3:step3];
            return YES;
        }
    }
    return NO;
}
-(BOOL)incrementByThree:(NSString* ) steps{
    //NSLog(@"incrementByThree");
    int i;
    for (i = 0; i< steps.length; i++) {
        if(i+6 <=8){
            NSString* step1 = [NSString stringWithFormat:@"%d", i];
            NSString* step2 = [NSString stringWithFormat:@"%d", i+3];
            NSString* step3 = [NSString stringWithFormat:@"%d", i+6];
            if([steps containsString:step1] && [steps containsString:step2] && [steps containsString:step3]){
                [self updateButtonColor:step1 andBtn2:step2 andbtn3:step3];
                return YES;
            }
        }
    }
    return NO;
}
-(BOOL) didCrossWin:(NSString* ) steps{
    //NSLog(@"didCrossWin");
    BOOL didPlayerWin = NO;
    if([steps containsString:@"4"]){
        if([steps containsString:@"0"] && [steps containsString:@"8"]){
            [self updateButtonColor:@"0" andBtn2:@"4" andbtn3:@"8"];
            didPlayerWin = YES;
        }
        if([steps containsString:@"2"] && [steps containsString:@"6"]){
            [self updateButtonColor:@"2" andBtn2:@"4" andbtn3:@"6"];
            didPlayerWin = YES;
        }
    }
    return didPlayerWin;
}
-(IBAction)reset :(id)sender{
    int i;
    [self initGame];
    for(i = 0; i< maxSize; i++){
        int tag = 110+i;
        UIButton *tmpButton = (UIButton *)[self.view viewWithTag:tag];
        tmpButton.enabled = YES;
        [tmpButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
    }
}
-(void)showSimpleAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"GameOver"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Again", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        NSLog(@"Again");
        int i;
        [self initGame];
        for(i = 0; i< maxSize; i++){
            int tag = 110+i;
            UIButton *tmpButton = (UIButton *)[self.view viewWithTag:tag];
            tmpButton.enabled = YES;
            [tmpButton setBackgroundColor:[UIColor lightGrayColor] ];
            [tmpButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        }
    }
}
-(void) updateButtonColor:(NSString*)btn1 andBtn2:(NSString*)btn2 andbtn3:(NSString*)btn3{
    UIButton *button1 = (UIButton *)[self.view viewWithTag:[btn1 intValue]+110];
    [button1 setBackgroundColor:[UIColor colorWithRed:0.57 green:0.82 blue:0.93 alpha:1.0]];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:[btn2 intValue]+110];
    [button2 setBackgroundColor:[UIColor colorWithRed:0.57 green:0.82 blue:0.93 alpha:1.0]];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:[btn3 intValue]+110];
    [button3 setBackgroundColor:[UIColor colorWithRed:0.57 green:0.82 blue:0.93 alpha:1.0]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
