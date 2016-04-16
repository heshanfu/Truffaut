//
//  SlidesViewController.swift
//  Truffaut
//
//  Created by Yan Li on 4/15/16.
//  Copyright © 2016 Codezerker. All rights reserved.
//

import Cocoa

class SlidesViewController: NSViewController {
  
  weak var windowController: NSWindowController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    MenuActionDispatcher.ActionType.registerNotifications(observer: self) { [weak self] action in
      switch action {
      case .Previous:
        self?.showPrevious()
      case .Next:
        self?.showNext()
      }
    }
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    guard let document = windowController?.document as? Document else {
      return
    }
    
    show(document)
  }
  
}

extension SlidesViewController {
  
  private func showNext() {
    print(#function)
  }
  
  private func showPrevious() {
    print(#function)
  }
  
  private func show(document: Document) {
    guard let page = document.slides?.pages.first,
          let template = PlugIn.sharedPlugIn.templates[page.typeIdentifier] else {
        return
    }
    
    let pageViewController = template.createPageViewControllerWithPageTitle(page.title, bulletPoints: page.bulletPoints)
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pageViewController.view)
    
    let views = ["slide" : pageViewController.view]
    let visualFormatStrings: [String] = [
      "V:|-0-[slide]-0-|",
      "H:|-0-[slide]-0-|",
    ]
    
    for visualFormatString: String in visualFormatStrings {
      let constraints = NSLayoutConstraint.constraintsWithVisualFormat(
        visualFormatString,
        options: [],
        metrics: nil,
        views: views)
      view.addConstraints(constraints)
    }
  }
  
}
