//
//  MasterViewController.m
//  Download Manager
//
//  Created by Robert Ryan on 11/24/12.
//  Copyright (c) 2012 Robert Ryan.
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

#import "MasterViewController.h"

#import "DownloadManager.h"
#import "DownloadCell.h"
#import "jits.h"
#import "AppDelegate.h"
#import "ReaderViewController.h"


@interface MasterViewController () <DownloadManagerDelegate, ReaderViewControllerDelegate>



@property (strong, nonatomic) DownloadManager *downloadManager;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) NSInteger downloadErrorCount;
@property (nonatomic) NSInteger downloadSuccessCount;

@end

@implementation MasterViewController
@synthesize json, jitsArray;

#pragma mark Constants

#define DEMO_VIEW_CONTROLLER_PUSH FALSE

#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self retrieveData];
    
    self.downloadManager = [[DownloadManager alloc] initWithDelegate:self];
    self.downloadManager.maxConcurrentDownloads = 4;
}

-(void)retrieveData
{
    //NSLog(@"retrieveData called!");
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    
    NSURL *url = [NSURL URLWithString:@"http://speedyreference.com/jits.php"];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //Set up our exhibitors array
    jitsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < json.count; i++) {
        //create exhibitors object
        NSString * jID = [[json objectAtIndex:i] objectForKey:@"ID"];
        NSString * jCoverImage = [[json objectAtIndex:i] objectForKey:@"COVERIMAGE"];
        NSString * jURL = [[json objectAtIndex:i] objectForKey:@"URL"];
        NSString * jIssue = [[json objectAtIndex:i] objectForKey:@"ISSUE"];
        
        
        jits * myJits = [[jits alloc] initWithjitsID: jID andCoverImage:jCoverImage andURL:jURL andIssue:jIssue];
        
        
        //Add our exhibitors object to our exhibitorsArray
        [jitsArray addObject:myJits];
        //NSLog(@"jitsArray count is: %lu", (unsigned long)jitsArray.count);
    }
    
        //jits * jitsInstance = nil;
        
        //jitsInstance = [jitsArray objectAtIndex:0];
        
        //NSString *myStr = [[NSString alloc] initWithFormat:@"%@", jitsInstance.issue ];
        
        //NSLog(@"Issue text from RetrieveData: %@", myStr);
        //NSLog(@"URL from RetrieveData: %@", jitsInstance.url);
    
    
    
    
    //});
    //});
    
    [self.tableView reloadData];
}


- (void)queueAndStartDownloads
{
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
    
//    NSURL *downloadURL = [NSURL URLWithString:@"http://speedyreference.com/jits.php"];
//    NSData * data = [NSData dataWithContentsOfURL:downloadURL];
    
//    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    
//    //Set up our exhibitors array
//    jitsArray = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < json.count; i++) {
//        //create exhibitors object
//        NSString * jID = [[json objectAtIndex:i] objectForKey:@"ID"];
//        NSString * jCoverImage = [[json objectAtIndex:i] objectForKey:@"COVERIMAGE"];
//        NSString * jURL = [[json objectAtIndex:i] objectForKey:@"URL"];
//        NSString * jIssue = [[json objectAtIndex:i] objectForKey:@"ISSUE"];
//        
//        
//        jits * myJits = [[jits alloc] initWithjitsID: jID andCoverImage:jCoverImage andURL:jURL andIssue:jIssue];
//        
//        
//        //Add our exhibitors object to our exhibitorsArray
//        [jitsArray addObject:myJits];
//    
////#warning replace URLs with the names of the files and the URL you want to download them from
//
//    // an array of files to be downloaded
//    
//    }
    
    jits * jitsInstance = nil;
    
    jitsInstance = [jitsArray objectAtIndex:0];
    
    NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
    
    NSLog(@"Issue URL is:%@", myURL);
    
//    NSArray *urlStrings = @[@"http://speedyreference.com/bicsi/newsstand/jits/JournalITS.pdf",
//                            @"http://speedyreference.com/bicsi/newsstand/jits/JITS.pdf"/*,
//                            @"http://www.yourwebsitehere.com/test/file3.pdf",
//                            @"http://www.yourwebsitehere.com/test/file4.pdf"*/];
    
    // create download manager instance
    
    self.downloadManager = [[DownloadManager alloc] initWithDelegate:self];
    self.downloadManager.maxConcurrentDownloads = 4;
    
    // queue the files to be downloaded
    
//    for (NSString *urlString in urlStrings)
//    {
        NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[myURL lastPathComponent]];
        NSURL *url = [NSURL URLWithString:myURL];
        
        [self.downloadManager addDownloadWithFilename:downloadFilename URL:url];
    //}
    
    // I've added a cancel button to my user interface, so now that downloads have started, let's enable that button
    
    self.cancelButton.enabled = YES;
    self.startDate = [NSDate date];
    
    [self.downloadManager start];
}

