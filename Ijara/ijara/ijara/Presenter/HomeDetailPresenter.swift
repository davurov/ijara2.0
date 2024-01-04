//
//  HomeDetailPresenter.swift
//  ijara
//
//  Created by Sarvar Qosimov on 04/01/24.
//

import Foundation

protocol HomeDetailPresenterDelegate: AnyObject {
    func getHomeDetailData(id: Int)
    func likedButtonImage(id: Int)
}

class HomeDetailPresenter: HomeDetailPresenterDelegate {
    var view: HomeDetailViewDelegate?
    
    init(view: HomeDetailViewDelegate? = nil) {
        self.view = view
    }
    
    func getHomeDetailData(id: Int) {
        API.getDetailDataByID(id: id) { [self] countryhouseData in
            
            guard let detailData = countryhouseData else { print("can not get data"); return }
            
            view?.setDetailData(detailData: detailData)
        }
    }
    
    func likedButtonImage(id: Int) {
        let isLiked = LikedProducts.likedProducts.isLikedPerform(sevriceType: .house, id: id)
        view?.setLikedButtonImage(imageName: isLiked ? "heart.fill" : "heart")
    }
}
