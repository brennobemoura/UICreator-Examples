//
//  CollectionView.swift
//  Teste1
//
//  Created by brennobemoura on 22/12/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import UIKit
import UIContainer
import UICreator

class MyLabel: UICViewRepresentable, TextElement {
    typealias View = UILabel

    required init(_ text: String?) {
        self.uiView.text = text
    }

    required init(_ attributedText: NSAttributedString?) {
        self.uiView.attributedText = attributedText
    }

    func makeUIView() -> View {
        return .init()
    }

    func updateView(_ view: UILabel) {}
}

class BackgroundView: Root {
    let randomNumber: Int

    var color: UIColor {
        UIColor(red: {
            CGFloat(randomNumber % 255) / 255
        }(), green: {
            CGFloat(Int(CGFloat(randomNumber) / 255) % 255) / 255
        }(), blue: {
            CGFloat(Int((CGFloat(randomNumber) / 255) / 255) % 255) / 255
        }(), alpha: 1)
    }

    init(_ randomNumber: Int) {
        self.randomNumber = randomNumber
    }
}

extension BackgroundView: TemplateView {
    var body: ViewCreator {
        UICSpacer()
            .background(color: self.color)
    }
}

class CollectionView: Root {
    weak var collectionView: UICollectionView!
    weak var pageControl: UIPageControl!

    lazy var numbers: [Int] = {
        (0...100).compactMap { _ in
            (Int(0)...Int(pow(255.0, 3))).randomElement()
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadData()
    }
}

extension CollectionView: TemplateView {
    private var firstGroup: CollectionLayoutElement {
        .group(vertical: .equalTo(60)) {
            .items(horizontal: .flexible(1/2), quantity: 2)
        }
    }

    private var secondGroup: CollectionLayoutElement {
        .group(vertical: .equalTo(120)) {
            .items(horizontal: .flexible(1/2), quantity: 2)
        }
    }

    private var thirdGroup: CollectionLayoutElement {
        let first3items: CollectionLayoutElement = .group(horizontal: .flexible(1/3)) {
            .items(vertical: .equalTo(60), quantity: 3)
        }

        return .group(vertical: .equalTo(60 * 3)) {
            .sequence {[
                first3items,
                .item(vertical: .flexible(1), horizontal: .flexible(2/3))
            ]}
        }
    }

    var body: ViewCreator {
        UICVStack {[
            UICPageControl(numberOfPages: 2)
                .background(color: .black)
                .onPageChanged {
                    print(($0 as? UIPageControl)?.currentPage ?? "0")
                }.as(&self.pageControl),
            UICFlow {[
                UICForEach(self.numbers) { number in
                    UICRow {
                        BackgroundView(number)
                    }
                }
            ]}.layoutMaker {
                .section {
                    .sequence {[
                        self.firstGroup,
                        self.secondGroup
                    ]}
                }
            }
            .line(minimumSpacing: 0)
            .interItem(minimumSpacing: 0)
            .as(&self.collectionView)
            .background(color: .clear)
            .scroll(direction: .vertical)
            .background {
                Child {[
                    UICImage(image: #imageLiteral(resourceName: "waterfall"))
                        .content(mode: .scaleAspectFill)
                        .clips(toBounds: true)
                        .insets(),
                    UICBlur(blur: .extraLight),
                    UICSpacer()
                        .background(color: .white)
                        .safeArea(topEqualTo: 0)
                ]}
            }
        ]}.safeAreaInsets()
    }
}
