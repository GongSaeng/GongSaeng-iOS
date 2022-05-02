//
//  ThunderDetail2HeaderViewModel.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/03/30.
//

import Foundation
import RxSwift
import RxCocoa

final class ThunderDetail2HeaderViewModel {
    private let disposeBag = DisposeBag()
    
    let thunderData = PublishSubject<ThunderDetail>()
    let openMapButtonTapped = PublishRelay<Void>()
    
    // Output
    let title: Driver<String>
    let writerImageURL: Driver<URL?>
    let writerNickname: Driver<String>
    let uploadedTime: Driver<String>
    
    let meetingTime: Driver<String>
    let placeName: Driver<String>
    let placeURL = BehaviorRelay<URL?>(value: nil)
    let totalNumText: Driver<String>
    let contents: Driver<String>
    let numOfCommentsText: Driver<String>
    
    let openMap: Driver<URL?>
    
    init() {
        self.title = thunderData
            .map { $0.title }
            .asDriver(onErrorJustReturn: "")
        
        self.writerImageURL = thunderData
            .map {
                $0.writerImageFilename.flatMap { URL(string: $0) }
            }
            .asDriver(onErrorJustReturn: nil)
        
        self.writerNickname = thunderData
            .map { $0.writerNickname }
            .asDriver(onErrorJustReturn: "")
        
        self.uploadedTime = thunderData
            .map { $0.uploadedTime.toAnotherDateString(form: "M월 d일 HH:mm") ?? "" }
            .asDriver(onErrorJustReturn: "")
        
        self.meetingTime = thunderData
            .map { $0.meetingTime
                .toAnotherDateString(form: "M월 d일 (E) a h:mm") ?? "" }
            .asDriver(onErrorJustReturn: "")
        
        self.placeName = thunderData
            .map { $0.placeName }
            .asDriver(onErrorJustReturn: "")
        
        thunderData
            .map { URL(string: $0.placeURL) }
            .bind(to: placeURL)
            .disposed(by: disposeBag)
            
       
        self.totalNumText = thunderData
            .map { "\($0.totalNum)명" }
            .asDriver(onErrorJustReturn: "")
        
        self.contents = thunderData
            .map { $0.contents }
            .asDriver(onErrorJustReturn: "")
        
        self.numOfCommentsText = thunderData
            .map { "댓글 \($0.numberOfComments)" }
            .asDriver(onErrorJustReturn: "")
        
        self.openMap = openMapButtonTapped
            .withLatestFrom(placeURL)
            .asDriver(onErrorJustReturn: nil)
    }
}
