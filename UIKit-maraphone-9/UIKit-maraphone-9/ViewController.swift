//
//  ViewController.swift
//  UIKit-maraphone-9
//
//  Created by Surgeont on 27.07.2023.
//

import UIKit

class ViewController: UIViewController {
//    private let layout = CustomLayout()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CustomLayout())
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (collectionView.collectionViewLayout as? CustomLayout)?.setInsets(inset: view.layoutMargins.left)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Collection"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.backgroundColor = .cyan
        collectionView.decelerationRate = .fast
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView.frame = view.bounds
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
    }
    
//    func makeLayout() -> UICollectionViewFlowLayout {
//        let layout = CollectionViewLayout()
//        return layout
//    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .cyan
        return cell
    }
    
    
}


class CustomLayout: UICollectionViewFlowLayout {
    private let velocityThreshold: CGFloat = 2
    private let numberOfItems: CGFloat = 1

    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.itemSize = CGSize(width: 300, height: 450)
        self.minimumLineSpacing = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInsets(inset: CGFloat) {
        self.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        let pageHEight: CGFloat
        let approximatePage: CGFloat
        let currentPage: CGFloat
        let flickVelocity: CGFloat

        if scrollDirection == .horizontal {
            pageHEight = (self.itemSize.width + self.minimumLineSpacing) * numberOfItems
            approximatePage = collectionView.contentOffset.x / pageHEight
            flickVelocity = velocity.x
        } else {
            pageHEight = (self.itemSize.height + self.minimumLineSpacing) * numberOfItems
            approximatePage = collectionView.contentOffset.y / pageHEight
            flickVelocity = velocity.y
        }

        if flickVelocity < 0 {
            currentPage = ceil(approximatePage)
        } else if flickVelocity > 0 {
            currentPage = floor(approximatePage)
        } else {
            currentPage = round(approximatePage)
        }

        guard flickVelocity != 0 else {
            if scrollDirection == .horizontal {
                return CGPoint(x: currentPage * pageHEight, y: 0)
            } else {
                return CGPoint(x: 0, y: currentPage * pageHEight)
            }
        }

        var nextPage: CGFloat = currentPage + (flickVelocity > 0 ? 1 : -1)

        let increment = flickVelocity / velocityThreshold
        nextPage += (flickVelocity < 0) ? ceil(increment) : floor(increment)

        if scrollDirection == .horizontal {
            return CGPoint(x: nextPage * pageHEight, y: 0)
        } else {
            return CGPoint(x: 0, y: nextPage * pageHEight)
        }
    }
}
