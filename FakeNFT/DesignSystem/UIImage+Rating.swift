//
//  UIImage+Rating.swift
//  FakeNFT
//
//  Created by Илья on 09.12.2025.
//

import UIKit

extension UIImage {
    static func ratingImage(for rating: Int) -> UIImage? {
        switch rating {
        case 0: return UIImage(resource: .rating0)
        case 1: return UIImage(resource: .rating1)
        case 2: return UIImage(resource: .rating2)
        case 3: return UIImage(resource: .rating3)
        case 4: return UIImage(resource: .rating4)
        case 5: return UIImage(resource: .rating5)
        default: return UIImage(resource: .rating0)
        }
    }
}
