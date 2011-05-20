//
//  SheepImageToDataTransformer.m
//  Pins
//
//  Created by F + on 5/20/11.
//  Copyright 2011 ObjectiveSheep. All rights reserved.
//

#import "SheepImageToDataTransformer.h"

@implementation SheepImageToDataTransformer

+ (BOOL)allowsReverseTransformation 
{
	return YES;
}

+ (Class)transformedValueClass 
{
	return [NSData class];
}

- (id)transformedValue:(id)value 
{
    NSBitmapImageRep *rep = [[value representations] objectAtIndex: 0];
    NSData *data = [rep representationUsingType: NSPNGFileType
                                     properties: nil];
	return data;
}

- (id)reverseTransformedValue:(id)value 
{
    NSImage *uiImage = [[NSImage alloc] initWithData:value];
	return uiImage;
}

@end
