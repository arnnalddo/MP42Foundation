//
//  SubUtilities.h
//  Subler
//
//  Created by Alexander Strange on 7/24/07.
//  Copyright 2007 Perian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversalDetector.h"
#import "MP42TextSample.h"
#import "mp4v2.h"

@interface SBSubLine : NSObject
{
@public
	NSString *line;
	unsigned begin_time, end_time;
	unsigned no; // line number, used only by SBSubSerializer
    unsigned top;
    unsigned forced;
}
-(instancetype)initWithLine:(NSString*)l start:(unsigned)s end:(unsigned)e;
-(instancetype)initWithLine:(NSString*)l start:(unsigned)s end:(unsigned)e top_pos:(unsigned)p forced:(unsigned)f;
@end

@interface SBSubSerializer : NSObject
{
	// input lines, sorted by 1. beginning time 2. original insertion order
	NSMutableArray<SBSubLine *> *lines;
	BOOL finished;

    BOOL position_information, forced;
	unsigned last_begin_time, last_end_time;
	unsigned linesInput;

    BOOL ssa;
}
-(void)addLine:(SBSubLine *)sline;
-(void)setFinished:(BOOL)finished;
-(SBSubLine*)getSerializedPacket;
-(BOOL)isEmpty;
-(BOOL)positionInformation;
-(void)setPositionInformation:(BOOL)info;
-(BOOL)forced;
-(void)setForced:(BOOL)info;
-(void)setSSA:(BOOL)ssa;

@end

NSMutableString *STStandardizeStringNewlines(NSString *str);
extern NSString *STLoadFileWithUnknownEncoding(NSURL *url);
int LoadSRTFromURL(NSURL *url, SBSubSerializer *ss, MP4Duration *duration);
int LoadSMIFromURL(NSURL *url, SBSubSerializer *ss, int subCount);

int LoadChaptersFromURL(NSURL *url, NSMutableArray *ss);
NSString *StripSSALine(NSString *line);

unsigned ParseSubTime(const char *time, unsigned secondScale, BOOL hasSign);

@class MP42SampleBuffer;

MP42SampleBuffer * copySubtitleSample(MP4TrackId subtitleTrackId, NSString *string, MP4Duration duration, BOOL forced, BOOL verticalPlacement, BOOL styles, CGSize trackSize, int top) NS_RETURNS_RETAINED;
MP42SampleBuffer * copyEmptySubtitleSample(MP4TrackId subtitleTrackId, MP4Duration duration, BOOL forced) NS_RETURNS_RETAINED;

typedef struct {
	// color format is 32-bit ARGB
	UInt32  pixelColor[16];
	UInt32  duration;
} PacketControlData;

int ExtractVobSubPacket(UInt8 *dest, UInt8 *framedSrc, int srcSize, int *usedSrcBytes, int index);
ComponentResult ReadPacketControls(UInt8 *packet, UInt32 palette[16], PacketControlData *controlDataOut,BOOL *forced);
Boolean ReadPacketTimes(uint8_t *packet, uint32_t length, uint16_t *startTime, uint16_t *endTime, uint8_t *forced);
