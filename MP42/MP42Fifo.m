//
//  MP42Fifo.m
//  Subler
//
//  Created by Damiano Galassi on 09/08/13.
//
//

#import "MP42Fifo.h"

@implementation MP42Fifo

- (instancetype)init {
    self = [self initWithCapacity:300];
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _size = (int32_t)capacity;
        _array = (id *) malloc(sizeof(id) * _size);
        _full = dispatch_semaphore_create(_size - 1);
        _empty = dispatch_semaphore_create(0);

    }
    return self;
}

- (void)enqueue:(id)item {
    if (_cancelled) return;

    [item retain];

    dispatch_semaphore_wait(_full, DISPATCH_TIME_FOREVER);

    _array[_tail++] = item;

    if (_tail == _size) {
        _tail = 0;
    }

    OSAtomicIncrement32Barrier(&_count);
    dispatch_semaphore_signal(_empty);
}

- (nullable id)dequeue {
    if (!_count) return nil;

    id item = _array[_head++];

    if (_head == _size) {
        _head = 0;
    }

    OSAtomicDecrement32Barrier(&_count);
    dispatch_semaphore_signal(_full);

    return item;
}

- (nullable id)dequeueAndWait {
    id item = [self dequeue];

    if (!item) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC / 1000);
        dispatch_semaphore_wait(_empty, time);
    }

    return item;
}

- (NSUInteger)count {
    return _count;
}

- (BOOL)isFull {
    return (_count >= _size);
}

- (BOOL)isEmpty {
    return !_count;
}

- (void)drain {
    id item;
    while ((item = [self dequeue])) {
        [item release];
    }
}

- (void)cancel {
    OSAtomicIncrement32(&_cancelled);
    [self drain];
}

- (void)dealloc {
    [self drain];

	free(_array);
    dispatch_release(_full);
    dispatch_release(_empty);

    [super dealloc];
}

@end
