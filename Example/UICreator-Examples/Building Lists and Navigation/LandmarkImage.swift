//
//  TurtleRock.CircleImage.swift
//  UICreator-Examples_Example
//
//  Created by brennobemoura on 21/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UICreator

class LandmarkImage: UICView {
    let image: UIImage

    init(image: UIImage) {
        self.image = image
        super.init()
    }

    var body: ViewCreator {
        UICSpacer {
            UICCircle {
                UICImage(image: self.image)
                    .aspectRatio()
                    .content(mode: .scaleAspectFill)
            }.border(width: 4)
            .border(color: .white)
        }.shadow(radius: 10)
        .shadow(ocupacity: 0.3)
    }
}

import SwiftUI

struct LandmarkImage_Preview: PreviewProvider {
    static var previews: some View {
        LivePreview(LandmarkImage(image: landmarkData[0].image))
    }
}
