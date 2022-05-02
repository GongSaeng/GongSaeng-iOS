//
//  Constant.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/03.
//

import UIKit

public let topPadding = UIApplication.shared.connectedScenes
    .filter { $0.activationState == .foregroundActive }
    .map { $0 as? UIWindowScene }
    .compactMap { $0 }
    .first?.windows
    .filter { $0.isKeyWindow }.first
    .map { $0.safeAreaInsets.top } ?? 0

public let bottomPadding = UIApplication.shared.connectedScenes
    .filter { $0.activationState == .foregroundActive }
    .map { $0 as? UIWindowScene }
    .compactMap { $0 }
    .first?.windows
    .filter { $0.isKeyWindow }.first
    .map { $0.safeAreaInsets.bottom } ?? 0

public let SERVER_URL: String = "http://3.143.245.81:2222"
public let SERVER_IMAGE_URL: String = "\(SERVER_URL)/image/get_image?image_url="
public let TEST_IMAGE1_URL: String = "https://firebasestorage.googleapis.com/v0/b/authwebmail-d73ae.appspot.com/o/IMG_3524.JPG?alt=media&token=d020e96c-e9be-455b-97e5-70f003577abc"
public let TEST_IMAGE2_URL: String = "https://firebasestorage.googleapis.com/v0/b/authwebmail-d73ae.appspot.com/o/images.jpeg?alt=media&token=8efdc1e3-4c0c-4c28-9424-ffb5dbbd66db"
public let TEST_IMAGE3_URL: String = "https://firebasestorage.googleapis.com/v0/b/authwebmail-d73ae.appspot.com/o/8a7aa7b2cc1c8658726cc7a2df93418f_Kthlez4CFNiI72tb12Chqdw.jpg?alt=media&token=1ca022f4-0ed6-4799-b6ca-7a842a98b279"
public let TEST_IMAGE4_URL: String = "https://firebasestorage.googleapis.com/v0/b/authwebmail-d73ae.appspot.com/o/IMG_3317.jpeg?alt=media&token=0bb5a5a1-444e-4b68-bf0e-dea567a51c2a"
public let TEST_IMAGE5_URL: String = "https://firebasestorage.googleapis.com/v0/b/authwebmail-d73ae.appspot.com/o/IMG_3520.jpeg?alt=media&token=1de6dc6c-f48a-469a-892b-6f938ea8386e"
public let TEST_IMAGE6_URL: String = "https://firebasestorage.googleapis.com/v0/b/authwebmail-d73ae.appspot.com/o/IMG_3377.jpeg?alt=media&token=60ebed4b-fc0f-4b45-a3ee-36e41b5ac746"
