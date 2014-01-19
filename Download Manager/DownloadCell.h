//
//  DownloadCell.h
//  TestingPlatform
//
//  Created by Robert Ryan on 11/21/12.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UILabel *issue;
@property (nonatomic, strong) IBOutlet UIImageView *coverimage;
@property (strong, nonatomic) IBOutlet UILabel *TapLabel;
//@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
//- (IBAction)downloadButtonPressed:(id)sender;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
//@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
