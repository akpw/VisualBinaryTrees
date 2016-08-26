//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Shows injected tree view in a scroll view, with support for zoom and centering
class TreeViewController: UIViewController {
    fileprivate var scrollView: UIScrollView?
    fileprivate var scrollViewDelegate: ScrollViewDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let scrollViewDelegate = scrollViewDelegate else { return }
        
        view.backgroundColor = scrollViewDelegate.treeView.backgroundColor
        scrollView = {
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.contentSize = scrollViewDelegate.treeView.bounds.size

            $0.delegate = scrollViewDelegate
            $0.addSubview(scrollViewDelegate.treeView)
            view.addSubview($0)
            
            return $0
        }( UIScrollView(frame: view.bounds) )
    }
    
    override func viewWillLayoutSubviews() {
        guard let scrollViewDelegate = scrollViewDelegate, let scrollView = scrollView else { return }
        scrollView.boundaryZoomScales(forSize: scrollViewDelegate.treeView.bounds.size)
        scrollView.zoomScale = scrollView.minimumZoomScale  //Swift.max(scrollView.minimumZoomScale, scrollView.zoomScale)
        scrollView.centerContent(forSize: scrollViewDelegate.treeView.frame.size)
    }
}


extension TreeViewController: DependencyInjectable {
    func inject(_ treeView: UIView) {
        scrollViewDelegate = ScrollViewDelegate(treeView: treeView)
    }
}

private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {
    fileprivate let treeView: UIView
    init(treeView: UIView) { self.treeView = treeView }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return treeView }
    func scrollViewDidZoom(_ scrollView: UIScrollView) { scrollView.centerContent(forSize: treeView.frame.size) }
}

private extension UIScrollView {
    func boundaryZoomScales(forSize size: CGSize) {        
        let widthScale = self.bounds.size.width / size.width
        let heightScale = self.bounds.size.height / size.height
        let minZoomScale = Swift.min(widthScale, heightScale)
        let maxZoomScale = Swift.min(Swift.max(widthScale, heightScale), 3.5)
        self.minimumZoomScale = minZoomScale
        self.maximumZoomScale = maxZoomScale
    }
    
    func centerContent(forSize size: CGSize) {
        let horizontalSpace = size.width < self.bounds.size.width ?
                                    (self.bounds.size.width - size.width) / 2 : 0
        let verticalSpace = size.height < self.bounds.size.height ?
                                    (self.bounds.size.height - size.height) / 2 : 0
        self.contentInset = UIEdgeInsets(top: verticalSpace,    left: horizontalSpace,
                                         bottom: verticalSpace, right: horizontalSpace)
    }
}


