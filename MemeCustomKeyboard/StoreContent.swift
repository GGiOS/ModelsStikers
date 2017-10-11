//
//  StoreContent.swift
//  LuxejiCustomKeyboard
//
//  Created by GG on 30.04.17.
//  Copyright © 2017 GGiOS
//

import Foundation
import UIKit

struct ImgSet {

    let name:String
    let count:Int
    let prodID:String
    
    static let sets = [
        ImgSet(name:"box",count:15,prodID:""),
        ImgSet(name:"emo",count:20,prodID:""),
        ImgSet(name:"med",count:14,prodID:""),
        ImgSet(name:"yoga",count:18,prodID:""),
        ImgSet(name:"alifts",count:28,prodID:""),
        ImgSet(name:"food",count:27,prodID:""),
        ImgSet(name:"gym",count:20,prodID:""),
        // ImgSet(name:"karla",count:10,prodID:"")
    ]
    
    static let purchasebleImSets = [
        ImgSet (name:"karla",
                count:10,
                prodID:"KarlaJaraCollection"),
        ImgSet (name:"lomoji",
                count:6,
            prodID:"LoCollection"),
        ImgSet (name:"justinamoji",
                count:11,
            
                prodID:"JustinaCollection")
        
    
    ]
}

class StoreContent {
    
    static let keyboard = "keyboar"
    
    private var storeMan = StoreManager.shared
    
    var imageSets:[ImgSet]
    
    let purchaseIds = ImgSet.purchasebleImSets.map{$0.prodID}

    //MARK: - StoredContentID
    
    init() {
        imageSets = ImgSet.sets
        updateImgSets()
        storeMan.purchasableProductsIds = Set(purchaseIds)
    }
    
    func getEmojiSets() -> [[UIImage]]
    {
        var defaultSet:[[UIImage]] = []
        
        imageSets.forEach { imageSet in
                var emojiPak:[UIImage] = []
                for i in 1 ... imageSet.count {
                    emojiPak.append(UIImage(named:imageSet.name + "\(i)")!)
                }
                defaultSet.append(emojiPak)
        }
        defaultSet.append([#imageLiteral(resourceName: "keyboar.png")])
        
        return defaultSet
    }
    
    func getSliderMenuIcons() -> [UIImage]
    {
        var imArray:[UIImage] = []
        for item in imageSets {
            let name = item.name + "\(1)"
            imArray.append(UIImage(named: name)!)
        }
        imArray.append(#imageLiteral(resourceName: "keyboar.png"))
        return imArray
    }
    
    func updateImgSets()
    {
        for set in ImgSet.purchasebleImSets
        {
            if (storeMan.isPurchased(id: set.prodID))
            {
                if let set = setByID(setID:set.prodID)
                {
                  //  imageSets.insert(set,at:0)
                     imageSets.append(set)
                }
            }
        }
    }
    
    func setByID(setID:String) -> ImgSet?
    {
        for set in ImgSet.purchasebleImSets {
            if setID == set.prodID {
                return set
            }
        }
        return nil
    }
}
