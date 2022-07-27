import Foundation

#if BUILD_WIDGETS

let widgetsIncluded = true

struct WatchWidget {}

struct TodayWidget {}

#else

let widgetsIncluded = false

#endif
