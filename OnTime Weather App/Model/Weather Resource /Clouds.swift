//
//  Clouds.swift
//  Arkan
//
//  Created by BinaryCase on 1/2/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import Foundation
struct Clouds : Codable {
	let all : Int?

	enum CodingKeys: String, CodingKey {

		case all = "all"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		all = try values.decodeIfPresent(Int.self, forKey: .all)
	}

}
