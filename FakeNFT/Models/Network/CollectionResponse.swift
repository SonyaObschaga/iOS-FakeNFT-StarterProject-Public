//
//  CollectionResponse.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

struct CollectionResponse: Decodable {
       let id: String
       let name: String        // -> title
       let cover: URL          // -> coverURL
       let nfts: [String]      // -> count для nftsCount
       
   }
