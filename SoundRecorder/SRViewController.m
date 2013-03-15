//
//  SRViewController.m
//  SoundRecorder
//
//  Created by Will Chilcutt on 4/4/12.
//  Copyright (c) 2012 ETSU. All rights reserved.
//

#import "SRViewController.h"

@implementation SRViewController
@synthesize playButton = _playButton;
@synthesize recordButton = _recordButton;
@synthesize isRecording = _isRecording;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isRecording = NO;
    [self.playButton setEnabled:NO];
    self.playButton.titleLabel.alpha = 0.5;
    recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
}

- (void)viewDidUnload
{
    [self setPlayButton:nil];
    [self setRecordButton:nil];
    recorder = nil;
    player = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
   // [fileManager removeItemAtPath:recordedFile.path error:nil];
    [fileManager removeItemAtURL:recordedFile error:nil];
    recordedFile = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)playPause:(id)sender 
{
    //If the track is playing, pause and achange playButton text to "Play"
    if([player isPlaying])
    {
        [player pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    //If the track is not player, play the track and change the play button to "Pause"
    else
    {
        [player play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)startStopRecording:(id)sender 
{
    //If the app is not recording, we want to start recording, disable the play button, and make the record button say "STOP"
    if(!self.isRecording)
    {
        self.isRecording = YES;
        [self.recordButton setTitle:@"STOP" forState:UIControlStateNormal];
        [self.playButton setEnabled:NO];
        [self.playButton.titleLabel setAlpha:0.5];
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
        [recorder prepareToRecord];
        [recorder record];
        player = nil;
    }
    //If the app is recording, we want to stop recording, enable the play button, and make the record button say "REC"
    else
    {
        self.isRecording = NO;
        [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
        [self.playButton setEnabled:YES];
        [self.playButton.titleLabel setAlpha:1];
        [recorder stop];
        recorder = nil;
        
        NSError *playerError;
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        
        if (player == nil) 
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        player.delegate = self;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}
@end
