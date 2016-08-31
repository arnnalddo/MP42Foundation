//
//  MP42Metadata.m
//  Subler
//
//  Created by Damiano Galassi on 06/02/09.
//  Copyright 2009 Damiano Galassi. All rights reserved.
//

#import "MP42Metadata.h"
#import "MP42PrivateUtilities.h"
#import "MP42XMLReader.h"
#import "MP42Image.h"
#import "MP42Ratings.h"

#import "NSString+MP42Additions.h"

NSString *const MP42MetadataKeyName = @"Name";
NSString *const MP42MetadataKeyTrackSubTitle = @"Track Sub-Title";

NSString *const MP42MetadataKeyAlbum = @"Album";
NSString *const MP42MetadataKeyAlbumArtist = @"Album Artist";
NSString *const MP42MetadataKeyArtist = @"Artist";

NSString *const MP42MetadataKeyGrouping = @"Grouping";
NSString *const MP42MetadataKeyUserComment = @"Comments";
NSString *const MP42MetadataKeyUserGenre = @"Genre";
NSString *const MP42MetadataKeyReleaseDate = @"Release Date";

NSString *const MP42MetadataKeyTrackNumber = @"Track #";
NSString *const MP42MetadataKeyDiscNumber = @"Disk #";
NSString *const MP42MetadataKeyBeatsPerMin = @"Tempo";

NSString *const MP42MetadataKeyKeywords = @"Keywords";
NSString *const MP42MetadataKeyCategory = @"Category";
NSString *const MP42MetadataKeyCredits = @"Credits";
NSString *const MP42MetadataKeyThanks = @"Thanks";
NSString *const MP42MetadataKeyCopyright = @"Copyright";

NSString *const MP42MetadataKeyDescription = @"Description";
NSString *const MP42MetadataKeyLongDescription = @"Long Description";
NSString *const MP42MetadataKeySeriesDescription = @"Series Description";
NSString *const MP42MetadataKeySongDescription = @"Song Description";

NSString *const MP42MetadataKeyRating = @"Rating";
NSString *const MP42MetadataKeyRatingAnnotation = @"Rating Annotation";
NSString *const MP42MetadataKeyContentRating = @"Content Rating";

NSString *const MP42MetadataKeyEncodedBy = @"Encoded By";
NSString *const MP42MetadataKeyEncodingTool = @"Encoding Tool";

NSString *const MP42MetadataKeyCoverArt = @"Cover Art";
NSString *const MP42MetadataKeyMediaKind = @"Media Kind";
NSString *const MP42MetadataKeyGapless = @"Gapless";
NSString *const MP42MetadataKeyHDVideo = @"HD Video";
NSString *const MP42MetadataKeyiTunesU = @"iTunes U";

NSString *const MP42MetadataKeyStudio = @"Studio";
NSString *const MP42MetadataKeyCast = @"Cast";
NSString *const MP42MetadataKeyDirector = @"Director";
NSString *const MP42MetadataKeyCodirector = @"Codirector";
NSString *const MP42MetadataKeyProducer = @"Producers";
NSString *const MP42MetadataKeyExecProducer = @"Executive Producer";
NSString *const MP42MetadataKeyScreenwriters = @"Screenwriters";

NSString *const MP42MetadataKeyTVShow = @"TV Show";
NSString *const MP42MetadataKeyTVEpisodeNumber = @"TV Episode #";
NSString *const MP42MetadataKeyTVNetwork = @"TV Network";
NSString *const MP42MetadataKeyTVEpisodeID = @"TV Episode ID";
NSString *const MP42MetadataKeyTVSeason = @"TV Season";

NSString *const MP42MetadataKeyArtDirector = @"Art Director";
NSString *const MP42MetadataKeyComposer = @"Composer";
NSString *const MP42MetadataKeyArranger = @"Arranger";
NSString *const MP42MetadataKeyAuthor = @"Lyricist";
NSString *const MP42MetadataKeyLyrics = @"Lyrics";
NSString *const MP42MetadataKeyAcknowledgement = @"Acknowledgement";
NSString *const MP42MetadataKeyConductor = @"Conductor";
NSString *const MP42MetadataKeyLinerNotes = @"Linear Notes";
NSString *const MP42MetadataKeyRecordCompany = @"Record Company";
NSString *const MP42MetadataKeyOriginalArtist = @"Original Artist";
NSString *const MP42MetadataKeyPhonogramRights = @"Phonogram Rights";
NSString *const MP42MetadataKeySongProducer = @"Song Producer";
NSString *const MP42MetadataKeyPerformer = @"Performer";
NSString *const MP42MetadataKeyPublisher = @"Publisher";
NSString *const MP42MetadataKeySoundEngineer = @"Sound Engineer";
NSString *const MP42MetadataKeySoloist = @"Soloist";
NSString *const MP42MetadataKeyDiscCompilation = @"Compilation";

NSString *const MP42MetadataKeyWorkName = @"Work Name";
NSString *const MP42MetadataKeyMovementName = @"Movement Name";
NSString *const MP42MetadataKeyMovementNumber = @"Movement Number";
NSString *const MP42MetadataKeyMovementCount = @"Movement Count";
NSString *const MP42MetadataKeyShowWorkAndMovement = @"Show Work And Movement";

NSString *const MP42MetadataKeyXID = @"XID";
NSString *const MP42MetadataKeyArtistID = @"artist ID";
NSString *const MP42MetadataKeyComposerID = @"composer ID";
NSString *const MP42MetadataKeyContentID = @"content ID";
NSString *const MP42MetadataKeyGenreID = @"genre ID";
NSString *const MP42MetadataKeyPlaylistID = @"playlist ID";
NSString *const MP42MetadataKeyAppleID = @"iTunes Account";
NSString *const MP42MetadataKeyAccountKind = @"iTunes Account Type";
NSString *const MP42MetadataKeyAccountCountry = @"iTunes Country";
NSString *const MP42MetadataKeyPurchasedDate = @"Purchase Date";
NSString *const MP42MetadataKeyOnlineExtras = @"Online Extras";

NSString *const MP42MetadataKeySortName = @"Sort Name";
NSString *const MP42MetadataKeySortArtist = @"Sort Artist";
NSString *const MP42MetadataKeySortAlbumArtist = @"Sort Album Artist";
NSString *const MP42MetadataKeySortAlbum = @"Sort Album";
NSString *const MP42MetadataKeySortComposer = @"Sort Composer";
NSString *const MP42MetadataKeySortTVShow = @"Sort TV Show";


typedef struct mediaKind_t {
    uint8_t stik;
    const char *english_name;
} mediaKind_t;

static const mediaKind_t mediaKind_strings[] = {
    {0, "Home Video"},
    {1, "Music"},
    {2, "Audiobook"},
    {6, "Music Video"},
    {9, "Movie"},
    {10, "TV Show"},
    {11, "Booklet"},
    {14, "Ringtone"},
    {21, "Podcast"},
    {23, "iTunes U"},
    {27, "Alert Tone"},
    {0, NULL},
};

typedef struct contentRating_t {
    uint8_t rtng;
    const char *english_name;
} contentRating_t;

static const contentRating_t contentRating_strings[] = {
    {0, "None"},
    {2, "Clean"},
    {4, "Explicit"},
    {0, NULL},
};

typedef struct genreType_t {
    uint8_t index;
    const char *short_name;
    const char *english_name;
} genreType_t;

