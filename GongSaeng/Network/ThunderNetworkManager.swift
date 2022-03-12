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
    participantsProfile: [
        Profile(profileImageURL: TEST_IMAGE4_URL,
                id: "jdc0407",
                nickname: "네잎클로버",
                job: "전기공학과",
                email: "nupic7@pusan.ac.kr",
                introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
        Profile(profileImageURL: TEST_IMAGE5_URL,
                id: "jdc1234",
                nickname: "코로나확진자",
                job: "신소재공학과",
                email: "oluye7@pusan.ac.kr",
                introduce: "신소재공학과 새내기에요~! "),
        Profile(profileImageURL: TEST_IMAGE6_URL,
                id: "jdc5678",
                nickname: "자가격리자",
                job: "철학과",
                email: "diresty@pusan.ac.kr",
                introduce: "16 화석이에요~~")
    ],
    status: 1,
    numberOfComments: 15)

let exampleMyThunders: [MyThunder] = [
    MyThunder(
        postIndex: 0,
        postingImageFilename: TEST_IMAGE2_URL,
        title: "같이 코노가요!",
        meetingTime: "2022-03-05 17:00:00",
        placeName: "레드노래연습장 부산대점",
        address: "부산 금정구 금강로 271",
        placeURL: "http://place.map.kakao.com/12421917",
        totalNum: 6,
        contents: "저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다! 저녁에 코인 노래방 같이 가실분들 구합니다! 장르, 실력 상관없이 같이 재밌게 노실분들 ~~ 저녁에 코인 노래방 같이 가실분들 구합니다!",
        participantsProfile: [
            Profile(profileImageURL: TEST_IMAGE4_URL,
                    id: "jdc0407",
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
            Profile(profileImageURL: TEST_IMAGE5_URL,
                    id: "jdc1234",
                    nickname: "코로나확진자",
                    job: "신소재공학과",
                    email: "oluye7@pusan.ac.kr",
                    introduce: "신소재공학과 새내기에요~! "),
            Profile(profileImageURL: TEST_IMAGE6_URL,
                    id: "jdc5678",
                    nickname: "자가격리자",
                    job: "철학과",
                    email: "diresty@pusan.ac.kr",
                    introduce: "16 화석이에요~~")
        ],
        status: 1,
        numberOfComments: 15),
    MyThunder(
        postIndex: 1,
        postingImageFilename: TEST_IMAGE3_URL,
        title: "보드게임 할 사람~~",
        meetingTime: "2022-03-06 17:30:00",
        placeName: "두기 보드게임",
        address: "부산 금정구 금강로 265",
        placeURL: "http://place.map.kakao.com/19934212",
        totalNum: 4,
        contents: "보드게임 같이 하실 분들~ 잘못하지만 좋아해서 실력보단 재미있게 같이하실 분들 찾고 있어요!",
        participantsProfile: [
            Profile(profileImageURL: TEST_IMAGE4_URL,
                    id: "jdc0407",
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~"),
            Profile(profileImageURL: TEST_IMAGE6_URL,
                    id: "jdc5678",
                    nickname: "자가격리자",
                    job: "철학과",
                    email: "diresty@pusan.ac.kr",
                    introduce: "16 화석이에요~~")
        ],
        status: 1,
        numberOfComments: 30),
    MyThunder(
        postIndex: 2,
        postingImageFilename: TEST_IMAGE1_URL,
        title: "간단하게 맥주마셔요~",
        meetingTime: "2022-03-07 18:00:00",
        placeName: "온천천",
        address: "부산 금정구 부곡동",
        placeURL: "http://place.map.kakao.com/25728616",
        totalNum: 4,
        contents: "온천천에서 산책하면서 가볍게 맥주하실 분들 찾고있습니다!",
        participantsProfile: [
            Profile(profileImageURL: TEST_IMAGE4_URL,
                    id: "jdc0407",
                    nickname: "네잎클로버",
                    job: "전기공학과",
                    email: "nupic7@pusan.ac.kr",
                    introduce: "반갑습니다~ iOS 앱개발자 입니다~~ 잘 부탁드려요!\n공생공생 개발중입니다~~")
        ],
        status: 1,
        numberOfComments: 10)
]

final class ThunderNetworkManager {
    static func fetchThunderDetail(index: Int, completion: @escaping(ThunderDetail) -> Void) {
        // 네트워크 로직
        completion(exampleThunderDetail) // 임시 더미데이터
    }
}
