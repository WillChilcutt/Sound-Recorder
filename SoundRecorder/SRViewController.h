//
//  SRViewController.h
//  SoundRecorder
//
//  Created by Will Chilcutt on 4/4/12.
//  Copyright (c) 2012 ETSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SRViewController : UIViewController <AVAudioPlayerDelegate>
{
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isRecording;
}
@property (nonatomic) BOOL isRecording;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

- (IBAction)playPause:(id)sender;

- (IBAction)startStopRecording:(id)sender;

@end