static const genreType_t genreType_strings[] = {
    {1,   "blues",             "Blues" },
    {2,   "classicrock",       "Classic Rock" },
    {3,   "country",           "Country" },
    {4,   "dance",             "Dance" },
    {5,   "disco",             "Disco" },
    {6,   "funk",              "Funk" },
    {7,   "grunge",            "Grunge" },
    {8,   "hiphop",            "Hop-Hop" },
    {9,   "jazz",              "Jazz" },
    {10,  "metal",             "Metal" },
    {11,  "newage",            "New Age" },
    {12,  "oldies",            "Oldies" },
    {13,  "other",             "Other" },
    {14,  "pop",               "Pop" },
    {15,  "rand_b",            "R&B" },
    {16,  "rap",               "Rap" },
    {17,  "reggae",            "Reggae" },
    {18,  "rock",              "Rock" },
    {19,  "techno",            "Techno" },
    {20,  "industrial",        "Industrial" },
    {21,  "alternative",       "Alternative" },
    {22,  "ska",               "Ska" },
    {23,  "deathmetal",        "Death Metal" },
    {24,  "pranks",            "Pranks" },
    {25,  "soundtrack",        "Soundtrack" },
    {26,  "eurotechno",        "Euro-Techno" },
    {27,  "ambient",           "Ambient" },
    {28,  "triphop",           "Trip-Hop" },
    {29,  "vocal",             "Vocal" },
    {30,  "jazzfunk",          "Jazz+Funk" },
    {31,  "fusion",            "Fusion" },
    {32,  "trance",            "Trance" },
    {33,  "classical",         "Classical" },
    {34,  "instrumental",      "Instrumental" },
    {35,  "acid",              "Acid" },
    {36,  "house",             "House" },
    {37,  "game",              "Game" },
    {38,  "soundclip",         "Sound Clip" },
    {39,  "gospel",            "Gospel" },
    {40,  "noise",             "Noise" },
    {41,  "alternrock",        "AlternRock" },
    {42,  "bass",              "Bass" },
    {43,  "soul",              "Soul" },
    {44,  "punk",              "Punk" },
    {45,  "space",             "Space" },
    {46,  "meditative",        "Meditative" },
    {47,  "instrumentalpop",   "Instrumental Pop" },
    {48,  "instrumentalrock",  "Instrumental Rock" },
    {49,  "ethnic",            "Ethnic" },
    {50,  "gothic",            "Gothic" },
    {51,  "darkwave",          "Darkwave" },
    {52,  "technoindustrial",  "Techno-Industrial" },
    {53,  "electronic",        "Electronic" },
    {54,  "popfolk",           "Pop-Folk" },
    {55,  "eurodance",         "Eurodance" },
    {56,  "dream",             "Dream" },
    {57,  "southernrock",      "Southern Rock" },
    {58,  "comedy",            "Comedy" },
    {59,  "cult",              "Cult" },
    {60,  "gangsta",           "Gangsta" },
    {61,  "top40",             "Top 40" },
    {62,  "christianrap",      "Christian Rap" },
    {63,  "popfunk",           "Pop/Funk" },
    {64,  "jungle",            "Jungle" },
    {65,  "nativeamerican",    "Native American" },
    {66,  "cabaret",           "Cabaret" },
    {67,  "newwave",           "New Wave" },
    {68,  "psychedelic",       "Psychedelic" },
    {69,  "rave",              "Rave" },
    {70,  "showtunes",         "Showtunes" },
    {71,  "trailer",           "Trailer" },
    {72,  "lofi",              "Lo-Fi" },
    {73,  "tribal",            "Tribal" },
    {74,  "acidpunk",          "Acid Punk" },
    {75,  "acidjazz",          "Acid Jazz" },
    {76,  "polka",             "Polka" },
    {77,  "retro",             "Retro" },
    {78,  "musical",           "Musical" },
    {79,  "rockand_roll",      "Rock & Roll" },
    
    {80,  "hardrock",          "Hard Rock" },
    {81,  "folk",              "Folk" },
    {82,  "folkrock",          "Folk-Rock" },
    {83,  "nationalfolk",      "National Folk" },
    {84,  "swing",             "Swing" },
    {85,  "fastfusion",        "Fast Fusion" },
    {86,  "bebob",             "Bebob" },
    {87,  "latin",             "Latin" },
    {88,  "revival",           "Revival" },
    {89,  "celtic",            "Celtic" },
    {90,  "bluegrass",         "Bluegrass" },
    {91,  "avantgarde",        "Avantgarde" },
    {92,  "gothicrock",        "Gothic Rock" },
    {93,  "progressiverock",   "Progressive Rock" },
    {94,  "psychedelicrock",   "Psychedelic Rock" },
    {95,  "symphonicrock",     "SYMPHONIC_ROCK" },
    {96,  "slowrock",          "Slow Rock" },
    {97,  "bigband",           "Big Band" },
    {98,  "chorus",            "Chorus" },
    {99,  "easylistening",     "Easy Listening" },
    {100, "acoustic",          "Acoustic" },
    {101, "humour",            "Humor" },
    {102, "speech",            "Speech" },
    {103, "chanson",           "Chason" },
    {104, "opera",             "Opera" },
    {105, "chambermusic",      "Chamber Music" },
    {106, "sonata",            "Sonata" },
    {107, "symphony",          "Symphony" },
    {108, "bootybass",         "Booty Bass" },
    {109, "primus",            "Primus" },
    {110, "porngroove",        "Porn Groove" },
    {111, "satire",            "Satire" },
    {112, "slowjam",           "Slow Jam" },
    {113, "club",              "Club" },
    {114, "tango",             "Tango" },
    {115, "samba",             "Samba" },
    {116, "folklore",          "Folklore" },
    {117, "ballad",            "Ballad" },
    {118, "powerballad",       "Power Ballad" },
    {119, "rhythmicsoul",      "Rhythmic Soul" },
    {120, "freestyle",         "Freestyle" },
    {121, "duet",              "Duet" },
    {122, "punkrock",          "Punk Rock" },
    {123, "drumsolo",          "Drum Solo" },
    {124, "acapella",          "A capella" },
    {125, "eurohouse",         "Euro-House" },
    {126, "dancehall",         "Dance Hall" },
    {255, "none",              "none" },
    
    {0, "undefined" } // must be last
};


@implementation MP42Metadata {
@private
    NSString *presetName;
    NSMutableDictionary<NSString *, id> *tagsDict;

    NSMutableArray<MP42Image *> *artworks;

    NSString *ratingiTunesCode;

    uint8_t mediaKind;
    uint8_t contentRating;
    uint8_t hdVideo;
    uint8_t gapless;
    uint8_t podcast;

    BOOL isEdited;
    BOOL isArtworkEdited;
}

@synthesize presetName;

@synthesize isEdited;

@synthesize artworks;

@synthesize isArtworkEdited;

@synthesize mediaKind;
@synthesize contentRating;
@synthesize hdVideo;
@synthesize gapless;
@synthesize podcast;

@synthesize tagsDict;

- (instancetype)init
{
	if ((self = [super init]))
	{
        presetName = NSLocalizedString(@"Unnamed Set", nil);
        tagsDict = [[NSMutableDictionary alloc] init];
        artworks = [[NSMutableArray alloc] init];
        isEdited = NO;
        isArtworkEdited = NO;
	}

    return self;
}

- (instancetype)initWithFileHandle:(MP4FileHandle)fileHandle
{
	if ((self = [self init])) {
        [self readMetaDataFromFileHandle: fileHandle];
	}

    return self;
}

- (instancetype)initWithFileURL:(NSURL *)URL;
{
    if ((self = [self init])) {
        MP42XMLReader *xmlReader = [[MP42XMLReader alloc] initWithURL:URL error:NULL];
        [self mergeMetadata:[xmlReader mMetadata]];
	}
    
    return self;
}

#pragma mark - Supported metadata

+ (NSArray<NSString *> *) availableMetadata
{
    return @[
            MP42MetadataKeyName,
            MP42MetadataKeyTrackSubTitle,
            MP42MetadataKeyArtist,
            MP42MetadataKeyAlbumArtist,
            MP42MetadataKeyAlbum,
            MP42MetadataKeyGrouping,
			MP42MetadataKeyUserComment,
            MP42MetadataKeyUserGenre,
            MP42MetadataKeyReleaseDate,
            MP42MetadataKeyTrackNumber,
            MP42MetadataKeyDiscNumber,
            MP42MetadataKeyBeatsPerMin,
            MP42MetadataKeyTVShow,
            MP42MetadataKeyTVEpisodeNumber,
			MP42MetadataKeyTVNetwork,
            MP42MetadataKeyTVEpisodeID,
            MP42MetadataKeyTVSeason,
            MP42MetadataKeyDescription,
            MP42MetadataKeyLongDescription,
            MP42MetadataKeySeriesDescription,
            MP42MetadataKeyRating,
            MP42MetadataKeyRatingAnnotation,
            MP42MetadataKeyContentRating,
            MP42MetadataKeyStudio,
            MP42MetadataKeyCast,
            MP42MetadataKeyDirector,
            MP42MetadataKeyCodirector,
            MP42MetadataKeyProducer,
            MP42MetadataKeyExecProducer,
            MP42MetadataKeyScreenwriters,
            MP42MetadataKeyCopyright,
            MP42MetadataKeyEncodingTool,
            MP42MetadataKeyEncodedBy,
            MP42MetadataKeyKeywords,
            MP42MetadataKeyCategory,
            MP42MetadataKeyContentID,
            MP42MetadataKeyArtistID,
            MP42MetadataKeyPlaylistID,
            MP42MetadataKeyGenreID,
            MP42MetadataKeyComposerID,
            MP42MetadataKeyXID,
            MP42MetadataKeyAppleID,
            MP42MetadataKeyAccountKind,
            MP42MetadataKeyAccountCountry,
            MP42MetadataKeyPurchasedDate,
            MP42MetadataKeyOnlineExtras,
            MP42MetadataKeySongDescription,
            MP42MetadataKeyArtDirector,
            MP42MetadataKeyComposer,
            MP42MetadataKeyArranger,
            MP42MetadataKeyAuthor,
            MP42MetadataKeyLyrics,
            MP42MetadataKeyAcknowledgement,
            MP42MetadataKeyConductor,
            MP42MetadataKeyLinerNotes,
            MP42MetadataKeyRecordCompany,
            MP42MetadataKeyOriginalArtist,
            MP42MetadataKeyPhonogramRights,
            MP42MetadataKeySongProducer,
            MP42MetadataKeyPerformer,
            MP42MetadataKeyPublisher,
            MP42MetadataKeySoundEngineer,
            MP42MetadataKeySoloist,
            MP42MetadataKeyCredits,
            MP42MetadataKeyThanks,
            MP42MetadataKeyWorkName,
            MP42MetadataKeyMovementName,
            MP42MetadataKeyMovementNumber,
            MP42MetadataKeyMovementCount,
            MP42MetadataKeySortName,
            MP42MetadataKeySortArtist,
            MP42MetadataKeySortAlbumArtist,
            MP42MetadataKeySortAlbum,
            MP42MetadataKeySortComposer,
            MP42MetadataKeySortTVShow];
}

