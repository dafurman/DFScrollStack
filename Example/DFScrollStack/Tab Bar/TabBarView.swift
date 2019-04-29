//
//  TabBarView.swift
//  DFScrollStack
//
//  Created by David Furman on 3/6/19.
//

import UIKit

class TabBarAppearance {
    public var buttonBarBackgroundColor: UIColor = .red
    public var buttonBarLeftContentInset: CGFloat = 8
    public var buttonBarRightContentInset: CGFloat = 8
    public var itemSpacing: CGFloat = 8
    
    public var selectedBarBackgroundColor = UIColor.black
    public var selectedBarHeight: CGFloat = 2
}

class TabBarItem {
    
    // ========
    // MARK: - Properties
    // ========
    
    private(set) var title: String?
    private(set) var highlightedImage: UIImage?
    private(set) var image: UIImage?
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 18)
    var highlightedTitleFont: UIFont = UIFont.systemFont(ofSize: 18)
    var colors = Colors()
    
    struct Colors {
        var highlightedTextColor: UIColor = .black
        var textColor: UIColor = .black
        var highlightedImage: UIColor = .black
        var image: UIColor = .black
    }
    
    
    
    
    
    // ========
    // MARK: - Initialization
    // ========
    
    init(title: String) {
        self.title = title
    }
    
    init(image: UIImage, highlightedImage: UIImage?) {
        self.image = image
        self.highlightedImage = highlightedImage ?? image
    }
}






protocol TabBarViewDelegate: class {
    func didSelect(index: Int)
}

class TabBarView: UICollectionView {
    
    // ========
    // MARK: - Properties
    // ========
    
    weak var tabBarDelegate: TabBarViewDelegate? = nil
    
    lazy var selectedBar: UIView = { [unowned self] in
        let bar = UIView(frame: CGRect(x: 0, y: self.frame.size.height - CGFloat(appearance.selectedBarHeight), width: 0, height: CGFloat(appearance.selectedBarHeight)))
        bar.layer.zPosition = 9999 // Ensure the bar is on top of everything else.
        bar.backgroundColor = appearance.selectedBarBackgroundColor
        return bar
    }()
    
    var appearance: TabBarAppearance = TabBarAppearance() {
        didSet {
            backgroundColor = appearance.buttonBarBackgroundColor
            selectedBar.backgroundColor = appearance.selectedBarBackgroundColor
            selectedBar.frame = CGRect(x: selectedBar.frame.origin.x,
                                       y: selectedBar.frame.origin.y,
                                       width: selectedBar.frame.width,
                                       height: appearance.selectedBarHeight)
        }
    }
    
    
    
    
    
    // ========
    // MARK: - Initialization
    // ========
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(selectedBar)
        backgroundColor = appearance.buttonBarBackgroundColor
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addSubview(selectedBar)
        backgroundColor = appearance.buttonBarBackgroundColor
    }
    
    
    
    
    
    // ========
    // MARK: - Functions
    // ========
    
    private func setSelectionBarPosition(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let attributes = layoutAttributesForItem(at: indexPath)!
        
        let x = attributes.frame.origin.x
        let y = attributes.frame.height - selectedBar.frame.height
        let width = attributes.frame.width
        
        UIView.animate(withDuration: 0.2) {
            self.selectedBar.frame = CGRect(x: x, y: y, width: width, height: self.selectedBar.frame.height)
            self.selectedBar.layoutIfNeeded()
        }
    }
    
    override func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        super.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        
        guard let indexPath = indexPath else { return }
        setSelectionBarPosition(index: indexPath.item)
        
        tabBarDelegate?.didSelect(index: indexPath.item)
    }
    
    func selectItem(at index: Int, animated: Bool) {
        tabBarDelegate?.didSelect(index: index)
    }
}
