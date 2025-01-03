package crawler

import "core:log"
import "core:strings"

LogLevel :: enum {
	INFO,
	DEBUG,
	WARNING,
	ERROR,
}

crawler_log :: proc(text: string, log_leveL: LogLevel) {
	LOG_PREFIX: string : "crawler - "
	new_text: string = strings.concatenate({LOG_PREFIX, text}, context.temp_allocator)

	switch log_leveL {
	case .INFO:
		{log.info(new_text)}
	case .DEBUG:
		{log.debug(new_text)}
	case .WARNING:
		{log.warn(new_text)}
	case .ERROR:
		{log.error(new_text)}
	}
}
