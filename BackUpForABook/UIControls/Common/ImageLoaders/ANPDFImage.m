//
// ANPDFImage.h
//
#import "ANPDFImage.h"
#import <CoreGraphics/CoreGraphics.h>
#import <objc/runtime.h>

#undef DebugLog

#ifndef DebugAssert
#define DebugAssert(x) assert((x))
#endif


static UIImage * (*old_UIImage_imageNamed)(id target, SEL selector, NSString * name ) = NULL ;

#if UIImage_PDFSupport_SupportNIBLoading
static UIImage * (*oldUIImageNibPlaceholder_InitWithCoder)(id, SEL, NSKeyedUnarchiver*) = NULL ;
static UIImage * UIImageNibPlaceholder_InitWithCoder( id self, SEL _cmd, NSKeyedUnarchiver * unarchiver )
{
	NSString * resourceName = [ unarchiver decodeObjectForKey:@"UIResourceName" ] ;
	UIImage * result = [ UIImage imageNamed:resourceName ] ;
	if ( result )
	{
		[ self autorelease ] ;
		return [ result retain ] ;
	}
	
	return (*oldUIImageNibPlaceholder_InitWithCoder)( self, _cmd, unarchiver ) ;
}
#endif

static UIImage * UIImageWithPDF( id target, SEL selector, NSString * name )
{
	UIImage * result = (*old_UIImage_imageNamed)( target, selector, name ) ;
	if ( !result )
	{
		result = [ UIImage imageWithPDFNamed:name scale:[ UIScreen mainScreen ].scale ] ;
	}
	
	return result ;
}

static CGPDFDocumentRef CreatePDFDocumentWithName( CFStringRef nameCFString )
{
	if ( !nameCFString )
	{
		return NULL ;
	}
	
	NSString * name = (__bridge NSString*)nameCFString ;
	name = [ name stringByDeletingPathExtension ] ;
	
	NSString * path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"pdf" ] ;
	if ( !path )
	{
		return NULL ;
	}
	
	CFURLRef url = CFAutorelease( CFURLCreateWithFileSystemPath( kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false ) ) ;
	DebugAssert( url ) ;
	
	CGPDFDocumentRef doc = CGPDFDocumentCreateWithURL( url ) ;
    
	return doc ;
}

@implementation UIImage ( PDFSupport )

+(void)load
{
	Method m = class_getClassMethod( [ UIImage class ], @selector( imageNamed: )) ;
	old_UIImage_imageNamed = (UIImage *(*)(id, SEL, NSString*))method_setImplementation( m, (IMP)UIImageWithPDF ) ;
	DebugAssert( old_UIImage_imageNamed ) ;
	
#if UIImage_PDFSupport_SupportNIBLoading
	oldUIImageNibPlaceholder_InitWithCoder = (UIImage	* (*)(id, SEL, NSKeyedUnarchiver*))class_replaceMethod( NSClassFromString(@"UIImageNibPlaceholder"), @selector( initWithCoder: ), (IMP)UIImageNibPlaceholder_InitWithCoder, "@@:@" ) ;
#endif
}

+(UIImage*)imageWithPDFPage:(CGPDFPageRef)page scale:(CGFloat)scale transform:(CGAffineTransform)t
{
	if ( !page )
	{
		return nil ;
	}
	
	CGRect box = CGPDFPageGetBoxRect( page, kCGPDFCropBox ) ;
	DebugAssert( box.size.width >= FLT_MIN && box.size.height >= FLT_MIN );
	
	t = CGAffineTransformConcat( CGAffineTransformMakeScale( scale, scale ), t ) ;
	box = CGRectApplyAffineTransform( box, t ) ;
	
	size_t pixelWidth = box.size.width ;
	CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB() ;
	DebugAssert( cs ) ;
	
	CGContextRef c = CGBitmapContextCreate( NULL, box.size.width, box.size.height, 8, 4 * pixelWidth, cs, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast ) ;
	CGColorSpaceRelease( cs ) ;
	DebugAssert( c ) ;
	
	CGContextConcatCTM( c, t ) ;
	CGContextDrawPDFPage( c, page ) ;
	
	CGImageRef cgImage = CGBitmapContextCreateImage( c ) ;
	DebugAssert( cgImage ) ;
	
	CGContextRelease( c ) ;
	
	UIImage * image = image = [ UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp ] ;
	CGImageRelease( cgImage ) ;
	
	return image ;
}

+(NSArray*)imagesWithPDFNamed:(NSString*)name scale:(CGFloat)scale transform:(CGAffineTransform)t
{
	CGPDFDocumentRef doc = CreatePDFDocumentWithName( (__bridge CFStringRef)name ) ;
	
	NSMutableArray * array = [ NSMutableArray array ] ;
    
	// PDF pages are numbered starting at page 1
	for( size_t pageIndex=1, numberOfPages = CGPDFDocumentGetNumberOfPages( doc ); pageIndex <= numberOfPages; ++pageIndex )
	{
		CGPDFPageRef page = CGPDFDocumentGetPage( doc, pageIndex ) ;
		UIImage * image = [ UIImage imageWithPDFPage:page scale:scale transform:t ] ;
		
		[ array addObject:image ? image : (UIImage*)[ NSNull null ] ] ;
	}
	
	return array ;
}

+(NSArray*)imagesWithPDFNamed:(NSString*)name scale:(CGFloat)scale
{
	return [ self imagesWithPDFNamed:name scale:scale transform:CGAffineTransformIdentity ] ;
}


+(UIImage*)imageWithPDFNamed:(NSString*)name scale:(CGFloat)scale transform:(CGAffineTransform)t
{
	CGPDFDocumentRef doc = CreatePDFDocumentWithName( (__bridge CFStringRef)name ) ;
	if ( !doc )
	{
		return NULL ;
	}
    
	// PDF pages are numbered starting at page 1
	CGPDFPageRef page = CGPDFDocumentGetPage( doc, 1 ) ;
	DebugAssert( page ) ;
	
	UIImage * result = [ UIImage imageWithPDFPage:page scale:scale transform:t ] ;
	CFRelease( doc ) ;
	
	return result ;
}

+(UIImage*)imageWithPDFNamed:(NSString*)name scale:(CGFloat)scale
{
	return [ self imageWithPDFNamed:name scale:scale transform:CGAffineTransformIdentity ] ;
}

@end