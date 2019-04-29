//
//  TabVC.swift
//  DFScrollStack
//
//  Created by David Furman on 3/5/19.
//

import UIKit

class TabVC: UIViewController {
    
    // ========
    // MARK: - Properties
    // ========
    
    var buttonBarView: TabBarView! {
        didSet {
            buttonBarView.appearance = tabBarAppearance
            buttonBarView.register(UINib(nibName: TabBarCell.nameOfClass, bundle: nil), forCellWithReuseIdentifier: TabBarCell.nameOfClass)
            buttonBarView.dataSource = self
            buttonBarView.delegate = self
            buttonBarView.showsHorizontalScrollIndicator = false
            buttonBarView.isScrollEnabled = false
            
            let flowLayout = buttonBarView.collectionViewLayout as! UICollectionViewFlowLayout // swiftlint:disable:this force_cast
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = tabBarAppearance.itemSpacing
            flowLayout.minimumLineSpacing = tabBarAppearance.itemSpacing
            let sectionInset = flowLayout.sectionInset
            flowLayout.sectionInset = UIEdgeInsets(top: sectionInset.top,
                                                   left: tabBarAppearance.buttonBarLeftContentInset,
                                                   bottom: sectionInset.bottom,
                                                   right: tabBarAppearance.buttonBarRightContentInset)
            
            setupTabs()
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapButtonBarView(sender:)))
            buttonBarView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    var containerView: UIView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tabItems: [TabBarItem] = []
    var tabBarAppearance = TabBarAppearance()
    var displayedVC: UIViewController!
    var selectedIndex: Int = -1

    
    
    
    
    // ========
    // MARK: - Lifecycle
    // ========
    
    private func addSubviews() {
        let layout = UICollectionViewFlowLayout()
        let barButtonViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        buttonBarView = TabBarView(frame: barButtonViewFrame, collectionViewLayout: layout)
        containerView = UIView()

        view.addSubview(buttonBarView)
        buttonBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            buttonBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            buttonBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            buttonBarView.heightAnchor.constraint(equalToConstant: barButtonViewFrame.height),
        ])
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: buttonBarView.bottomAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            ])
        
        view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        // Select the initial tab
        selectIndex(0, animated: false)
    }
    
    
    
    
    
    // ========
    // MARK: - Tab Selection
    // ========
    
    private func selectIndex(_ i: Int, animated: Bool) {
        guard selectedIndex != i else { return }
        selectedIndex = i
        
        let vc = viewController(for: i)
        setContainerViewController(vc)
        
        let indexPath = IndexPath(row: i, section: 0)
        buttonBarView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
    }
    
    @objc private func didTapButtonBarView(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let touchPoint = sender.location(in: buttonBarView)
            guard let indexPath = buttonBarView.indexPathForItem(at: touchPoint) else { return }
            selectIndex(indexPath.item, animated: true)
        default: return
        }
    }

    
    private func setContainerViewController(_ viewController: UIViewController) {
        // Remove any currently displayed view controller
        if let displayedVC = displayedVC {
            displayedVC.view.removeFromSuperview()
            displayedVC.removeFromParent()
        }
        
        addChild(viewController)
        
        // For the sake of using TabVC in a ScrollingStackContainer, only trigger didMove if the TabVC has a parent. This is to allow the displayedVC to determine if it should be considered added to a view, to make decisions such as whether it should be dequeuing cells in its collections if it has any.
        if parent != nil {
            viewController.didMove(toParent: self)
        }
        // Add the view controller's view to the container and set its constraints
        containerView.addSubview(viewController.view)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        bottomConstraint.priority = UILayoutPriority.init(999) // Set the bottom constraint's priority to be < 1000, to grant constraint leeway when adding a view larger than the container. It prevent's the viewController's view's constraints from being broken. This is necessary if the TabVC is placed within a ScrollingStackContainer. It feels like a hacky solution, but it works, and the views display correctly.
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            bottomConstraint,
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            ])
        
        displayedVC = viewController
    }
    
    override func didMove(toParent parent: UIViewController?) {
        displayedVC.didMove(toParent: parent)
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        let childPreferredContentSize = container.preferredContentSize
        let preferredHeight = childPreferredContentSize.height + buttonBarView.frame.height
        preferredContentSize = CGSize(width: view.frame.width, height: preferredHeight)
    }
    
    
    
    
    
    // ========
    // MARK: - Overridable Functions
    // ========
    
    func setupTabs() {
        fatalError("Override this function and use it to set tabItems")
    }
    
    func viewController(for index: Int) -> UIViewController {
        fatalError("Override this function and use it to return a view controller for a given index.")
    }
}





// ========
// MARK: - TabVC: UICollectionViewDelegateFlowLayout
// ========

extension TabVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        func calculateTabItemCellWidth() -> CGFloat {
            let numberOfCells: Int = tabItems.count
            let flowLayout = buttonBarView.collectionViewLayout as! UICollectionViewFlowLayout
            
            let collectionViewAvailiableWidth = buttonBarView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
            let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumInteritemSpacing
            let availableWidthForCells = collectionViewAvailiableWidth - cellSpacingTotal
            let width = availableWidthForCells / CGFloat(numberOfCells)
            return width
        }
        
        let width: CGFloat = calculateTabItemCellWidth()
        let height = collectionView.frame.size.height// - tabBarAppearance.selectedBarHeight
        return CGSize(width: ceil(width), height: ceil(height))
    }
}





// ========
// MARK: - TabVC: UICollectionViewDelegate
// ========

extension TabVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}





// ========
// MARK: - TabVC: UICollectionViewDataSource
// ========

extension TabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.nameOfClass, for: indexPath) as? TabBarCell else {
            fatalError("UICollectionViewCell should be or extend from ButtonBarViewCell")
        }
        
        let tabItem = tabItems[indexPath.item]
        cell.configure(item: tabItem)
        return cell
    }
}
