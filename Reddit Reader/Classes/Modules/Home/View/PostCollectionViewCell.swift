//
//  PostCollectionViewCell.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/22/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel:              UILabel!
    @IBOutlet private weak var authorLabel:             UILabel!
    @IBOutlet private weak var positionLabel:           UILabel!
    @IBOutlet private weak var scoreLabel:              UILabel!
    @IBOutlet private weak var timeAgoLabel:            UILabel!
    @IBOutlet private weak var commentsLabel:           UILabel!
    @IBOutlet private weak var imageView:               UIImageView!
    @IBOutlet private weak var activityIndicatorView:   UIActivityIndicatorView!
    
    @IBOutlet fileprivate weak var shareButton:         UIButton!
    @IBOutlet fileprivate weak var moreButton:          UIButton!
    
    var disposables: RxDisposableReusable!
    var post: RedditPost?
    var position = 1 {
        didSet {
            positionLabel.text = "\(position)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        disposables = RxDisposableReusable(disposeBag)
        titleLabel.preferredMaxLayoutWidth = 280.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if position == 1 {
            topCornerRound(radius: 22.0)
        }
    }

    func configure(withPost post: RedditPost) {
        self.post = post
        titleLabel.text = post.title
        authorLabel.attributedText = NSAttributedString(string: post.author, attributes: [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
        ])
        scoreLabel.text = "\(post.score)"
        positionLabel.text = "\(position)"
        timeAgoLabel.text = post.timeAgo
        commentsLabel.text = "\(post.numComments)"
        imageView.load(urlString: post.thumbnail)
            .subscribe(onCompleted: {
                self.activityIndicatorView.stopAnimating()
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.mask = nil
        imageView.image == nil ?
            activityIndicatorView.startAnimating() :
            activityIndicatorView.stopAnimating()
    }
}

extension Reactive where Base: PostCollectionViewCell {
    
    var sharePost: Observable<RedditPost> {
        guard let post = base.post else { return Observable.never() }
        return base.shareButton.rx.tap.asObservable().map { _ in post }
    }
    
    var morePost: Observable<RedditPost> {
        guard let post = base.post else { return Observable.empty() }
        return base.moreButton.rx.tap.asObservable().map { _ in post }
    }
}
