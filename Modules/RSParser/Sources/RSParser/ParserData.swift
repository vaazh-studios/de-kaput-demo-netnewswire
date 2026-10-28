//
//  ParserData.swift
//  RSParser
//
//  Created by Brent Simmons on 4/20/26.
//

import Foundation

/// Bytes to parse plus the originating URL,
/// so parsers can resolve relative URLs.
public struct ParserData: Sendable {

	public let url: String
	public let data: Data

	public init(url: String, data: Data) {
		self.url = url
		self.data = data
	}

	/// The same bytes without a leading UTF-8 byte order mark, which some servers send.
	var withoutUTF8BOM: ParserData {
		guard data.starts(with: [0xEF, 0xBB, 0xBF]) else {
			return self
		}
		return ParserData(url: url, data: data[3...])
	}
}
