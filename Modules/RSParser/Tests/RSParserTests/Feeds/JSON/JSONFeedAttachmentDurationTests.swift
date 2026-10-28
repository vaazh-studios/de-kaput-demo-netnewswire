//
//  JSONFeedAttachmentDurationTests.swift
//  RSParser
//

import Foundation
import Testing
import RSParser

/// A podcast feed whose attachment duration is too large for an Int crashed the parser
/// (Crashlytics e7d3a9b1: EXC_BREAKPOINT in JSONFeedParser.parseAttachment(_:)).
@Suite struct JSONFeedAttachmentDurationTests {

	@Test func durationTooLargeForAnIntIsDropped() throws {
		let parsedFeed = try #require(try FeedParser.parse(podcastFeed(duration: "1e19")))
		let attachment = try #require(parsedFeed.items.first?.attachments?.first)
		#expect(attachment.durationInSeconds == nil)
	}

	@Test func fractionalDurationIsRounded() throws {
		let parsedFeed = try #require(try FeedParser.parse(podcastFeed(duration: "1534.5")))
		let attachment = try #require(parsedFeed.items.first?.attachments?.first)
		#expect(attachment.durationInSeconds == 1535)
	}
}

private func podcastFeed(duration: String) -> ParserData {
	let json = """
	{"version": "https://jsonfeed.org/version/1.1", "title": "Episodes", "items": [
		{"id": "1", "content_text": "Episode one", "attachments": [
			{"url": "https://example.com/1.mp3", "mime_type": "audio/mpeg", "duration_in_seconds": \(duration)}]}]}
	"""
	return ParserData(url: "https://example.com/feed.json", data: Data(json.utf8))
}
