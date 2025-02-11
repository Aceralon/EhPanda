//
//  Gallery.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 4/02/01.
//

import SwiftUI

struct Gallery: Identifiable, Codable, Equatable, Hashable {
    static func == (lhs: Gallery, rhs: Gallery) -> Bool {
        lhs.gid == rhs.gid
    }

    static func mockGalleries(count: Int, randomID: Bool = true) -> [Gallery] {
        guard randomID, count > 0 else {
            return Array(repeating: .empty, count: count)
        }
        return (0...count).map { _ in .empty }
    }
    static var empty: Gallery {
        .init(
            gid: UUID().uuidString,
            token: "",
            title: "",
            rating: 0.0,
            tags: [],
            category: .doujinshi,
            uploader: "",
            pageCount: 1,
            postedDate: .now,
            coverURL: nil,
            galleryURL: nil
        )
    }
    static let preview = Gallery(
        gid: UUID().uuidString,
        token: "",
        title: "Preview",
        rating: 3.5,
        tags: [],
        category: .doujinshi,
        uploader: "Anonymous",
        pageCount: 1,
        postedDate: .now,
        coverURL: URL(
            string: "https://github.com/"
            + "tatsuz0u/Imageset/blob/"
            + "main/JPGs/2.jpg?raw=true"
        ),
        galleryURL: nil
    )

    var trimmedTitle: String {
        var title = title
        if let range = title.range(of: "|") {
            title = String(title[..<range.lowerBound])
        }
        title = title.barcesAndSpacesRemoved
        return title
    }
    var language: Language? {
        let rawValue = tags
            .first(where: { $0.namespace == .language })?.contents
            .first(where: { Language(rawValue: $0.firstLetterCapitalizedText) != nil })
            .map(\.firstLetterCapitalizedText) ?? ""
        return .init(rawValue: rawValue)
    }
    func tagContents(maximum: Int) -> [GalleryTag.Content] {
        let tagContents = tags.flatMap(\.contents)
        guard maximum > 0 else { return tagContents }
        return .init(tagContents.prefix(min(tagContents.count, maximum)))
    }

    var id: String { gid }
    let gid: String
    let token: String

    var title: String
    var rating: Float
    var tags: [GalleryTag]
    let category: Category
    var uploader: String?
    var pageCount: Int
    let postedDate: Date
    let coverURL: URL?
    let galleryURL: URL?
    var lastOpenDate: Date?
}

extension Gallery: DateFormattable, CustomStringConvertible {
    var description: String {
        "Gallery(\(gid))"
    }

    var filledCount: Int { Int(rating) }
    var halfFilledCount: Int { Int(rating - 0.5) == filledCount ? 1 : 0 }
    var notFilledCount: Int { 5 - filledCount - halfFilledCount }

    var color: Color {
        category.color
    }
    var originalDate: Date {
        postedDate
    }
}