#pragma mark - DownloadManager Delegate Methods

// optional method to indicate completion of all downloads
//
// In this view controller, display message

- (void)didFinishLoadingAllForManager:(DownloadManager *)downloadManager
{
    NSString *message;
    
    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:self.startDate];
    
    self.cancelButton.enabled = NO;
    
    if (self.downloadErrorCount == 0)
    {
        message = [NSString stringWithFormat:@"%d file(s) downloaded successfully. The files are located in the app's Documents folder on your device/simulator. (%.1f seconds)", self.downloadSuccessCount, elapsed];
    //////
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSArray *pdfs = [[NSBundle bundleWithPath:[paths objectAtIndex:0]] pathsForResourcesOfType:@"pdf" inDirectory:@"downloads"];
//        NSString *filePath = [pdfs lastObject];
//        
//        if ([fileManager fileExistsAtPath:filePath]) {
//            NSLog(@"No error - File path is: %@",filePath);
//        }
//        else{
//            NSLog(@"Error - File path is: %@", filePath);
//            
//        }

        /////
        
    
    }
    
    else
    {
        message = [NSString stringWithFormat:@"%d file(s) downloaded successfully. %d file(s) were not downloaded successfully. The files are located in the app's Documents folder on your device/simulator. (%.1f seconds)", self.downloadSuccessCount, self.downloadErrorCount, elapsed];
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    }
}

// optional method to indicate that individual download completed successfully
//
// In this view controller, I'll keep track of a counter for entertainment purposes and update
// tableview that's showing a list of the current downloads.

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFinishLoading:(Download *)download;
{
    self.downloadSuccessCount++;
    
    [self.tableView reloadData];
}

// optional method to indicate that individual download failed
//
// In this view controller, I'll keep track of a counter for entertainment purposes and update
// tableview that's showing a list of the current downloads.

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFail:(Download *)download;
{
    NSLog(@"%s %@ error=%@", __FUNCTION__, download.filename, download.error);
    
    self.downloadErrorCount++;
    
    [self.tableView reloadData];
}

// optional method to indicate progress of individual download
//
// In this view controller, I'll update progress indicator for the download.

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidReceiveData:(Download *)download;
{
    //for (NSInteger row = [downloadManager.downloads objectAtIndex:0]; row < [downloadManager.downloads count]; row++)
    //{
        //if (download == [downloadManager.downloads objectAtIndex:0])
        //{
            //[self updateProgressViewForIndexPath:[NSIndexPath indexPathForRow:[downloadManager.downloads objectAtIndex:0] inSection:0] download:download];
            //break;
        //}
        
        //[downloadManager.downloads removeObjectAtIndex:0];
    //}
////////////////////////////////////////
    
    for (NSInteger row = 0; row < [downloadManager.downloads count]; row++)
        
    {
        if (download == downloadManager.downloads[row])
            {
            [self updateProgressViewForIndexPath:[NSIndexPath indexPathForRow:row inSection:0] download:download];
                
            }
        
            break;
        
        }

    
}

#pragma mark - Table View delegate and data source methods

