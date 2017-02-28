//
//  HomeViewModel.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/27/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    
    let posts = Variable<[RedditPost]>([])
    fileprivate let allPosts = Variable<[RedditPost]>([])
    fileprivate let pageSize = 5
    let currnetPage = Variable(0)
    
    let leftPageAction = PublishSubject<Void>()
    let rightPageAction = PublishSubject<Void>()
    
    var redditPosts: Driver<[RedditPost]>!
    var leftPageEnabled: Driver<Bool>!
    var rightPageEnabled: Driver<Bool>!
    
    convenience init(apiPosts: APIPosts) {
        self.init()
        
        leftPageAction
            .subscribe(onNext: { [unowned self] in
                self.currnetPage.value -= 1
            })
            .addDisposableTo(disposeBag)
        
        rightPageAction
            .subscribe(onNext: { [unowned self] in
                self.currnetPage.value += 1
            })
            .addDisposableTo(disposeBag)
        
        leftPageEnabled = currnetPage.asDriver()
            .map { $0 > 0 }
        
        rightPageEnabled = Driver.combineLatest(currnetPage.asDriver(), allPosts.asDriver()) { ($0, $1) }
            .map { page, posts in
                ((page + 1) * self.pageSize) < posts.count
            }
        
        apiPosts.top()
            .map {
                $0.posts.enumerated().map { index, post in
                    let copy = post.with {
                        $0.position = index
                    }
                    return copy
                }
            }
            .bindTo(allPosts)
            .addDisposableTo(disposeBag)
        
        Observable.combineLatest(currnetPage.asObservable(), allPosts.asObservable()) { _, posts in posts }
            .map { [weak self] posts in
                guard let welf = self else { return [] }
                return posts.enumerated()
                    .filter { index, _ in
                        (index >= (welf.currnetPage.value * welf.pageSize)) && (index < ((welf.currnetPage.value + 1) * welf.pageSize))
                    }
                    .map { _, posts in posts }
            }
            .bindTo(posts)
            .addDisposableTo(disposeBag)
        
        redditPosts = posts.asDriver()
    }
    
}
