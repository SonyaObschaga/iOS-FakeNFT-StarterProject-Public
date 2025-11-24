//
//  CollectionResponse.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

struct CollectionResponse: Decodable {
       let id: String
       let name: String        
       let cover: URL
       let nfts: [String]
       
   }
