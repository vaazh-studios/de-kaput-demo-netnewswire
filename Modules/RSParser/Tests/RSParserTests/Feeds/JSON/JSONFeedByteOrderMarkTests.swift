//
//  JSONFeedByteOrderMarkTests.swift
//  RSParserTests
//

import Foundation
import Testing
import RSParser

@Suite struct JSONFeedByteOrderMarkTests {

	/// Refreshing a JSON Feed whose server starts the response with a UTF-8 byte order mark
	/// crashed the app while parsing it (Crashlytics issue 4b8e2f6a0c1d4e3f9a7b5c3d1e0f8a6b).
	@Test func jsonFeedServedWithByteOrderMarkParses() async throws {
		let fixture = parserData("DaringFireball", "json", "http://daringfireball.net/")
		let byteOrderMark = Data([0xEF, 0xBB, 0xBF])
		let served = ParserData(url: fixture.url, data: byteOrderMark + fixture.data)

		// The way the app's refresher reaches the parser.
		let parsedFeed = try #require(try await FeedParser.parse(served))
		let expectedFeed = try #require(try await FeedParser.parse(fixture))

		#expect(parsedFeed.type == .jsonFeed)
		#expect(parsedFeed.title == expectedFeed.title)
		#expect(parsedFeed.items.count == expectedFeed.items.count)
	}
}
