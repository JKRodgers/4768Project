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
#define SENDX 160.0f

@interface ChatViewController ()
{
    CGRect originalViewFrame;
    GLfloat lastMessageY;
    
    UIImageView *imageToSend;
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
    
    // Do any additional setup after loading the view, typically from a nib.
    //    self.textInput.delegate = self;
    [self setUIToNotConnectedState];
    //    originalViewFrame = self.view.frame;
     
    ImageBubbleView *chatImageRecieved =
    [[ImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"YouDontSay"] withDirection:ViewLeft atSize:IMAGE_SIZE];
     
    [chatImageRecieved sizeToFit];
    chatImageRecieved.frame = CGRectMake(MARGIN, MARGIN, chatImageRecieved.frame.size.width, chatImageRecieved.frame.size.height);
    lastMessageY = chatImageRecieved.frame.size.height + chatImageRecieved.frame.origin.y;
     
    [self.scrollView addSubview:chatImageRecieved];
    
    ImageBubbleView *chatImageSent =
    [[ImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"AintNobody"] withDirection:ViewRight atSize:IMAGE_SIZE];
    
    [chatImageSent sizeToFit];
    chatImageSent.frame = CGRectMake(SENDX, lastMessageY + MARGIN, chatImageSent.frame.size.width, chatImageSent.frame.size.height);
    lastMessageY = chatImageSent.frame.size.height + chatImageSent.frame.origin.y;

    [self.scrollView addSubview:chatImageSent];
    
    ImageBubbleView *chatImageSent2 =
    [[ImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"AintNobody"] withDirection:ViewRight atSize:IMAGE_SIZE];
    
    [chatImageSent2 sizeToFit];
    chatImageSent2.frame = CGRectMake(SENDX, lastMessageY + MARGIN, chatImageSent2.frame.size.width, chatImageSent2.frame.size.height);
    lastMessageY = chatImageSent2.frame.size.height + chatImageSent2.frame.origin.y;

    [self.scrollView addSubview:chatImageSent2];
    
    ImageBubbleView *chatImageRecieved2 =
    [[ImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"YouDontSay"] withDirection:ViewLeft atSize:IMAGE_SIZE];
    
    [chatImageRecieved2 sizeToFit];
    chatImageRecieved2.frame = CGRectMake(MARGIN, lastMessageY + MARGIN, chatImageRecieved2.frame.size.width, chatImageRecieved2.frame.size.height);
    lastMessageY = chatImageRecieved2.frame.size.height + chatImageRecieved2.frame.origin.y;
    
    [self.scrollView addSubview:chatImageRecieved2];
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    
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
//    NSString *str = [[NSString alloc] initWithData:data
//                                          encoding:NSASCIIStringEncoding];
    NSLog(@"Received data.");
//    if ([str hasPrefix:@"\x04\vstreamtype"])
//        str = @"call established";
//    NSString *tempStr = [NSString stringWithFormat:@"%@\nMsg from %@: %@",
//                         self.textView.text,
//                         peerID.displayName,
//                         str];
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.textView.text = tempStr;
    });
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

- (void)dataFromPhotoViewController:(UIImage *)image{
    NSLog(@"Started from photos now we're here");
    ImageBubbleView *chatImageToSend =
    [[ImageBubbleView alloc] initWithImage:image withDirection:ViewRight atSize:IMAGE_SIZE];
    
    [chatImageToSend sizeToFit];
    chatImageToSend.frame = CGRectMake(SENDX, lastMessageY + MARGIN, chatImageToSend .frame.size.width, chatImageToSend.frame.size.height);
    lastMessageY = chatImageToSend.frame.size.height + chatImageToSend.frame.origin.y;
    
    [self.scrollView addSubview:chatImageToSend];
    
    NSArray *peerIDs = session.connectedPeers;
    NSString *str = self.textInput.text;
    [self.session sendData:[str dataUsingEncoding:NSASCIIStringEncoding]
                    toPeers:peerIDs
                    withMode:MCSessionSendDataReliable error:nil];
    self.textInput.text = @"";
    [self.textInput resignFirstResponder];
    // echo in the local text view
    self.textView.text = [NSString stringWithFormat:@"%@\n> %@", self.textView.text, str];
}

@end