+ (NSArray<NSString *> *) writableMetadata
{
    return @[
            MP42MetadataKeyName,
            MP42MetadataKeyTrackSubTitle,
            MP42MetadataKeyArtist,
            MP42MetadataKeyAlbumArtist,
            MP42MetadataKeyAlbum,
            MP42MetadataKeyGrouping,
            MP42MetadataKeyComposer,
			MP42MetadataKeyUserComment,
            MP42MetadataKeyUserGenre,
            MP42MetadataKeyReleaseDate,
            MP42MetadataKeyTrackNumber,
            MP42MetadataKeyDiscNumber,
            MP42MetadataKeyBeatsPerMin,
            MP42MetadataKeyTVShow,
            MP42MetadataKeyTVEpisodeNumber,
			MP42MetadataKeyTVNetwork,
            MP42MetadataKeyTVEpisodeID,
            MP42MetadataKeyTVSeason,
            MP42MetadataKeySongDescription,
            MP42MetadataKeyDescription,
            MP42MetadataKeyLongDescription,
            MP42MetadataKeySeriesDescription,
            MP42MetadataKeyRating,
            MP42MetadataKeyRatingAnnotation,
            MP42MetadataKeyStudio,
            MP42MetadataKeyCast,
            MP42MetadataKeyDirector,
            MP42MetadataKeyCodirector,
            MP42MetadataKeyProducer,
            MP42MetadataKeyExecProducer,
            MP42MetadataKeyScreenwriters,
            MP42MetadataKeyLyrics,
            MP42MetadataKeyCopyright,
            MP42MetadataKeyEncodingTool,
            MP42MetadataKeyEncodedBy,
            MP42MetadataKeyKeywords,
            MP42MetadataKeyCategory,
            MP42MetadataKeyContentID,
            MP42MetadataKeyArtistID,
            MP42MetadataKeyPlaylistID,
            MP42MetadataKeyGenreID,
            MP42MetadataKeyComposerID,
            MP42MetadataKeyXID,
            MP42MetadataKeyAppleID,
            MP42MetadataKeyAccountKind,
            MP42MetadataKeyAccountCountry,
            MP42MetadataKeyPurchasedDate,
            MP42MetadataKeyOnlineExtras,
            MP42MetadataKeyArtDirector,
            MP42MetadataKeyArranger,
            MP42MetadataKeyAuthor,
            MP42MetadataKeyAcknowledgement,
            MP42MetadataKeyConductor,
            MP42MetadataKeyLinerNotes,
            MP42MetadataKeyRecordCompany,
            MP42MetadataKeyOriginalArtist,
            MP42MetadataKeyPhonogramRights,
            MP42MetadataKeySongProducer,
            MP42MetadataKeyPerformer,
            MP42MetadataKeyPublisher,
            MP42MetadataKeySoundEngineer,
            MP42MetadataKeySoloist,
            MP42MetadataKeyCredits,
            MP42MetadataKeyThanks,
            MP42MetadataKeyWorkName,
            MP42MetadataKeyMovementName,
            MP42MetadataKeyMovementNumber,
            MP42MetadataKeyMovementCount,
            MP42MetadataKeySortName,
            MP42MetadataKeySortArtist,
            MP42MetadataKeySortAlbumArtist,
            MP42MetadataKeySortAlbum,
            MP42MetadataKeySortComposer,
            MP42MetadataKeySortTVShow];
}

#pragma mark - Array conversion

/**
 *  Converts an array of NSDictionary to a single string
 *  with the components separated by ", ".
 *
 *  @param array the array of strings.
 *
 *  @return a concatenated string.
 */
- (NSString *)stringFromArray:(NSArray<NSDictionary *> *)array key:(id)key {
    NSMutableString *result = [NSMutableString string];

    for (NSDictionary *name in array) {

        if (result.length) {
            [result appendString:@", "];
        }

        [result appendString:name[key]];
    }

    return [result copy];
}

/**
 *  Splits a string into components separated by ",".
 *
 *  @param string to separate
 *
 *  @return an array of separated components.
 */
- (NSArray<NSDictionary *> *)dictArrayFromString:(NSString *)string key:(id)key {
    NSString *splitElements  = @",\\s*+";
    NSArray *stringArray = [string MP42_componentsSeparatedByRegex:splitElements];

    NSMutableArray *arrayElements = [NSMutableArray array];

    for (NSString *name in stringArray) {
        [arrayElements addObject: @{ key: name}];
    }

    return arrayElements;
}

#pragma mark - Metadata conversion helpers

/**
 *  Trys to create a NSString using various encoding.
 *
 *  @param cString the input string
 *
 *  @return a instances of NSString.
 */
- (NSString *)stringFromMetadata:(const char *)cString {
    NSString *string = nil;

    if ((string = [NSString stringWithCString:cString encoding: NSUTF8StringEncoding])) {
        return string;
    }

    if ((string = [NSString stringWithCString:cString encoding: NSASCIIStringEncoding])) {
        return string;
    }

    if ((string = [NSString stringWithCString:cString encoding: NSUTF16StringEncoding])) {
        return string;
    }

    return @"";
}

- (BOOL)setMediaKindFromString:(NSString *)mediaKindString {
    for (mediaKind_t * mediaKindList = (mediaKind_t*) mediaKind_strings; mediaKindList->english_name; mediaKindList++) {
        if ([mediaKindString isEqualToString:@(mediaKindList->english_name)]) {
            mediaKind = mediaKindList->stik;
            return YES;      
        }
    }
    return NO;
}

- (BOOL)setContentRatingFromString:(NSString *)contentRatingString {
    for (contentRating_t *contentRatingList = (contentRating_t*) contentRating_strings; contentRatingList->english_name; contentRatingList++) {
        if ([contentRatingString isEqualToString:@(contentRatingList->english_name)]) {
            contentRating = contentRatingList->rtng;
            return YES;      
        }
    }
    return NO;
}

- (BOOL)setArtworkFromFilePath:(NSString *)imageFilePath {
    if (imageFilePath != nil && imageFilePath.length) {
        NSImage *artworkImage = nil;
        artworkImage = [[NSImage alloc] initByReferencingFile:imageFilePath];

        if (artworkImage.isValid) {
            MP42Image *artwork = [[MP42Image alloc] initWithImage:artworkImage];
            [artworks addObject:artwork];
            isEdited =YES;
            isArtworkEdited = YES;
            return YES;
        }
        else {
            return NO;
        }
    } else {
        artworks = nil;
        isEdited =YES;
        isArtworkEdited = YES;
        return YES;
    }
}

- (NSString *)genreFromIndex:(NSInteger)index {
    if ((index >= 0 && index < 127) || index == 255) {
        genreType_t *genre = (genreType_t*) genreType_strings;
        genre += index - 1;
        return [NSString stringWithUTF8String:genre->english_name];
    }
    else return nil;
}

- (NSInteger)genreIndexFromString:(NSString *)genreString {
    NSInteger genreIndex = 0;
    genreType_t *genreList;
    NSInteger k = 0;
    for ( genreList = (genreType_t*) genreType_strings; genreList->english_name; genreList++, k++ ) {
        if ([genreString isEqualToString:[NSString stringWithUTF8String:genreList->english_name]])
            genreIndex = k + 1;
    }
    return genreIndex;
}

- (NSArray<NSString *> *)availableGenres {
    return @[@"Animation", @"Classic TV", @"Comedy", @"Drama",
            @"Fitness & Workout", @"Kids", @"Non-Fiction", @"Reality TV", @"Sci-Fi & Fantasy",
            @"Sports"];
}

#pragma mark - Mutators

- (void)mergeMetadata:(MP42Metadata *)metadata {
    NSString *tagValue;

    for (NSString *key in [MP42Metadata writableMetadata]) {
        if ((tagValue = metadata.tagsDict[key])) {
            [tagsDict setObject:tagValue forKey:key];
        }
    }

    if (metadata.artworks.count) {
        [artworks removeAllObjects];
    }

    for (MP42Image *artwork in metadata.artworks) {
        isArtworkEdited = YES;
        [artworks addObject:artwork];
    }

    mediaKind = metadata.mediaKind;
    contentRating = metadata.contentRating;
    gapless = metadata.gapless;
    hdVideo = metadata.hdVideo;

    isEdited = YES;
}

