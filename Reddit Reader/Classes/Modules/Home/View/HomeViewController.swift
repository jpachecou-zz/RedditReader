//
//  HomeViewController.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/21/17.
//  Copyright © 2017 Jonathan Pacheco. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyHelpers
import TOWebViewController

class HomeViewController: BaseViewController {

    @IBOutlet fileprivate weak var collectionView:          UICollectionView!
    @IBOutlet private weak var collectionContainerView:     UIView!
    @IBOutlet private weak var headerContainerView:         UIView!
    
    @IBOutlet private weak var leftPageButtonItem:          UIBarButtonItem!
    @IBOutlet private weak var rightPageButtonItem:         UIBarButtonItem!
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxBind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIApplication.shared.statusBarOrientation == .portrait {
            collectionContainerView.topCornerRound(radius: 22.0)
        }
    }
    
    override func configureViewController() {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
        collectionView.do {
            $0 <= PostCollectionViewCell.self
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = generateFlowLayout()
        }
    }
    
    private func rxBind() {
        
        leftPageButtonItem.rx.tap
            .bindTo(viewModel.leftPageAction)
            .addDisposableTo(disposeBag)
        
        rightPageButtonItem.rx.tap
            .bindTo(viewModel.rightPageAction)
            .addDisposableTo(disposeBag)
        
        viewModel.leftPageEnabled
            .drive(leftPageButtonItem.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.rightPageEnabled
            .drive(rightPageButtonItem.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.redditPosts
            .do(onNext: { [weak self] _ in
                guard let welf = self else { return }
                welf.collectionView.scrollRectToVisible(welf.collectionContainerView.bounds, animated: true)
            })
            .drive(collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)) {
                [weak self] row, post, cell in
                cell.disposables.dispose()
                cell.configure(withPost: post)
                cell.isFirst = row == 0
                
                cell.disposables += cell.rx.sharePost
                    .subscribe(onNext: {
                        self?.share(post: $0)
                    })
                cell.disposables += cell.rx.morePost
                    .subscribe(onNext: {
                        self?.more(post: $0)
                    })
            }
            .addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx
            .notification(.UIDeviceOrientationDidChange)
            .subscribe(onNext: { [weak self] _ in
                guard let welf = self else { return }
                if UIApplication.shared.statusBarOrientation == .portrait {
                    welf.collectionContainerView.topCornerRound(radius: 22.0)
                } else {
                    welf.collectionContainerView.layer.mask =  nil
                }
                welf.collectionView.setCollectionViewLayout(welf.generateFlowLayout(), animated: false)
                welf.view.setNeedsLayout()
            })
            .addDisposableTo(disposeBag)
    }
}

extension HomeViewController {
    
    fileprivate func generateFlowLayout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            if UIApplication.shared.statusBarOrientation == .portrait {
                $0.sectionInset = UIEdgeInsets(top: 86.0, left: 0, bottom: 44.0, right: 0)
                $0.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 250.0)
                $0.scrollDirection = .vertical
            } else {
                $0.sectionInset = .zero
                $0.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.55, height: 250.0)
                $0.scrollDirection = .horizontal
            }
        }
    }
    
    fileprivate func share(post: RedditPost) {
        guard let url = URL(string: post.url) else { return }
        UIActivityViewController(activityItems: [url], applicationActivities: nil).do {
            $0.excludedActivityTypes = [UIActivityType.assignToContact, .airDrop, .saveToCameraRoll]
            $0.title = post.title
            present($0, animated: true, completion: nil)
        }
    }
    
    fileprivate func more(post: RedditPost) {
        let actionSheet = UIAlertController(title: post.title, message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Ver contenido", style: .default, handler: { [unowned self] _ in
            TOWebViewController(urlString: post.url).do {
                $0.showLoadingBar = true
                self.present(UINavigationController(rootViewController: $0), animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}

extension HomeViewController: UIViewControllerPreviewingDelegate {
    
    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true, completion: nil)
    }

    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
    
        let post = viewModel.posts.value[indexPath.row]
        previewingContext.sourceRect = cell.frame
        
        return UINavigationController(rootViewController: TOWebViewController(urlString: post.url).then {
            $0.showLoadingBar = true
        })
    }
}
