//
//  ScrollVC.swift
//  DFScrollStack
//
//  Created by David Furman on 3/7/19.
//

import UIKit
import DFScrollStack

/// A ScrollStackContainable that has a scroll view.
class ScrollVC: UIViewController, ScrollStackContainable {
    
    // ========
    // MARK: - Properties
    // ========
    
    var scrollView: UIScrollView? { return nil }
    var insets: UIEdgeInsets {
        let top = showsTopLabel ? topInset : 0
        let bottom = showsBotLabel ? botInset : 0
        return UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    }
    
    /// The height to use for the topLabel
    private let topInset: CGFloat = 500
    /// The height to use for the botLabel
    private let botInset: CGFloat = 100
    
    /// The UILabel placed above the scrollView, if `showsTopView` is true.
    private var topLabel: UILabel?
    /// The UILabel placed below the scrollView, if `showsBotView` is true.
    private var botLabel: UILabel?
    
    /// Whether or not to include a label above the scrollView to demonstrate how other non-scrolling views can be included in a ScrollStackContainable.
    var showsTopLabel: Bool = true
    /// Whether or not to include a label below the scrollView to demonstrate how other non-scrolling views can be included in a ScrollStackContainable.
    var showsBotLabel: Bool = true
    
    
    
    
    
    // ========
    // MARK: - Lifecycle
    // ========
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        addSubviews()
        
        view.layoutIfNeeded()
    }
    
    
    
    
    
    // ========
    // MARK: - View Setup
    // ========
    
    /// Adds a scrollview to the view and sets the `scrollView` property.
    func addScrollView() {
        fatalError("Override this function")
    }
    
    /// Sets the topLabel and botLabel depending on the values of `showsTopLabel` and `showsBotLabel`.
    /// This is used to demonstrate that ScrollStackContainables can have views above and below the main scrollview still get displayed properly by their controlling ScrollStackController.
    private func addExampleInsetViews() {
        if showsTopLabel {
            let topLabel: UILabel = {
                let label = UILabel()
                label.text = "Top of \(title!)"
                label.textColor = .white
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                label.backgroundColor = .blue
                return label
            }()
            
            self.topLabel = topLabel
            
            view.addSubview(topLabel)
            
            let topConstraint = topLabel.heightAnchor.constraint(equalToConstant: topInset)
            NSLayoutConstraint.activate([
                topConstraint,
                topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topLabel.topAnchor.constraint(equalTo: view.topAnchor),
                topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        }
        
        if showsBotLabel {
            let botLabel: UILabel = {
                let label = UILabel()
                label.text = "Bottom of \(title!)"
                label.textColor = .white
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                label.backgroundColor = .orange
                return label
            }()
            
            self.botLabel = botLabel
            
            view.addSubview(botLabel)
            
            let botConstraint = botLabel.heightAnchor.constraint(equalToConstant: botInset)
            NSLayoutConstraint.activate([
                botConstraint,
                botLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                botLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                botLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        }
    }
    
    /// Adds subviews to the scrollView.
    private func addSubviews() {
        addScrollView()
        addExampleInsetViews()
        
        guard let scrollView = scrollView else { return }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        if let topLabel = topLabel {
            scrollView.topAnchor.constraint(equalTo: topLabel.bottomAnchor).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
        if let botLabel = botLabel {
            scrollView.bottomAnchor.constraint(equalTo: botLabel.topAnchor).isActive = true
        } else {
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
}
