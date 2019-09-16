//
//  Products.swift
//  MemoryGame
//
//  Created by Nicole Nowicki on 2019-09-12.
//  Copyright © 2019 Nicole Nowicki. All rights reserved.
//

import Foundation

class Products: Decodable {
    let products: [Product]
}

class Product: Decodable {
    let id: Int?
    let image: ProductImage?
}

class ProductImage: Decodable {
    let id: Int?
    let src: String?
}

