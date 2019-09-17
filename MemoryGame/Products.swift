//
//  Products.swift
//  MemoryGame
//
//  Created by Nicole Nowicki on 2019-09-12.
//  Copyright © 2019 Nicole Nowicki. All rights reserved.
//

// MARK: Products

class Products: Decodable {
    let products: [Product]
}

// MARK: Product

class Product: Decodable {
    let id: Int?
    let image: ProductImage?
}

// MARK: ProductImage

class ProductImage: Decodable {
    let id: Int?
    let src: String?
}