// our table view will simply display a list of files being downloaded

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.downloadManager.downloads count];
    return[jitsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"DownloadCell";
//    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"DownloadCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DownloadCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    
    jits * jitsInstance = nil;
    
    jitsInstance = [jitsArray objectAtIndex:indexPath.row];
    
    
    //Download *download = self.downloadManager.downloads[indexPath.row];
    
    // the name of the file
    
    cell.issue.text = jitsInstance.issue;//[download.filename lastPathComponent];
    
    NSString * myCoverURL = [NSString stringWithFormat:@"%@", jitsInstance.coverimage];
    
    UIImage* myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: myCoverURL]]];
    
    //NSLog(@"CoverImage URL is:%@", myCoverURL);
    
    
    cell.coverimage.image = myImage;
    
    
    
    [cell.progressView setProgress:0];
    
    
    NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];

    NSString * fileName = [[NSString alloc]initWithFormat:@"%@", [myURL lastPathComponent]];

    NSString* foofile = [downloadFolder stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    NSLog(@"Search file path: %@", foofile);
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString * fileName = [[NSString alloc]initWithFormat:@"%@", [myURL lastPathComponent]];
//    NSLog(@"filename is: %@", fileName);
//    NSArray *pdfs = [[NSBundle bundleWithPath:[paths objectAtIndex:0]] pathsForResourcesOfType:fileName inDirectory:@"downloads"];
//    NSString * myFilePath = [[NSString alloc]initWithFormat:@"%@", pdfs];
//    NSLog(@"myFilePath is: %@",myFilePath);
//    NSString *filePath = myFilePath;
    
    if (!fileExists) {
        [cell.downloadButton setTitle:@"Download" forState:normal];
        [cell.progressView setHidden:NO];
        NSLog(@"File does not exist!");
        
    }
    else if (fileExists){
        NSLog(@"File exist!");
        [cell.downloadButton setTitle:@"Read" forState:normal];
        [cell.progressView setHidden:YES];
    }

    
    
    //if (download.isDownloading)
    //{
        // if we're downloading a file turn on the activity indicator
        
//        if (!cell.activityIndicator.isAnimating)
//            [cell.activityIndicator startAnimating];
//        
//        cell.activityIndicator.hidden = NO;
        //cell.progressView.hidden = NO;

        //[self updateProgressViewForIndexPath:indexPath download:download];
    //}
    //else
    //{
        // if not actively downloading, no spinning activity indicator view nor file download progress view is needed
        
//        [cell.activityIndicator stopAnimating];
//        cell.activityIndicator.hidden = YES;
        //cell.progressView.hidden = YES;
    //}
    
    return cell;
    
    //[self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self queueAndStartDownloads];
    
    DownloadCell *cell = (DownloadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.downloadButton.currentTitle isEqualToString:@"Download"]) {
        
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
    
    jits * jitsInstance = nil;
    
    jitsInstance = [jitsArray objectAtIndex:indexPath.row];
    
    NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
    
   // NSLog(@"Issue URL is:%@", myURL);
    
    //self.downloadManager = [[DownloadManager alloc] initWithDelegate:self];
    //self.downloadManager.maxConcurrentDownloads = 4;
    
    NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[myURL lastPathComponent]];
    NSURL *url = [NSURL URLWithString:myURL];
    
    NSLog(@"downloadFilename is:%@", downloadFilename);
    
    [self.downloadManager addDownloadWithFilename:downloadFilename URL:url];
    
    self.cancelButton.enabled = YES;
    self.startDate = [NSDate date];
    
    [self.downloadManager start];
        
    
    }
    else if ([cell.downloadButton.currentTitle isEqualToString:@"Read"]){
//        NSString *message = @"Testing Read tap";
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Testing"
//                                                           message:message
//                                                          delegate:self
//                                                 cancelButtonTitle:@"Ok"
//                                                 otherButtonTitles:nil,nil];
//        [alertView show];
        
        jits * jitsInstance = nil;
        
        jitsInstance = [jitsArray objectAtIndex:indexPath.row];
        
        NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
        
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
        
        NSString * fileName = [[NSString alloc]initWithFormat:@"%@", [myURL lastPathComponent]];
        
        NSString* foofile = [downloadFolder stringByAppendingPathComponent:fileName];
        //BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        
        NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:foofile password:phrase];
        
        if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
            
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
            
            [self.navigationController pushViewController:readerViewController animated:YES];
            
#else // present in a modal view controller
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:readerViewController animated:YES completion:NULL];
            
#endif // DEMO_VIEW_CONTROLLER_PUSH
        }


    }
    
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}


#pragma mark - Table view utility methods

- (void)updateProgressViewForIndexPath:(NSIndexPath *)indexPath download:(Download *)download
{
    //DownloadCell *cell = (DownloadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    DownloadCell *cell = (DownloadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    // if the cell is not visible, we can return
    
    if (!cell)
        return;
    
    if (download.expectedContentLength >= 0)
    {
        // if the server was able to tell us the length of the file, then update progress view appropriately
        // to reflect what % of the file has been downloaded
        
        cell.progressView.progress = (double) download.progressContentLength / (double) download.expectedContentLength;
    }
    else
    {
        // if the server was unable to tell us the length of the file, we'll change the progress view, but
        // it will just spin around and around, not really telling us the progress of the complete download,
        // but at least we get some progress update as bytes are downloaded.
        //
        // This progress view will just be what % of the current megabyte has been downloaded
        
        cell.progressView.progress = (double) (download.progressContentLength % 1000000L) / 1000000.0;
    }
}

#pragma mark - IBAction methods

- (IBAction)tappedCancelButton:(id)sender
{
    [self.downloadManager cancelAll];
}

- (IBAction)downloadButtonTapped:(id)sender
{
    [self queueAndStartDownloads];
}




@end
