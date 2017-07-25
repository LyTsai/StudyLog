//
// ANPDFImage.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// This option adds support for using PDFs in UIImageView's in NIB files.
// (You can specify PDF files for image views and they will load in your app,
// but interface builder won't display them)
// Use this option at your own risk; you could potentially fall afoul
// of Apple's SPI rules, but I think it's unlikely.
#define UIImage_PDFSupport_SupportNIBLoading 0

// usage:
//
//	UIImage * image = [ UIImage imageNamed:@"test.pdf" ] ;
//

@interface UIImage ( PDFSupport )

// returns an array containing images of the pages in a PDF
+(NSArray*)imagesWithPDFNamed:(NSString*)name
                        scale:(CGFloat)scale;

// returns an array containing images of the pages in a PDF, scaled by 'transform'
+(NSArray*)imagesWithPDFNamed:(NSString*)name
                        scale:(CGFloat)scale
                    transform:(CGAffineTransform)t;

// returns an image of the first page in a PDF
+(UIImage*)imageWithPDFNamed:(NSString*)name
                       scale:(CGFloat)scale;

// returns an image of the first page in a PDF, scaled by 'transform'
+(UIImage*)imageWithPDFNamed:(NSString*)name
                       scale:(CGFloat)scale
                   transform:(CGAffineTransform)t;

@end