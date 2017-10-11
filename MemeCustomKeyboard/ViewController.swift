//
//  ViewController.swift
//  MemeCustomKeyboard
//
//  Created by GGiOS on 06/01/16.
//  Copyright © 2016 GGiOS
//

import UIKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    // the page control
    @IBOutlet weak var pageControl:UIPageControl!
    
    // the current page
    var currentPage = 0

    // view did load function
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationItem.leftBarButtonItem?.title = ""
    }

    // memory warning event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // collection view method -> number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // change this if you add or delete more pages
        return 8
    }
    
    // collection view method -> cell for row at index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // switch index path row, load a different cell
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCell", for: indexPath)
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCell", for: indexPath)
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirdCell", for: indexPath)
            
            return cell
        }
        else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirdCell", for: indexPath)
            
            return cell
        }
        else if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FifthCell", for: indexPath)
            
            return cell
        }
        else if indexPath.row == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SixthCell", for: indexPath)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeventhCell", for: indexPath)
            
            return cell
        }
    }
    
    // collection view method -> size for item at index path
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    // scroll view method -> scroll view did scroll (used to know when the user navigated to another page)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // using the offset, get the current page
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}