- (void)removeTagForKey:(NSString *)aKey {
    [tagsDict removeObjectForKey:aKey];
    isEdited = YES;
}

- (BOOL)setTag:(id)value forKey:(NSString *)key {
    BOOL noErr = YES;
    NSString *regexPositive = @"YES|Yes|yes|1|2";

    if ([value isKindOfClass:[NSNull class]]) {
        [tagsDict removeObjectForKey:key];
        return YES;
    }

    if ([key isEqualToString:@"HD Video"]) {
        if ([value isKindOfClass:[NSNumber class]]) {
            hdVideo = [value integerValue];
        } else if ([value isKindOfClass:[NSString class]] && [value length] > 0 && [value MP42_isMatchedByRegex:regexPositive]) {
            hdVideo = [value integerValue];
        } else {
            hdVideo = 0;
        }
        isEdited = YES;

    } else if ([key isEqualToString:MP42MetadataKeyUserGenre]) {
        if ([value isKindOfClass:[NSNumber class]]) {
            [tagsDict setValue:[self genreFromIndex:[value integerValue]] forKey:key];
            isEdited = YES;
        } else if ([value isKindOfClass:[NSData class]]) {
            if ([value length] >= 2) {
                uint8_t* bytes = (uint8_t*)malloc([value length]);
                memcpy(bytes, [value bytes], [value length]);
                int genre = ((bytes[0]) <<  8)
                            | ((bytes[1])    );

                free(bytes);
                [tagsDict setValue:[self genreFromIndex:genre] forKey:key];
                isEdited = YES;
            }
        } else if ([value isKindOfClass:[NSString class]]) {
            [tagsDict setValue:value forKey:key];
            isEdited = YES;
        } else {
            noErr = NO;
            NSAssert(YES, @"Invalid genre input");
        }

    } else if ([key isEqualToString:@"Gapless"]) {
        if ([value isKindOfClass:[NSNumber class]]) {
            gapless = [value integerValue];
            isEdited = YES;
        }
        else if ([value isKindOfClass:[NSString class]] && [value length] > 0 && [value MP42_isMatchedByRegex:regexPositive]) {
            gapless = 1;
            isEdited = YES;
        } else {
            gapless = 0;
            isEdited = YES;
        }

    } else if ([key isEqualToString:MP42MetadataKeyTrackNumber]) {
        isEdited = YES;
        if ([value isKindOfClass:[NSData class]]) {
            uint8_t* bytes = (uint8_t*)malloc([value length]);
            memcpy(bytes, [value bytes], [value length]);
            int index = ((bytes[2]) <<  8)
                      | ((bytes[3])      );
            int total = ((bytes[4]) <<  8)
                      | ((bytes[5])      );

            free(bytes);
            NSString *trackN = [NSString stringWithFormat:@"%d/%d", index, total];
            [tagsDict setValue:trackN forKey:key];
        } else if ([value isKindOfClass:[NSString class]]) {
            [tagsDict setValue:value forKey:key];
        } else {
            noErr = NO;
            NSAssert(YES, @"Invalid input");
        }

    } else if ([key isEqualToString:MP42MetadataKeyDiscNumber]) {
        isEdited = YES;
        if ([value isKindOfClass:[NSData class]]) {
            uint8_t* bytes = (uint8_t*)malloc([value length]);
            memcpy(bytes, [value bytes], [value length]);
            int index = ((bytes[2]) <<  8)
            | ((bytes[3])      );
            int total = ((bytes[4]) <<  8)
            | ((bytes[5])      );

            free(bytes);
            NSString *diskN = [NSString stringWithFormat:@"%d/%d", index, total];
            [tagsDict setValue:diskN forKey:key];
        } else if ([value isKindOfClass:[NSString class]]) {
            [tagsDict setValue:value forKey:key];
        }
    } else if ([key isEqualToString:MP42MetadataKeyRating]) {
        isEdited = YES;
        if ([value isKindOfClass:[NSString class]]) {
            NSNumber *index = @([[MP42Ratings defaultManager] ratingIndexForiTunesCode:value]);
            [tagsDict setValue:index forKey:key];
        }
        else {
            [tagsDict setValue:value forKey:key];
        }

    } else if ([key isEqualToString:MP42MetadataKeyContentRating]) {
        isEdited = YES;
        if ([value isKindOfClass:[NSNumber class]]) {
            contentRating = [value integerValue];
        } else if ([value isKindOfClass:[NSString class]]) {
            [self setContentRatingFromString:value];
        } else {
            noErr = NO;
            NSAssert(YES, @"Invalid input");
        }

    } else if ([key isEqualToString:@"Media Kind"]) {
        isEdited = YES;
        if ([value isKindOfClass:[NSNumber class]]) {
            mediaKind = [value integerValue];
        } else if ([value isKindOfClass:[NSString class]]) {
            [self setMediaKindFromString:value];
        } else {
            noErr = NO;
            NSAssert(YES, @"Invalid input");
        }

    } else if ([key isEqualToString:@"Artwork"]) {
        [self setArtworkFromFilePath:value];

	} else if (![tagsDict[key] isEqualTo:value]) {
        [tagsDict setValue:value forKey:key];
        isEdited = YES;

    } else {
        noErr = NO;
    }

    return noErr;
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return [self.tagsDict objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    if (obj == nil) {
        [self removeTagForKey:key];
    }
    else {
        [self setTag:obj forKey:key];
    }
}

#pragma mark - MP42Foundation/mp4v2 read/write mapping

- (void)readMetaDataFromFileHandle:(MP4FileHandle)sourceHandle {
    const MP4Tags *tags = MP4TagsAlloc();
    MP4TagsFetch (tags, sourceHandle);

    if (tags->name)
        [tagsDict setObject:[self stringFromMetadata:tags->name]
                     forKey:MP42MetadataKeyName];

    if (tags->artist)
        [tagsDict setObject:[self stringFromMetadata:tags->artist]
                     forKey:MP42MetadataKeyArtist];

    if (tags->albumArtist)
        [tagsDict setObject:[self stringFromMetadata:tags->albumArtist]
                     forKey:MP42MetadataKeyAlbumArtist];

    if (tags->album)
        [tagsDict setObject:[self stringFromMetadata:tags->album]
                     forKey:MP42MetadataKeyAlbum];

    if (tags->grouping)
        [tagsDict setObject:[self stringFromMetadata:tags->grouping]
                     forKey:MP42MetadataKeyGrouping];

    if (tags->composer)
        [tagsDict setObject:[self stringFromMetadata:tags->composer]
                     forKey:MP42MetadataKeyComposer];

    if (tags->comments)
        [tagsDict setObject:[self stringFromMetadata:tags->comments]
                     forKey:MP42MetadataKeyUserComment];

    if (tags->genre)
        [tagsDict setObject:[self stringFromMetadata:tags->genre]
                     forKey:MP42MetadataKeyUserGenre];
    
    if (tags->genreType && !tags->genre) {
        NSString *genre = [self genreFromIndex:*tags->genreType];
        if (genre) {
            [tagsDict setObject:genre
                         forKey:MP42MetadataKeyUserGenre];
        }
    }

    if (tags->releaseDate)
        [tagsDict setObject:[self stringFromMetadata:tags->releaseDate]
                     forKey:MP42MetadataKeyReleaseDate];

    if (tags->track)
        [tagsDict setObject:[NSString stringWithFormat:@"%d/%d", tags->track->index, tags->track->total]
                     forKey:MP42MetadataKeyTrackNumber];
    
    if (tags->disk)
        [tagsDict setObject:[NSString stringWithFormat:@"%d/%d", tags->disk->index, tags->disk->total]
                     forKey:MP42MetadataKeyDiscNumber];

    if (tags->tempo)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->tempo]
                     forKey:MP42MetadataKeyBeatsPerMin];

    if (tags->trackSubTitle)
        [tagsDict setObject:[self stringFromMetadata:tags->trackSubTitle]
                     forKey:MP42MetadataKeyTrackSubTitle];

    if (tags->songDescription)
        [tagsDict setObject:[self stringFromMetadata:tags->songDescription]
                     forKey:MP42MetadataKeySongDescription];

    if (tags->artDirector)
        [tagsDict setObject:[self stringFromMetadata:tags->artDirector]
                     forKey:MP42MetadataKeyArtDirector];

    if (tags->arranger)
        [tagsDict setObject:[self stringFromMetadata:tags->arranger]
                     forKey:MP42MetadataKeyArranger];

    if (tags->lyricist)
        [tagsDict setObject:[self stringFromMetadata:tags->lyricist]
                     forKey:MP42MetadataKeyAuthor];

    if (tags->acknowledgement)
        [tagsDict setObject:[self stringFromMetadata:tags->acknowledgement]
                     forKey:MP42MetadataKeyAcknowledgement];

    if (tags->conductor)
        [tagsDict setObject:[self stringFromMetadata:tags->conductor]
                     forKey:MP42MetadataKeyConductor];

    if (tags->workName)
        [tagsDict setObject:[self stringFromMetadata:tags->workName]
                     forKey:MP42MetadataKeyWorkName];

    if (tags->movementName)
        [tagsDict setObject:[self stringFromMetadata:tags->movementName]
                     forKey:MP42MetadataKeyMovementName];

    if (tags->movementCount)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->movementCount]
                     forKey:MP42MetadataKeyMovementCount];

    if (tags->movementNumber)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->movementNumber]
                     forKey:MP42MetadataKeyMovementNumber];

    if (tags->showWorkAndMovement)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->showWorkAndMovement]
                     forKey:MP42MetadataKeyShowWorkAndMovement];

    if (tags->linearNotes)
        [tagsDict setObject:[self stringFromMetadata:tags->linearNotes]
                     forKey:MP42MetadataKeyLinerNotes];

    if (tags->recordCompany)
        [tagsDict setObject:[self stringFromMetadata:tags->recordCompany]
                     forKey:MP42MetadataKeyRecordCompany];

    if (tags->originalArtist)
        [tagsDict setObject:[self stringFromMetadata:tags->originalArtist]
                     forKey:MP42MetadataKeyOriginalArtist];

    if (tags->phonogramRights)
        [tagsDict setObject:[self stringFromMetadata:tags->phonogramRights]
                     forKey:MP42MetadataKeyPhonogramRights];
    
    if (tags->producer)
        [tagsDict setObject:[self stringFromMetadata:tags->producer]
                     forKey:MP42MetadataKeySongProducer];

    if (tags->performer)
        [tagsDict setObject:[self stringFromMetadata:tags->performer]
                     forKey:MP42MetadataKeyPerformer];

    if (tags->publisher)
        [tagsDict setObject:[self stringFromMetadata:tags->publisher]
                     forKey:MP42MetadataKeyPublisher];

    if (tags->soundEngineer)
        [tagsDict setObject:[self stringFromMetadata:tags->soundEngineer]
                     forKey:MP42MetadataKeySoundEngineer];

    if (tags->soloist)
        [tagsDict setObject:[self stringFromMetadata:tags->soloist]
                     forKey:MP42MetadataKeySoloist];

    if (tags->credits)
        [tagsDict setObject:[self stringFromMetadata:tags->credits]
                     forKey:MP42MetadataKeyCredits];

    if (tags->thanks)
        [tagsDict setObject:[self stringFromMetadata:tags->thanks]
                     forKey:MP42MetadataKeyThanks];

    if (tags->onlineExtras)
        [tagsDict setObject:[self stringFromMetadata:tags->onlineExtras]
                     forKey:MP42MetadataKeyOnlineExtras];
    
    if (tags->executiveProducer)
        [tagsDict setObject:[self stringFromMetadata:tags->executiveProducer]
                     forKey:MP42MetadataKeyExecProducer];

    if (tags->tvShow)
        [tagsDict setObject:[self stringFromMetadata:tags->tvShow]
                     forKey:MP42MetadataKeyTVShow];

    if (tags->tvEpisodeID)
        [tagsDict setObject:[self stringFromMetadata:tags->tvEpisodeID]
                     forKey:MP42MetadataKeyTVEpisodeID];

    if (tags->tvSeason)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->tvSeason]
                     forKey:MP42MetadataKeyTVSeason];

    if (tags->tvEpisode)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->tvEpisode]
                     forKey:MP42MetadataKeyTVEpisodeNumber];

    if (tags->tvNetwork)
        [tagsDict setObject:[self stringFromMetadata:tags->tvNetwork]
                     forKey:MP42MetadataKeyTVNetwork];

    if (tags->description)
        [tagsDict setObject:[self stringFromMetadata:tags->description]
                     forKey:MP42MetadataKeyDescription];

    if (tags->longDescription)
        [tagsDict setObject:[self stringFromMetadata:tags->longDescription]
                     forKey:MP42MetadataKeyLongDescription];

    if (tags->seriesDescription)
        [tagsDict setObject:[self stringFromMetadata:tags->seriesDescription]
                     forKey:MP42MetadataKeySeriesDescription];

    if (tags->lyrics)
        [tagsDict setObject:[self stringFromMetadata:tags->lyrics]
                     forKey:MP42MetadataKeyLyrics];

    if (tags->copyright)
        [tagsDict setObject:[self stringFromMetadata:tags->copyright]
                     forKey:MP42MetadataKeyCopyright];

    if (tags->encodingTool)
        [tagsDict setObject:[self stringFromMetadata:tags->encodingTool]
                     forKey:MP42MetadataKeyEncodingTool];

    if (tags->encodedBy)
        [tagsDict setObject:[self stringFromMetadata:tags->encodedBy]
                     forKey:MP42MetadataKeyEncodedBy];

    if (tags->hdVideo)
        hdVideo = *tags->hdVideo;

    if (tags->mediaType)
        mediaKind = *tags->mediaType;
    
    if (tags->contentRating)
        contentRating = *tags->contentRating;
    
    if (tags->gapless)
        gapless = *tags->gapless;

    if (tags->purchaseDate)
        [tagsDict setObject:[self stringFromMetadata:tags->purchaseDate]
                     forKey:MP42MetadataKeyPurchasedDate];

    if (tags->iTunesAccount)
        [tagsDict setObject:[self stringFromMetadata:tags->iTunesAccount]
                     forKey:MP42MetadataKeyAppleID];

    if( tags->iTunesAccountType )
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->iTunesAccountType]
                     forKey:MP42MetadataKeyAccountKind];

    if (tags->iTunesCountry)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->iTunesCountry]
                     forKey:MP42MetadataKeyAccountCountry];

    if (tags->contentID)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->contentID]
                     forKey:MP42MetadataKeyContentID];

    if (tags->artistID)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->artistID]
                     forKey:MP42MetadataKeyArtistID];

    if (tags->playlistID)
        [tagsDict setObject:[NSString stringWithFormat:@"%lld", *tags->playlistID]
                     forKey:MP42MetadataKeyPlaylistID];

    if (tags->genreID)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->genreID]
                     forKey:MP42MetadataKeyGenreID];

    if (tags->composerID)
        [tagsDict setObject:[NSString stringWithFormat:@"%d", *tags->composerID]
                     forKey:MP42MetadataKeyComposerID];

    if (tags->xid)
        [tagsDict setObject:[self stringFromMetadata:tags->xid]
                     forKey:MP42MetadataKeyXID];    

    if (tags->sortName)
        [tagsDict setObject:[self stringFromMetadata:tags->sortName]
                     forKey:MP42MetadataKeySortName];

    if (tags->sortArtist)
        [tagsDict setObject:[self stringFromMetadata:tags->sortArtist]
                     forKey:MP42MetadataKeySortArtist];

    if (tags->sortAlbumArtist)
        [tagsDict setObject:[self stringFromMetadata:tags->sortAlbumArtist]
                     forKey:MP42MetadataKeySortAlbumArtist];

    if (tags->sortAlbum)
        [tagsDict setObject:[self stringFromMetadata:tags->sortAlbum]
                     forKey:MP42MetadataKeySortAlbum];

    if (tags->sortComposer)
        [tagsDict setObject:[self stringFromMetadata:tags->sortComposer]
                     forKey:MP42MetadataKeySortComposer];

    if (tags->sortTVShow)
        [tagsDict setObject:[self stringFromMetadata:tags->sortTVShow]
                     forKey:MP42MetadataKeySortTVShow];

    if (tags->podcast)
        podcast = *tags->podcast;

    if (tags->keywords)
        [tagsDict setObject:[self stringFromMetadata:tags->keywords]
                     forKey:MP42MetadataKeyKeywords];

    if (tags->category)
        [tagsDict setObject:[self stringFromMetadata:tags->category]
                     forKey:MP42MetadataKeyCategory];

    if (tags->artwork) {
        for (uint32_t i = 0; i < tags->artworkCount; i++) {
            MP42Image *artwork = [[MP42Image alloc] initWithBytes:tags->artwork[i].data length:tags->artwork[i].size type:tags->artwork[i].type];
            [artworks addObject:artwork];
        }
    }

    MP4TagsFree(tags);

    // read the remaining iTMF items
    MP4ItmfItemList *list = MP4ItmfGetItemsByMeaning(sourceHandle, "com.apple.iTunes", "iTunEXTC");
    if (list) {

        for (uint32_t i = 0; i < list->size; i++) {

            MP4ItmfItem *item = &list->elements[i];

            for (uint32_t j = 0; j < item->dataList.size; j++) {

                MP4ItmfData *data = &item->dataList.elements[j];

                NSString *ratingString = [[NSString alloc] initWithBytes:data->value length: data->valueSize encoding:NSUTF8StringEncoding];

                NSString *splitElements  = @"\\|";
                NSArray *ratingItems = [ratingString MP42_componentsSeparatedByRegex:splitElements];


                if (ratingItems.count > 2) {
                    ratingiTunesCode = [NSString stringWithFormat:@"%@|%@|%@|", ratingItems[0], ratingItems[1], ratingItems[2]];
                }
                else {
                    ratingiTunesCode = nil;
                }

                if (ratingiTunesCode) {
                    tagsDict[MP42MetadataKeyRating] = [NSNumber numberWithUnsignedInteger:[[MP42Ratings defaultManager] ratingIndexForiTunesCode:ratingiTunesCode]];
                }
                else {
                    tagsDict[MP42MetadataKeyRating] = @(0);
                }

                if (ratingItems.count >= 4) {
                    tagsDict[MP42MetadataKeyRatingAnnotation] = ratingItems[3];
                }
            }
        }

        MP4ItmfItemListFree(list);
    }

    list = MP4ItmfGetItemsByMeaning(sourceHandle, "com.apple.iTunes", "iTunMOVI");
    if (list) {

        for (uint32_t i = 0; i < list->size; i++) {

            MP4ItmfItem *item = &list->elements[i];

            for (uint32_t j = 0; j < item->dataList.size; j++) {

                MP4ItmfData *data = &item->dataList.elements[j];
                NSData *xmlData = [NSData dataWithBytes:data->value length:data->valueSize];
                NSDictionary *dma = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:xmlData
                                                                                              options:NSPropertyListImmutable
                                                                                               format:nil error:NULL];

                NSString *tag = nil;

                if ([tag = [self stringFromArray:dma[@"cast"] key:@"name"] length]) {
                    tagsDict[MP42MetadataKeyCast] = tag;
                }

                if ([tag = [self stringFromArray:dma[@"directors"] key:@"name"] length]) {
                    tagsDict[MP42MetadataKeyDirector] = tag;
                }

                if ([tag = [self stringFromArray:dma[@"codirectors"] key:@"name"] length]) {
                    tagsDict[MP42MetadataKeyCodirector] = tag;
                }

                if ([tag = [self stringFromArray:dma[@"producers"] key:@"name"] length]) {
                    tagsDict[MP42MetadataKeyProducer] = tag;
                }

                if ([tag = [self stringFromArray:dma[@"screenwriters"] key:@"name"] length]) {
                    tagsDict[MP42MetadataKeyScreenwriters] = tag;
                }

                if ([tag = dma[@"studio"] length]) {
                    tagsDict[MP42MetadataKeyStudio] = tag;
                }
            }
        }

        MP4ItmfItemListFree(list);
    }
}

