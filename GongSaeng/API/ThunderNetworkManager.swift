//
//  ThunderNetworkManager.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/02/28.
//

import UIKit

let exampleThunderDetail = ThunderDetail(
    postingImagesFilename: [TEST_IMAGE2_URL, TEST_IMAGE3_URL, TEST_IMAGE1_URL],
    title: "같이 코노가요 가나다라마바사아자차카타파하 글자길이 테스트 2줄은 어떻게 보이나 3줄은 어떻게 보이려나",
    writerImageFilename: TEST_IMAGE4_URL,
    writerId: "jdc0407",
    writerNickname: "네잎클로버",
    uploadedTime: "2022-03-02 13:35:31",
    meetingTime: "2022-03-08 19:00:00",
    placeName: "레드노래연습장 부산대점",
    address: "부산 금정구 금강로 271",
    placeURL: "http://place.map.kakao.com/12421917",
    totalNum: 6,
    contents: "저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~",
    participantImageURLs: [TEST_IMAGE4_URL, TEST_IMAGE5_URL, TEST_IMAGE6_URL],
    participantIDs: ["jdc0407", "123", "1234"],
    status: 1,
    numberOfComments: 15)

final class ThunderNetworkManager {
    static func fetchThunderDetail(index: Int, completion: @escaping(ThunderDetail) -> Void) {
        // 네트워크 로직
        completion(exampleThunderDetail) // 임시 더미데이터
    }
}
