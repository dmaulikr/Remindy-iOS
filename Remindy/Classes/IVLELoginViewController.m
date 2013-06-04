//
//  IVLELoginViewController.m
//  IVLELogin
//
//  Created by Yasmin Musthafa on 5/27/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IVLELoginViewController.h"

@implementation IVLELoginViewController
@synthesize webView;



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
[super viewDidLoad];

	NSString *apikey = @"ziGsQQOz1ymvjT2ZRQzDp";

	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

	NSString *redirectUrlString = @"http://ivle.nus.edu.sg/api/login/login_result.ashx";
	NSString *authFormatString = @"https://ivle.nus.edu.sg/api/login/?apikey=%@";

	 NSString *urlString = [NSString stringWithFormat:authFormatString, apikey, redirectUrlString];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];

	[webView loadRequest:request];	   

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
    NSString *urlString = request.URL.absoluteString;
	NSLog(@"urlString: %@", urlString);
	
    [self checkForAccessToken:urlString];  	

    return TRUE;
}


-(void)checkForAccessToken:(NSString *)urlString {
	

	NSError *error;
		
	NSLog(@"checkForAccessToken: %@", urlString);
	NSRegularExpression *regex = [NSRegularExpression 
								  regularExpressionWithPattern:@"r=(.*)" 
								  options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = 
		[regex firstMatchInString:urlString 
						  options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *success = [urlString substringWithRange:accessTokenRange];
            success = [success 
						   stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			//check for r=0
			NSLog(@"success: %@", success);
			
			if ([success isEqualToString:@"0"]) {
				NSURL *responseURL = [NSURL URLWithString:urlString];

				NSString *token = [NSString stringWithContentsOfURL:responseURL 
														   encoding:NSASCIIStringEncoding
															  error:&error];
				
				//print out the token or save for next logon or to navigate to next API call.
				NSLog(@"token: %@", token);
				
				

			}
        
		
        }
	}
    
}




- (void)dealloc {
    self.webView = nil;
    [super dealloc];
}




/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



@end