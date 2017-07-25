//
//  JAMSVGParser.m
//  ATreeRingMap
//
//  Created by Hui Wang on 7/19/14.
//  Copyright (c) 2014 AnnieLyticx. All rights reserved.
//

#import "JAMSVGParser.h"
#import "JAMSVGParser.h"
#import "JAMStyledBezierPath.h"
#import "JAMStyledBezierPathFactory.h"

@interface JAMStyledBezierPathFactory (Private)
@property (nonatomic) NSNumber *groupOpacityValue;
- (void)addGroupOpacityValueWithAttributes:(NSDictionary *)attributes;
- (void)removeGroupOpacityValue;
@end

@interface JAMSVGParser () <NSXMLParserDelegate>
@property (nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) JAMStyledBezierPathFactory *pathFactory;
@end

@implementation JAMSVGParser

- (id)initWithSVGDocument:(NSString *)path;
{
    if (!(self = [super init])) return nil;
    
    return [self initWithSVGData:[NSData dataWithContentsOfFile:path]];
}

- (id)initWithSVGData:(NSData *)data;
{
    if (!(self = [super init])) return nil;
    
    self.xmlParser = [NSXMLParser.alloc initWithData:data];
    self.xmlParser.delegate = self;
    self.paths = NSMutableArray.new;
    self.pathFactory = JAMStyledBezierPathFactory.new;
    return self;
}

- (BOOL)parseSVGDocument;
{
    BOOL didSucceed = [self.xmlParser parse];
    if (self.xmlParser.parserError)
        NSLog(@"parserError: %@", self.xmlParser.parserError);
    
    return didSucceed;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"svg"]) {
        self.viewBox = [self.pathFactory getViewboxFromAttributes:attributeDict];
        return;
    }
    if ([elementName isEqualToString:@"stop"]) {
        [self.pathFactory addGradientStopWithAttributes:attributeDict];
        return;
    }
    if ([elementName isEqualToString:@"g"]) {
        [self.pathFactory addGroupOpacityValueWithAttributes:attributeDict];
    }
    JAMStyledBezierPath *path = [self.pathFactory styledPathFromElementName:elementName attributes:attributeDict];
    if (path)
        [self.paths addObject:path];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:@"g"]) {
        [self.pathFactory removeGroupOpacityValue];
    }
}

@end