- (BOOL)writeMetadataWithFileHandle:(MP4FileHandle)fileHandle
{
    NSParameterAssert(fileHandle);

    const MP4Tags *tags = MP4TagsAlloc();
    MP4TagsFetch(tags, fileHandle);

    MP4TagsSetName          (tags, [tagsDict[MP42MetadataKeyName] UTF8String]);
    MP4TagsSetArtist        (tags, [tagsDict[MP42MetadataKeyArtist] UTF8String]);
    MP4TagsSetAlbumArtist   (tags, [tagsDict[MP42MetadataKeyAlbumArtist] UTF8String]);
    MP4TagsSetAlbum         (tags, [tagsDict[MP42MetadataKeyAlbum] UTF8String]);
    MP4TagsSetGrouping      (tags, [tagsDict[MP42MetadataKeyGrouping] UTF8String]);
    MP4TagsSetComposer      (tags, [tagsDict[MP42MetadataKeyComposer] UTF8String]);
    MP4TagsSetComments      (tags, [tagsDict[MP42MetadataKeyUserComment] UTF8String]);

    uint16_t genreType = [self genreIndexFromString:tagsDict[MP42MetadataKeyUserGenre]];
    if (genreType) {
        MP4TagsSetGenre(tags, NULL);
        MP4TagsSetGenreType(tags, &genreType);
    }
    else {
        MP4TagsSetGenreType(tags, NULL);
        MP4TagsSetGenre(tags, [tagsDict[MP42MetadataKeyUserGenre] UTF8String]);
    }

    MP4TagsSetReleaseDate(tags, [tagsDict[MP42MetadataKeyReleaseDate] UTF8String]);

    if (tagsDict[MP42MetadataKeyTrackNumber]) {
        MP4TagTrack dtrack; int trackNum = 0, totalTrackNum = 0;
        char separator[3];

        sscanf([tagsDict[MP42MetadataKeyTrackNumber] UTF8String],"%u%[/- ]%u", &trackNum, separator, &totalTrackNum);
        dtrack.index = trackNum;
        dtrack.total = totalTrackNum;

        MP4TagsSetTrack(tags, &dtrack);
    }
    else {
        MP4TagsSetTrack(tags, NULL);
    }
    
    if (tagsDict[MP42MetadataKeyDiscNumber]) {
        MP4TagDisk ddisk; int diskNum = 0, totalDiskNum = 0;
        char separator[3];

        sscanf([tagsDict[MP42MetadataKeyDiscNumber] UTF8String],"%u%[/- ]%u", &diskNum, separator, &totalDiskNum);
        ddisk.index = diskNum;
        ddisk.total = totalDiskNum;

        MP4TagsSetDisk(tags, &ddisk);
    }
    else {
        MP4TagsSetDisk(tags, NULL);
    }
    
    if (tagsDict[MP42MetadataKeyBeatsPerMin]) {
        const uint16_t i = [tagsDict[MP42MetadataKeyBeatsPerMin] integerValue];
        MP4TagsSetTempo(tags, &i);
    }
    else {
        MP4TagsSetTempo(tags, NULL);
    }

    MP4TagsSetTrackSubTitle    (tags, [tagsDict[MP42MetadataKeyTrackSubTitle] UTF8String]);
    MP4TagsSetSongDescription  (tags, [tagsDict[MP42MetadataKeySongDescription] UTF8String]);
    MP4TagsSetArtDirector      (tags, [tagsDict[MP42MetadataKeyArtDirector] UTF8String]);
    MP4TagsSetArranger         (tags, [tagsDict[MP42MetadataKeyArranger] UTF8String]);
    MP4TagsSetLyricist         (tags, [tagsDict[MP42MetadataKeyAuthor] UTF8String]);
    MP4TagsSetAcknowledgement  (tags, [tagsDict[MP42MetadataKeyAcknowledgement] UTF8String]);
    MP4TagsSetConductor        (tags, [tagsDict[MP42MetadataKeyConductor] UTF8String]);
    MP4TagsSetLinearNotes      (tags, [tagsDict[MP42MetadataKeyLinerNotes] UTF8String]);
    MP4TagsSetRecordCompany    (tags, [tagsDict[MP42MetadataKeyRecordCompany] UTF8String]);
    MP4TagsSetOriginalArtist   (tags, [tagsDict[MP42MetadataKeyOriginalArtist] UTF8String]);
    MP4TagsSetPhonogramRights  (tags, [tagsDict[MP42MetadataKeyPhonogramRights] UTF8String]);
    MP4TagsSetProducer         (tags, [tagsDict[MP42MetadataKeySongProducer] UTF8String]);
    MP4TagsSetPerformer        (tags, [tagsDict[MP42MetadataKeyPerformer] UTF8String]);
    MP4TagsSetPublisher        (tags, [tagsDict[MP42MetadataKeyPublisher] UTF8String]);
    MP4TagsSetSoundEngineer    (tags, [tagsDict[MP42MetadataKeySoundEngineer] UTF8String]);
    MP4TagsSetSoloist          (tags, [tagsDict[MP42MetadataKeySoloist] UTF8String]);
    MP4TagsSetCredits          (tags, [tagsDict[MP42MetadataKeyCredits] UTF8String]);
    MP4TagsSetThanks           (tags, [tagsDict[MP42MetadataKeyThanks] UTF8String]);
    MP4TagsSetOnlineExtras     (tags, [tagsDict[MP42MetadataKeyOnlineExtras] UTF8String]);
    MP4TagsSetExecutiveProducer(tags, [tagsDict[MP42MetadataKeyExecProducer] UTF8String]);

    // Movements keys

    if ([tagsDict[MP42MetadataKeyMovementName] length]) {
        const uint8_t value = 1;
        MP4TagsSetShowWorkAndMovement(tags, &value);
    }
    else {
        MP4TagsSetShowWorkAndMovement(tags, NULL);
    }

    MP4TagsSetWorkName(tags, [tagsDict[MP42MetadataKeyWorkName] UTF8String]);
    MP4TagsSetMovementName (tags, [tagsDict[MP42MetadataKeyMovementName] UTF8String]);

    if (tagsDict[MP42MetadataKeyMovementNumber]) {
        const uint16_t value = [tagsDict[MP42MetadataKeyMovementNumber] intValue];
        MP4TagsSetMovementNumber(tags, &value);
    }
    else {
        MP4TagsSetMovementNumber(tags, NULL);
    }

    if (tagsDict[MP42MetadataKeyMovementCount]) {
        const uint16_t value = [tagsDict[MP42MetadataKeyMovementCount] intValue];
        MP4TagsSetMovementCount(tags, &value);
    }
    else {
        MP4TagsSetMovementCount(tags, NULL);
    }

    // TV Show Specifics

    MP4TagsSetTVShow           (tags, [tagsDict[MP42MetadataKeyTVShow] UTF8String]);
    MP4TagsSetTVNetwork        (tags, [tagsDict[MP42MetadataKeyTVNetwork] UTF8String]);
    MP4TagsSetTVEpisodeID      (tags, [tagsDict[MP42MetadataKeyTVEpisodeID] UTF8String]);

    if (tagsDict[MP42MetadataKeyTVSeason]) {
        const uint32_t value = [tagsDict[MP42MetadataKeyTVSeason] intValue];
        MP4TagsSetTVSeason(tags, &value);
    }
    else {
        MP4TagsSetTVSeason(tags, NULL);
    }

    if (tagsDict[MP42MetadataKeyTVEpisodeNumber]) {
        const uint32_t i = [tagsDict[MP42MetadataKeyTVEpisodeNumber] intValue];
        MP4TagsSetTVEpisode(tags, &i);
    }
    else {
        MP4TagsSetTVEpisode(tags, NULL);
    }

    MP4TagsSetDescription       (tags, [tagsDict[MP42MetadataKeyDescription] UTF8String]);
    MP4TagsSetLongDescription   (tags, [tagsDict[MP42MetadataKeyLongDescription] UTF8String]);
    MP4TagsSetSeriesDescription (tags, [tagsDict[MP42MetadataKeySeriesDescription] UTF8String]);
    MP4TagsSetLyrics            (tags, [tagsDict[MP42MetadataKeyLyrics] UTF8String]);
    MP4TagsSetCopyright         (tags, [tagsDict[MP42MetadataKeyCopyright] UTF8String]);
    MP4TagsSetEncodingTool      (tags, [tagsDict[MP42MetadataKeyEncodingTool] UTF8String]);
    MP4TagsSetEncodedBy         (tags, [tagsDict[MP42MetadataKeyEncodedBy] UTF8String]);
    MP4TagsSetPurchaseDate      (tags, [tagsDict[MP42MetadataKeyPurchasedDate] UTF8String]);
    MP4TagsSetITunesAccount     (tags, [tagsDict[MP42MetadataKeyAppleID] UTF8String]);

    if (mediaKind != 0) {
        MP4TagsSetMediaType(tags, &mediaKind);
    }
    else {
        MP4TagsSetMediaType(tags, NULL);
    }

    if (mediaKind == 21) {
        const uint8_t n = 1;
        MP4TagsSetPodcast(tags, &n);
    }
    else {
        MP4TagsSetPodcast(tags, NULL);
    }

    if (mediaKind == 23) {
        const uint8_t n = 1;
        MP4TagsSetITunesU(tags, &n);
    }
    else {
        MP4TagsSetITunesU(tags, NULL);
    }

    if (hdVideo) {
        MP4TagsSetHDVideo(tags, &hdVideo);
    }
    else {
        MP4TagsSetHDVideo(tags, NULL);
    }
    
    if (gapless) {
        MP4TagsSetGapless(tags, &gapless);
    }
    else {
        MP4TagsSetGapless(tags, NULL);
    }
    
    if (podcast) {
        MP4TagsSetPodcast(tags, &podcast);
    }
    else {
        MP4TagsSetPodcast(tags, NULL);
    }

    MP4TagsSetKeywords(tags, [tagsDict[MP42MetadataKeyKeywords] UTF8String]);
    MP4TagsSetCategory(tags, [tagsDict[MP42MetadataKeyCategory] UTF8String]);

    MP4TagsSetContentRating(tags, &contentRating);

    if (tagsDict[MP42MetadataKeyAccountCountry] && [tagsDict[MP42MetadataKeyAccountCountry] length]) {
        const uint32_t i = [tagsDict[MP42MetadataKeyAccountCountry] integerValue];
        MP4TagsSetITunesCountry(tags, &i);
    }
    else {
        MP4TagsSetITunesCountry(tags, NULL);
    }

    if (tagsDict[MP42MetadataKeyContentID] && [tagsDict[MP42MetadataKeyContentID] length]) {
        const uint32_t i = [tagsDict[MP42MetadataKeyContentID] integerValue];
        MP4TagsSetContentID(tags, &i);
    }
    else {
        MP4TagsSetContentID(tags, NULL);
    }

    if (tagsDict[MP42MetadataKeyGenreID] && [tagsDict[MP42MetadataKeyGenreID] length]) {
        const uint32_t i = [tagsDict[MP42MetadataKeyGenreID] integerValue];
        MP4TagsSetGenreID(tags, &i);
    }
    else {
        MP4TagsSetGenreID(tags, NULL);
    }

    if (tagsDict[MP42MetadataKeyArtistID] && [tagsDict[MP42MetadataKeyArtistID] length]) {
        const uint32_t i = [tagsDict[MP42MetadataKeyArtistID] integerValue];
        MP4TagsSetArtistID(tags, &i);
    }
    else {
        MP4TagsSetArtistID(tags, NULL);
    }

    if (tagsDict[MP42MetadataKeyPlaylistID] && [tagsDict[MP42MetadataKeyPlaylistID] length]) {
        const uint64_t i = [tagsDict[MP42MetadataKeyPlaylistID] integerValue];
        MP4TagsSetPlaylistID(tags, &i);
    }
    else {
        MP4TagsSetPlaylistID(tags, NULL);
    }

    if (tagsDict[MP42MetadataKeyComposerID] && [tagsDict[MP42MetadataKeyComposerID] length]) {
        const uint32_t i = [tagsDict[MP42MetadataKeyComposerID] integerValue];
        MP4TagsSetComposerID(tags, &i);
    }
    else {
        MP4TagsSetComposerID(tags, NULL);
    }

    MP4TagsSetXID            (tags, [tagsDict[MP42MetadataKeyXID] UTF8String]);
    MP4TagsSetSortName       (tags, [tagsDict[MP42MetadataKeySortName] UTF8String]);
    MP4TagsSetSortArtist     (tags, [tagsDict[MP42MetadataKeySortArtist] UTF8String]);
    MP4TagsSetSortAlbumArtist(tags, [tagsDict[MP42MetadataKeySortAlbumArtist] UTF8String]);
    MP4TagsSetSortAlbum      (tags, [tagsDict[MP42MetadataKeySortAlbum] UTF8String]);
    MP4TagsSetSortComposer   (tags, [tagsDict[MP42MetadataKeySortComposer] UTF8String]);
    MP4TagsSetSortTVShow     (tags, [tagsDict[MP42MetadataKeySortTVShow] UTF8String]);

    if (isArtworkEdited) {

        for (uint32_t j = 0; j < tags->artworkCount; j++) {
            MP4TagsRemoveArtwork(tags, j);
        }

        for (uint32_t i = 0; i < artworks.count; i++) {
            MP42Image *artwork;
            MP4TagArtwork newArtwork;

            artwork = artworks[i];

            if (artwork.data) {

                newArtwork.data = (void *)artwork.data.bytes;
                newArtwork.size = artwork.data.length;
                newArtwork.type = artwork.type;
            }
            else {

                NSArray<NSImageRep *> *representations = artwork.image.representations;

                if (representations.count) {
                    NSData *bitmapData = [NSBitmapImageRep representationOfImageRepsInArray:representations
                                                                                  usingType:NSPNGFileType properties:@{}];

                    if (bitmapData) {
                        newArtwork.data = (void *)bitmapData.bytes;
                        newArtwork.size = bitmapData.length;
                        newArtwork.type = MP4_ART_PNG;
                    }
                }
            }

            if (tags->artworkCount > i) {
                MP4TagsSetArtwork(tags, i, &newArtwork);
            }
            else {
                MP4TagsAddArtwork(tags, &newArtwork);
            }
        }
    }

    MP4TagsStore(tags, fileHandle);
    MP4TagsFree(tags);

    // Rewrite extended metadata using the generic iTMF api
    if (tagsDict[MP42MetadataKeyRating]) {

        MP4ItmfItemList *list = MP4ItmfGetItemsByMeaning(fileHandle, "com.apple.iTunes", "iTunEXTC");
        if (list) {
            for (uint32_t i = 0; i < list->size; i++) {
                MP4ItmfItem *item = &list->elements[i];
                MP4ItmfRemoveItem(fileHandle, item);
            }
        }
        MP4ItmfItemListFree(list);

        MP4ItmfItem *newItem = MP4ItmfItemAlloc("----", 1);
        newItem->mean = strdup("com.apple.iTunes");
        newItem->name = strdup("iTunEXTC");

        MP4ItmfData *data = &newItem->dataList.elements[0];

        NSString *ratingString = ratingiTunesCode;
        NSArray *iTunesCodes = [[MP42Ratings defaultManager] iTunesCodes];

        // This whole thing is extremely convoluted and wrong in some cases.
        if (![tagsDict[MP42MetadataKeyRating] isKindOfClass:[NSNumber class]] ||
            [tagsDict[MP42MetadataKeyRating] unsignedIntegerValue] == [[MP42Ratings defaultManager] unknownIndex]) {
            if (!ratingString) {
                ratingString = [iTunesCodes objectAtIndex:[[MP42Ratings defaultManager] unknownIndex]];
            }
        } else {
            NSUInteger index = [tagsDict[MP42MetadataKeyRating] unsignedIntegerValue];
            if (iTunesCodes.count > index) {
                ratingString = [iTunesCodes objectAtIndex:[tagsDict[MP42MetadataKeyRating] unsignedIntegerValue]];
            }
        }

        if ([tagsDict[MP42MetadataKeyRatingAnnotation] length] && [ratingString length]) {
			ratingString = [NSString stringWithFormat:@"%@%@", ratingString, tagsDict[MP42MetadataKeyRatingAnnotation]];
		}

        if (ratingString) {
            data->typeCode = MP4_ITMF_BT_UTF8;
            data->valueSize = strlen([ratingString UTF8String]);
            data->value = (uint8_t*)malloc( data->valueSize );
            memcpy( data->value, [ratingString UTF8String], data->valueSize );

            MP4ItmfAddItem(fileHandle, newItem);
        }

        MP4ItmfItemFree(newItem);

    } else {
        MP4ItmfItemList* list = MP4ItmfGetItemsByMeaning(fileHandle, "com.apple.iTunes", "iTunEXTC");
        if (list) {
            for (uint32_t i = 0; i < list->size; i++) {
                MP4ItmfItem *item = &list->elements[i];
                MP4ItmfRemoveItem(fileHandle, item);
            }
        }

        MP4ItmfItemListFree(list);
    }

    MP4ItmfItemList* list = MP4ItmfGetItemsByMeaning(fileHandle, "com.apple.iTunes", "iTunMOVI");
    NSMutableDictionary *iTunMovi = [[NSMutableDictionary alloc] init];;
    if (list) {
        uint32_t i;
        for (i = 0; i < list->size; i++) {
            MP4ItmfItem* item = &list->elements[i];
            uint32_t j;
            for(j = 0; j < item->dataList.size; j++) {
                MP4ItmfData* data = &item->dataList.elements[j];
                NSData *xmlData = [NSData dataWithBytes:data->value length:data->valueSize];
                NSDictionary *dma = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:xmlData
                                                                                              options:NSPropertyListMutableContainersAndLeaves
                                                                                               format:nil error:NULL];
                iTunMovi = [dma mutableCopy];
            }
        }
        MP4ItmfItemListFree(list);
    }

    if (iTunMovi) {
        if (tagsDict[MP42MetadataKeyCast]) {
            [iTunMovi setObject:[self dictArrayFromString:tagsDict[MP42MetadataKeyCast] key:@"name"] forKey:@"cast"];
        }
        else {
            [iTunMovi removeObjectForKey:@"cast"];
        }

        if (tagsDict[MP42MetadataKeyDirector]) {
            [iTunMovi setObject:[self dictArrayFromString:tagsDict[MP42MetadataKeyDirector] key:@"name"] forKey:@"directors"];
        }
        else {
            [iTunMovi removeObjectForKey:@"directors"];
        }

        if (tagsDict[MP42MetadataKeyCodirector]) {
            [iTunMovi setObject:[self dictArrayFromString:tagsDict[MP42MetadataKeyCodirector] key:@"name"] forKey:@"codirectors"];
        }
        else {
            [iTunMovi removeObjectForKey:@"codirectors"];
        }

        if (tagsDict[MP42MetadataKeyProducer]) {
            [iTunMovi setObject:[self dictArrayFromString:tagsDict[MP42MetadataKeyProducer] key:@"name"] forKey:@"producers"];
        }
        else {
            [iTunMovi removeObjectForKey:@"producers"];
        }

        if (tagsDict[MP42MetadataKeyScreenwriters]) {
            [iTunMovi setObject:[self dictArrayFromString:tagsDict[MP42MetadataKeyScreenwriters] key:@"name"] forKey:@"screenwriters"];
        }
        else {
            [iTunMovi removeObjectForKey:@"screenwriters"];
        }

        if (tagsDict[MP42MetadataKeyStudio]) {
            [iTunMovi setObject:tagsDict[MP42MetadataKeyStudio] forKey:@"studio"];
        }
        else {
            [iTunMovi removeObjectForKey:@"studio"];
        }

        NSData *serializedPlist = [NSPropertyListSerialization dataWithPropertyList:iTunMovi
                                                   format:NSPropertyListXMLFormat_v1_0
                                                  options:0 error:NULL];
        if (iTunMovi.count) {
            MP4ItmfItemList *moviList = MP4ItmfGetItemsByMeaning(fileHandle, "com.apple.iTunes", "iTunMOVI");
            if (moviList) {
                uint32_t i;
                for (i = 0; i < moviList->size; i++) {
                    MP4ItmfItem *item = &moviList->elements[i];
                    MP4ItmfRemoveItem(fileHandle, item);
                }
            }
            MP4ItmfItemListFree(moviList);

            MP4ItmfItem* newItem = MP4ItmfItemAlloc( "----", 1 );
            newItem->mean = strdup( "com.apple.iTunes" );
            newItem->name = strdup( "iTunMOVI" );

            MP4ItmfData* data = &newItem->dataList.elements[0];
            data->typeCode = MP4_ITMF_BT_UTF8;
            data->valueSize = [serializedPlist length];
            data->value = (uint8_t*)malloc( data->valueSize );
            memcpy( data->value, [serializedPlist bytes], data->valueSize );

            MP4ItmfAddItem(fileHandle, newItem);
            MP4ItmfItemFree(newItem);
        }
        else {
            MP4ItmfItemList* moviList = MP4ItmfGetItemsByMeaning(fileHandle, "com.apple.iTunes", "iTunMOVI");
            if (moviList) {
                uint32_t i;
                for (i = 0; i < moviList->size; i++) {
                    MP4ItmfItem* item = &moviList->elements[i];
                    MP4ItmfRemoveItem(fileHandle, item);
                }
            }
            MP4ItmfItemListFree(moviList);
        }
    }

    return YES;
}

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt:2 forKey:@"MP42TagEncodeVersion"];

    [coder encodeObject:presetName forKey:@"MP42SetName"];
    [coder encodeObject:tagsDict forKey:@"MP42TagsDict"];
    [coder encodeObject:artworks forKey:@"MP42Artwork"];
    [coder encodeBool:isArtworkEdited forKey:@"MP42ArtworkEdited"];

    [coder encodeInt:mediaKind forKey:@"MP42MediaKind"];
    [coder encodeInt:contentRating forKey:@"MP42ContentRating"];
    [coder encodeInt:hdVideo forKey:@"MP42HDVideo"];
    [coder encodeInt:gapless forKey:@"MP42Gapless"];
    [coder encodeInt:podcast forKey:@"MP42Podcast"];

    [coder encodeBool:isEdited forKey:@"MP42Edited"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];

    NSInteger version = [decoder decodeIntForKey:@"MP42TagEncodeVersion"];

    presetName = [decoder decodeObjectForKey:@"MP42SetName"];
    tagsDict = [decoder decodeObjectForKey:@"MP42TagsDict"];

    // Subler 0.19 and previous sets
    if (version < 2) {
        artworks = [[NSMutableArray alloc] init];
        id image = [decoder decodeObjectForKey:@"MP42Artwork"];
        if (image) {
            MP42Image *artwork = [[MP42Image alloc] initWithImage:image];
            [artworks addObject: artwork];
        }
    }
    else {
        artworks = [decoder decodeObjectForKey:@"MP42Artwork"];
    }

    isArtworkEdited = [decoder decodeBoolForKey:@"MP42ArtworkEdited"];

    mediaKind = [decoder decodeIntForKey:@"MP42MediaKind"];
    contentRating = [decoder decodeIntForKey:@"MP42ContentRating"];
    hdVideo = [decoder decodeIntForKey:@"MP42HDVideo"];
    gapless = [decoder decodeIntForKey:@"MP42Gapless"];
    podcast = [decoder decodeIntForKey:@"MP42Podcast"];

    isEdited = [decoder decodeBoolForKey:@"MP42Edited"];

    return self;
}

#pragma mark - NSCoding

- (id)copyWithZone:(NSZone *)zone
{
    MP42Metadata *newObject = [[MP42Metadata allocWithZone:zone] init];

    if (presetName) {
        newObject.presetName = presetName;
    }

    [newObject mergeMetadata:self];

    newObject.contentRating = contentRating;
    newObject.gapless = gapless;
    newObject.hdVideo = hdVideo;
    newObject.podcast = podcast;

    return newObject;
}

@end
