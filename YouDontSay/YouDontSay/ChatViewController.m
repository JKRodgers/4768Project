//
//  ChatViewController.m
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-26.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import "ChatViewController.h"
#import "ImageBubbleView.h"

#define MARGIN 10.0f
#define IMAGE_SIZE CGSizeMake(150,150)
#define RECIEVEDX 10.0f
#define SENDX 170.0f

@interface ChatViewController ()
{
    CGRect originalViewFrame;
    GLfloat lastMessageY;
    GLfloat viewWidth;
    GLfloat viewHeight;
}
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UIButton *browseButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCAdvertiserAssistant *assistant;
@property (strong, nonatomic) MCBrowserViewController *browserVC;
@property (strong, nonatomic) PhotoPickerViewController *photoViewController;

- (IBAction)browseButtonTapped:(UIButton *)sender;
- (IBAction)disconnectButtonTapped:(UIButton *)sender;
- (IBAction)sendButtonTapped:(id)sender;

- (void)setUIToNotConnectedState;
- (void)setUIToConnectedState;

@end

@implementation ChatViewController
@synthesize session;

- (void)viewDidLoad {
    [super viewDidLoad];
    // set chat title
    self.title = @"Chat";
    // set disabled text color
    [self.disconnectButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.browseButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    // set correct buttons to enabled and disabled
    [self setUIToNotConnectedState];
    
    lastMessageY = 0; // lastMessage on screens Y + it's height coordinate. 
    // default width and height of the scrollview
    viewWidth = 320;
    viewHeight = 500;
    self.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    
    // Prepare session
    MCPeerID *myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:myPeerID];
    self.session.delegate = self;
    
    // Start advertising
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:self.session];
    [self.assistant start];
    
    // description of app
    NSString *description = @"YouDontSay is an app that allows the user to connect with peers and send photos to one another. Send photos from your library or take on as you go. You can then proceed to edit the photo with top and bottom text and send that photo to your connected peers. Any photos received you can save to your device by tapping the image and clicking save.";
    // alert with description of app
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Don't Say"
                                                    message: description
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonTapped:(id)sender; {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.photoViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoPickerViewController"];
    self.photoViewController.delegate = self;
    [self.navigationController pushViewController:self.photoViewController animated:YES];
}


- (IBAction)browseButtonTapped:(id)sender {
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:self.session];
    self.browserVC.delegate = self;
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (IBAction)disconnectButtonTapped:(UIButton *)sender {
    [self.session disconnect];
    [self setUIToNotConnectedState];
}

#pragma mark
#pragma mark <MCSessionDelegate> methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{

    if (state == MCSessionStateConnected) // changes chat title to show who is chatting
    {
        self.title = [NSString stringWithFormat:@"Chat with: %@", peerID.displayName];
        [self setUIToConnectedState];
    }
    else if (state == MCSessionStateNotConnected){ // prompts user that someone disconnected
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Disconnected"
                                                        message: [NSString stringWithFormat:@"User %@ disconnected.", peerID.displayName]
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        self.title = @"Chat";
        [self setUIToNotConnectedState];
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data.");
    
    UIImage *image = [UIImage imageWithData:data];

    ImageBubbleView *chatImageRecieved =
    [[ImageBubbleView alloc] initWithImage:image atSize:IMAGE_SIZE];
    
    [chatImageRecieved sizeToFit];
    chatImageRecieved.frame = CGRectMake(MARGIN, lastMessageY + MARGIN, chatImageRecieved.frame.size.width, chatImageRecieved.frame.size.height);
    lastMessageY = chatImageRecieved.frame.size.height + chatImageRecieved.frame.origin.y;
    
    if (lastMessageY >= viewHeight) {
        viewHeight += IMAGE_SIZE.height + MARGIN;
        self.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [chatImageRecieved addGestureRecognizer:tap];
    chatImageRecieved.userInteractionEnabled = YES;
    
    chatImageRecieved.layer.cornerRadius = 10.0;
    chatImageRecieved.layer.masksToBounds = YES;
    
    chatImageRecieved.layer.borderColor = [UIColor blackColor].CGColor;
    chatImageRecieved.layer.borderWidth = 1.0;
    
    [self.scrollView addSubview:chatImageRecieved];
    
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

#pragma mark
#pragma mark <MCBrowserViewControllerDelegate> methods

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)participantID
{
    return self.session.myPeerID.displayName;
}

#pragma mark
#pragma mark helpers

- (void)setUIToNotConnectedState
{
//    self.sendButton.enabled = NO; // not changed so we can test everything without connecting
    self.disconnectButton.enabled = NO;
    self.browseButton.enabled = YES;
}

- (void)setUIToConnectedState
{
    self.sendButton.enabled = YES;
    self.disconnectButton.enabled = YES;
    self.browseButton.enabled = NO;
}

- (UIImage *)rescaleImage:(UIImage *) image toSize:(CGSize)newSize{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)dataFromPhotoViewController:(UIImage *)image{
    NSLog(@"Started from photos now we're here");
        
    ImageBubbleView *chatImageToSend =
    [[ImageBubbleView alloc] initWithImage:image atSize:IMAGE_SIZE];
    
    [chatImageToSend sizeToFit];
    chatImageToSend.frame = CGRectMake(SENDX, lastMessageY + MARGIN, chatImageToSend.frame.size.width, chatImageToSend.frame.size.height);
    lastMessageY = chatImageToSend.frame.size.height + chatImageToSend.frame.origin.y;
    
    if (lastMessageY >= viewHeight) {
        viewHeight += IMAGE_SIZE.height + MARGIN;
        self.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [chatImageToSend addGestureRecognizer:tap];
    chatImageToSend.userInteractionEnabled = YES;
    
    chatImageToSend.layer.cornerRadius = 10.0;
    chatImageToSend.layer.masksToBounds = YES;
    
    chatImageToSend.layer.borderColor = [UIColor blackColor].CGColor;
    chatImageToSend.layer.borderWidth = 1.0;
    
    [self.scrollView addSubview:chatImageToSend];
    
    NSArray *peerIDs = session.connectedPeers;
    NSData *jpeg = UIImageJPEGRepresentation(image, .2);
    [self.session sendData:jpeg toPeers:peerIDs withMode:MCSessionSendDataReliable error:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Sent"
                                                    message: [NSString stringWithFormat:@"Sending image to %lu connected users", (unsigned long)peerIDs.count]
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

// Tapped image should go to full screen size
- (void)imageTapped:(UITapGestureRecognizer *)sender{
    NSLog(@"ImageTapped");
    
    UIImageView *touchedView = (UIImageView *)sender.view;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewImageVC = [storyboard instantiateViewControllerWithIdentifier:@"ViewImageViewController"];
    //Get Image from tapped ImageBubbleView
    self.viewImageVC.viewImage = touchedView.image;
    
    [self.navigationController pushViewController:self.viewImageVC animated:YES];
}

@end
