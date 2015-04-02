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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UIButton *browseButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCAdvertiserAssistant *assistant;
@property (strong, nonatomic) MCBrowserViewController *browserVC;
@property (strong, nonatomic) PhotoPickerViewController *photoViewController;

- (IBAction)browseButtonTapped:(UIButton *)sender;
- (IBAction)disconnectButtonTapped:(UIButton *)sender;
- (IBAction)sendButtonTapped:(id)sender;

- (void)setUIToNotConnectedState;
- (void)setUIToConnectedState;
- (void)resetView;

@end

@implementation ChatViewController
@synthesize session;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Chat";
    
    [self setUIToNotConnectedState];
    
    lastMessageY = 0; // lastMessage on screens Y + it's height coordinate. 

    viewWidth = 320;
    viewHeight = 500;
    self.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Prepare session
    MCPeerID *myPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:myPeerID];
    self.session.delegate = self;
    
    // Start advertising
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:self.session];
    [self.assistant start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark selectors

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self resetView];
    // Get the size of the keyboard.
    CGRect keyboardFrameInWindow = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.view.frame;
    [UIView beginAnimations: @"moveUp" context: nil];
    [UIView setAnimationDuration:0.29];
    float height = [self.view convertRect:keyboardFrameInWindow fromView:nil].size.height;
    self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations: @"moveDown" context: nil];
    [UIView setAnimationDuration:0.29];
    [self resetView];
    [UIView commitAnimations];
    return;
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

- (IBAction)clearButtonTapped:(UIButton *)sender {
//    self.textView.text = @"";
}

#pragma mark
#pragma mark <MCSessionDelegate> methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSString *str = [NSString stringWithFormat:@"Status: %@", peerID.displayName];
    if (state == MCSessionStateConnected)
    {
        self.statusLabel.text = [str stringByAppendingString:@" connected"];
        [self setUIToConnectedState];
    }
    else if (state == MCSessionStateNotConnected)
        self.statusLabel.text = [str stringByAppendingString:@" not connected"];
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data.");
    
    UIImage *image = [UIImage imageWithData:data];
//    UIImage *smallerImage = [self rescaleImage:image toSize:CGSizeMake(150,150)];

    ImageBubbleView *chatImageRecieved =
    [[ImageBubbleView alloc] initWithImage:image atSize:IMAGE_SIZE];
    
    [chatImageRecieved sizeToFit];
    chatImageRecieved.frame = CGRectMake(MARGIN, lastMessageY + MARGIN, chatImageRecieved.frame.size.width, chatImageRecieved.frame.size.height);
    lastMessageY = chatImageRecieved.frame.size.height + chatImageRecieved.frame.origin.y;
    
    if (lastMessageY >= viewHeight) {
        viewHeight += lastMessageY;
        self.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [chatImageRecieved addGestureRecognizer:tap];
    chatImageRecieved.userInteractionEnabled = YES;
    
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
//    self.sendButton.enabled = NO;
    self.disconnectButton.enabled = NO;
    self.browseButton.enabled = YES;
}

- (void)setUIToConnectedState
{
    self.sendButton.enabled = YES;
    self.disconnectButton.enabled = YES;
    self.browseButton.enabled = NO;
}

- (void)resetView
{
    self.view.frame = originalViewFrame;
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
    
//    UIImage *smallerImage = [self rescaleImage:image toSize:CGSizeMake(150,150)];
    
    ImageBubbleView *chatImageToSend =
    [[ImageBubbleView alloc] initWithImage:image atSize:IMAGE_SIZE];
    
    [chatImageToSend sizeToFit];
    chatImageToSend.frame = CGRectMake(SENDX, lastMessageY + MARGIN, chatImageToSend.frame.size.width, chatImageToSend.frame.size.height);
    lastMessageY = chatImageToSend.frame.size.height + chatImageToSend.frame.origin.y;
    
    if (lastMessageY >= viewHeight) {
        viewHeight += lastMessageY;
        self.scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [chatImageToSend addGestureRecognizer:tap];
    chatImageToSend.userInteractionEnabled = YES;
    
    [self.scrollView addSubview:chatImageToSend];
    
    NSArray *peerIDs = session.connectedPeers;
    NSData *jpeg = UIImageJPEGRepresentation(image, .2);
    [self.session sendData:jpeg toPeers:peerIDs withMode:MCSessionSendDataReliable error:nil];
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
