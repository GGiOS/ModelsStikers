//
//  KeyboardViewController.swift
//  Meme Keyboard
//
//  Created by GGiOS on 06/01/16.
//  Copyright © 2016 GGiOS
//

import UIKit

class CustomKeyboardViewController: UIInputViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
    var defaultKeyboardView:UIView!
    
  //  @IBOutlet weak var changeButton:UIButton!
    
    // the collection view for the memes
    var memesCollectionView: UICollectionView!
    // the collection view for the categories
    var categoriesCollectionView: UICollectionView!
    // the back button
    var backButton: UIButton!
    // the top label
    var topLabel: UILabel!
    
    // control if need to show caps
    var capsOn = false
    
    private let storage = StoreContent()
    
    // the memes array
    private var memeArray:[[UIImage]] = []
    
    private var sections:[UIImage] = []
    
    private var items:[UIImage] = []
    
    // the current index
    var currentIndex = 0
    
    // the current index
    var memesIndex = 0
    
    // a default function for updating constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
    
        memeArray = storage.getEmojiSets()
        sections = storage.getSliderMenuIcons()
        
        // Perform custom UI setup here
        
       if isOpenAccessGranted() {
            // initMemes the memes
        
            // init the custom keyboard
                self.initKeyboard()
                //init gold keyboard
                self.initDefaultKeyboard() //GOLD
   
    }
        charSet.isHidden = true
        shiftStatus = 1
    }
    
    func initMemesWithTag(object:Notification)
    {
        print(object)
        if let content = object.object as? StoreContent {
            print(content)
        }
    }
    
    // memory warning event
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    // event called when the text is about to change
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    // event called when the text did change
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
//################################################################################################
    
    //MARK: init the default keyboard
    
//################################################################################################
    
    func initDefaultKeyboard() {
        // load the xib
        let defaultNib = UINib(nibName: "NewKeyboard", bundle: nil)
        
        // instantiate the view
        defaultKeyboardView = defaultNib.instantiate(withOwner: self, options: nil)[0] as? UIView
        
        // set this value to false in order to get the constraints working
        defaultKeyboardView!.translatesAutoresizingMaskIntoConstraints = false
        
        // add the interface to the main view
        view.addSubview(defaultKeyboardView)
    
        defaultKeyboardView.isHidden = true
        
        //################################################################################################
        
        //MARK: default keyboard create the constraints
        
        //##############################################################################################
        
        // create the constraints
       
        // top constraint
        let topConstraint = NSLayoutConstraint(item: defaultKeyboardView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        // add the top constraint
        view.addConstraint(topConstraint)
        
        // leading constraint
        let leadingConstraint = NSLayoutConstraint(item: defaultKeyboardView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        // add the leading constraint
        view.addConstraint(leadingConstraint)
        
        // trailing constraint
        let trailingConstraint = NSLayoutConstraint(item: defaultKeyboardView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        // add the trailing constraint
        view.addConstraint(trailingConstraint)
//
        // copy the background color
        view.backgroundColor = defaultKeyboardView.backgroundColor
        
        // height constraint
        let defaultkeyboardHeightConstraint = NSLayoutConstraint (item: defaultKeyboardView,
                                                                      attribute: NSLayoutAttribute.height,
                                                                      relatedBy: NSLayoutRelation.equal,
                                                                      toItem: nil,
                                                                      attribute: NSLayoutAttribute.notAnAttribute,
                                                                      multiplier: 1,
                                                                      constant: 190)
        
        // add the height constraint
        defaultKeyboardView.addConstraint(defaultkeyboardHeightConstraint)
        
  //      changeButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: UIControlEvents.touchUpInside)
    }
    
    // add letter
    @IBAction func addLetter(_ sender:UIButton) {
       self.textDocumentProxy.insertText((sender.titleLabel?.text)!)
    }
    
    // add space
    @IBAction func addSpace(_ sender:UIButton) {
        self.textDocumentProxy.insertText(" ")
    }
    
    // delete
    @IBAction func deleteLetter(_ sender:UIButton) {
        self.textDocumentProxy.deleteBackward()
    }
    
    // toggle caps
    @IBAction func toggleCaps(_ sender:UIButton) {
        capsOn = !capsOn
        for v:UIView in self.view.subviews {
            for v2:UIView in v.subviews {
                for v3:UIView in v2.subviews {
                    for v4:UIView in v3.subviews {
                        if v4 is UIButton && v4.tag < 10 {
                            let word = ((capsOn) ? (v4 as! UIButton).currentTitle?.uppercased() : (v4 as! UIButton).currentTitle?.lowercased())
                            (v4 as! UIButton).setTitle(word, for: UIControlState())
                            (v4 as! UIButton).setTitle(word, for: .highlighted)
                            (v4 as! UIButton).setTitle(word, for: .selected)
                        }
                    }
                }
            }
        }
    }
    
    // return action
    @IBAction func returnAction(_ sender:UIButton) {
        dismissKeyboard()
    }
    
    // init the keyboard
    func initKeyboard() {
        // init the top label
        initTopLabel()
        
        // init the back button
        initBackButton()
        
        // init the categories collection view
        initCategoriesCollection()
        
        // init the memes collection view
        initMemesCollection()
    }
    
    // init the top label
    func initTopLabel() {
        // create the label
        topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
        
        // change the background color
        topLabel.backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        
        // set the default text
        topLabel.text = "Tap an emoji - hold on the input to paste it"
        
        // change the font
        topLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        
        // change the text color
        topLabel.textColor = UIColor.white
        
        // set the text alignment to center
        topLabel.textAlignment = NSTextAlignment.center
        
        // set the number of lines to 1
        topLabel.numberOfLines = 1
        
        // set the minimum scale factor to 0.5 and adjusts font size to fit width to true in order to get the label autoshrinked in the smaller devices
        topLabel.minimumScaleFactor = 0.5
        topLabel.adjustsFontSizeToFitWidth = true
        
        // set this value to false in order to get the constraints working
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // add the top label to the main view
        view.addSubview(topLabel)
        
        
        // create the constraints
        
        // top constraint
        let topLabelTopConstraint = NSLayoutConstraint(item: topLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        // add the top constraint
        view.addConstraint(topLabelTopConstraint)
        
        // leading constraint
        let topLabelLeadingConstraint = NSLayoutConstraint(item: topLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        // add the leading constraint
        view.addConstraint(topLabelLeadingConstraint)
        
        // trailing constraint
        let topLabelTrailingConstraint = NSLayoutConstraint(item: topLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        // add the trailing constraint
        view.addConstraint(topLabelTrailingConstraint)
        
        // height constraint
        let topLabelHeightConstraint = NSLayoutConstraint (item: topLabel,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: 30)
        
        // add the height constraint
        topLabel.addConstraint(topLabelHeightConstraint)
    }
    
    // init the back button
    func initBackButton() {
        // create the back button and set it frame to 30x30 points
        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        // set its background color
        backButton.backgroundColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        
        // set the new image and image insets to get some space
        backButton.setImage(#imageLiteral(resourceName: "world.png"), for: UIControlState())
        backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        // set this value to false in order to get the constraints working
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        // add an action to the button (the go back to default keyboard action)
        backButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: UIControlEvents.touchUpInside)
        
        // add the back button to the main view
        view.addSubview(backButton)
    
        // create the constraints
        
        // leading constraint
        let backButtonLeadingConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        // add the leading constraint
        view.addConstraint(backButtonLeadingConstraint)
        
        // bottom constraint
        let backButtonBottomConstraint = NSLayoutConstraint(item: backButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        // add the bottom constraint
        view.addConstraint(backButtonBottomConstraint)
        
        // width constraint
        let backButtonWidthConstraint = NSLayoutConstraint (item: backButton,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: 44)
        
        // add the width constraint
        backButton.addConstraint(backButtonWidthConstraint)
        
        // height constraint
        let backButtonHeightConstraint = NSLayoutConstraint (item: backButton,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: 44)
        
        // add the height constraint
        backButton.addConstraint(backButtonHeightConstraint)
    }
    
    // init the categories collection view
    func initCategoriesCollection() {
        // create a collection view flow layout
        let categoriesLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // set the scroll direction to horizontal
        categoriesLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        // set the section inset. 8 points on the sides to get some space
        categoriesLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        // create the collection view
        categoriesCollectionView = UICollectionView(frame: CGRect(x: 45, y: 0, width: 290, height: 45), collectionViewLayout: categoriesLayout)
        
        // register the nib for the custom collection view cell
        categoriesCollectionView.register(UINib(nibName:"MemesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // change the background color
        categoriesCollectionView.backgroundColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1.0)
        
        // set this value to false in order to get the constraints working
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // set the delegate and the data source
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        // add the categories collection view to the main view
        view.addSubview(categoriesCollectionView)
        
        
        // create the constraints
        
        // leading constraint
        let categoriesCollectionViewLeadingConstraint = NSLayoutConstraint(item: categoriesCollectionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: backButton, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        // add the leading constraint
        view.addConstraint(categoriesCollectionViewLeadingConstraint)
        
        // bottom constraint
        let categoriesCollectionViewBottomConstraint = NSLayoutConstraint(item: categoriesCollectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        // add the bottom constraint
        view.addConstraint(categoriesCollectionViewBottomConstraint)
        
        // trailing constraint
        let categoriesCollectionViewTrailingConstraint = NSLayoutConstraint(item: categoriesCollectionView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        // set the priority to less than 1000 so it works correctly
        categoriesCollectionViewTrailingConstraint.priority = 999
        
        // add the trailing constraint
        view.addConstraint(categoriesCollectionViewTrailingConstraint)
        
        // height constraint
        let categoriesCollectionViewHeightConstraint = NSLayoutConstraint (item: categoriesCollectionView,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: 45)
        
        // add the height constraint
        categoriesCollectionView.addConstraint(categoriesCollectionViewHeightConstraint)
    }
    
    // init the memes collection view
    func initMemesCollection() {
        // create a collection view flow layout
        let memesLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // set the section inset. 0 points to get all the cells together
        memesLayout.sectionInset = UIEdgeInsets(top: 0, left:1, bottom: 0, right: 1)
        
        // set the minimum interitem spaceing. 0 points to get all the cells together
        memesLayout.minimumInteritemSpacing = 1
        
        // set the minimum line spacing. 0 points to get all the cells together
        memesLayout.minimumLineSpacing = 0
        
        // create the collection view
        memesCollectionView = UICollectionView(frame: CGRect(x: 0, y: 22, width: 330, height: 120), collectionViewLayout: memesLayout)
        
        // register the nib for the custom collection view cell
       
        memesCollectionView.register(UINib(nibName: "MemesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // set its background color
        memesCollectionView.backgroundColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        
        // set this value to false in order to get the constraints working
        memesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // set the delegate and data source
        memesCollectionView.delegate = self
        memesCollectionView.dataSource = self
        
        // add the collection to the main view
        view.addSubview(memesCollectionView)
        
        
        // create the constraints
        
        // leading constraint
        let memesCollectionViewLeadingConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        // add the leading constraint
        view.addConstraint(memesCollectionViewLeadingConstraint)
        
        // bottom constraint
        let memesCollectionViewBottomConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: categoriesCollectionView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        // set the priority to less than 1000 so it works correctly
        memesCollectionViewBottomConstraint.priority = 999
        
        // add the bottom constraint
        view.addConstraint(memesCollectionViewBottomConstraint)
        
        // trailing constraint
        let memesCollectionViewTrailingConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        // add the trailing constraint
        view.addConstraint(memesCollectionViewTrailingConstraint)
        
        // top constraint
        let memesCollectionViewTopConstraint = NSLayoutConstraint(item: memesCollectionView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        // set the priority to less than 1000 so it works correctly
        memesCollectionViewTopConstraint.priority = 999
        
        
        // add the top constraint
        view.addConstraint(memesCollectionViewTopConstraint)
        
        
        // height constraint
        let memesCollectionViewHeightConstraint = NSLayoutConstraint (item: memesCollectionView,
                                                           attribute: NSLayoutAttribute.height,
                                                           relatedBy: NSLayoutRelation.equal,
                                                           toItem: nil,
                                                           attribute: NSLayoutAttribute.notAnAttribute,
                                                           multiplier: 1,
                                                           constant: 160)
        
        // add the height constraint
        memesCollectionView.addConstraint(memesCollectionViewHeightConstraint)
    
    }
    
    // add the selected image to the pasteboard
    func addImage(imageName: String) {
        
        // check if the name of the image has the correct format. if not, don't load the image
            let name = imageName
            let format = "png"
            // get the URL
            let imageURL = Bundle.main.path(forResource: name, ofType: format)
            // create the image data
            let data = try? Data(contentsOf: URL(fileURLWithPath: imageURL!))
            
            // set the image data to the pasteboard
            UIPasteboard.general.items = []
            UIPasteboard.general.setData(data!, forPasteboardType: "public.png")
    }
    
    // collection view method -> number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int {
        // if collection view is the memes collection
        if collectionView.isEqual(memesCollectionView) {
            // return the count of the selected category
            
            print(memeArray[memesIndex].count)
            return memeArray[memesIndex].count
        }
        // if collec21tion view is the categories collection
        else if collectionView.isEqual(categoriesCollectionView) {
            // return the number of categories
            print(sections.count)
            return sections.count
            
        }
        // else, default value
        else {
            return 0
        }
    }
    
    // collection view method -> cell for row at index path
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create a collection view
        let cell:UICollectionViewCell!
        
        // if collection view is the memes collection
        if collectionView.isEqual(memesCollectionView) {
            // init the custom collection view cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MemesCollectionViewCell
            
            (cell.viewWithTag(1) as! UIImageView).image = memeArray[memesIndex][indexPath.row]
            
            // return the cell
            return cell
        }
        // if collection view is the categories collection
        else if collectionView.isEqual(categoriesCollectionView) {
            // init the custom collection view cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MemesCollectionViewCell
            
            // set the category image (we pick the first image of the category)
            (cell.viewWithTag(1) as! UIImageView).image = sections[indexPath.row]
            
            // set a tag to use it later (we use the offset to avoid issues)
            cell.tag = indexPath.row + 20000
            
            // set a corner radius with a value of the half of the widht and height to get a circle
            (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 15
            
            // if selected
            if currentIndex == indexPath.row {
                // alpha to 1
                cell.alpha = 1.0
            }
            // else
            else {
                // alpha to 0.4
                cell.alpha = 0.4
            }
            
            // return the cell
            return cell
        }
        // else, default value
        else {
            // create an empty cell
            cell = UICollectionViewCell()
            
            // return the cell
            return cell
        }
    }
    
    // collection view method -> size for item at index path
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // if collection view is the memes collection
        if collectionView.isEqual(memesCollectionView) {
            // create a size of a fifth of the width of the main size and make it square
            let cellSize = CGSize(width: collectionView.bounds.width/8, height: collectionView.bounds.width/8)
            
            // return the new size
            return cellSize
        }
        // if collection view is the categories collection
        else if collectionView.isEqual(categoriesCollectionView) {
            // create a size of 30x30 points
            let cellSize = CGSize(width: 30, height: 30)
            
            // return the new size
            return cellSize
        }
        // else return default
        else {
            // return the new size
            return CGSize.zero
        }
    }
    
    // collection view method -> did select item at index path
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        // if collection view is the memes collection
        if collectionView.isEqual(memesCollectionView) {
            print(storage.imageSets[memesIndex].name)
            // add the selected image
            addImage(imageName: storage.imageSets[memesIndex].name + "\(indexPath.row + 1)" )
            
            
            // set a new text to inform the user
   
            topLabel.text = "Now, hold on the input and tap paste!"
        }
        // if collection view is the categories collection
        else if collectionView.isEqual(categoriesCollectionView) {
            // get the selected cell
            memesIndex = indexPath.row
            let cell = collectionView.cellForItem(at: indexPath)
            
            // get the index and set i to the current index
            currentIndex = cell!.tag - 20000
            defaultKeyboardView.isHidden = true
            
            if(memesIndex == memeArray.count - 1) {
                view.bringSubview(toFront: defaultKeyboardView)
                defaultKeyboardView.isHidden = false
            }
   
            // reload data on both collection views
            categoriesCollectionView.reloadData()
            memesCollectionView.reloadData()
        }
    }
    
    // check for full access
   func isOpenAccessGranted() -> Bool {
       return UIPasteboard.general.isKind(of: UIPasteboard.self)
    }
    
    //MARK - NEW KEYBOARD
    
    ////////////////////////////////////////////////////////////////
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var row1: UIStackView!
    @IBOutlet weak var row2: UIStackView!
    @IBOutlet weak var row3: UIStackView!
    @IBOutlet weak var row4: UIStackView!
    
    @IBOutlet weak var numberSet: UIStackView!
    @IBOutlet weak var charSet: UIStackView!
    
    
    @IBOutlet weak var shiftButton: UIButton!
    var shiftStatus: Int! //0 - off, 1 - on, 2 - caps lock
    
    fileprivate var proxy: UITextDocumentProxy {
        return textDocumentProxy
    }
    
    @IBAction func nextKeyboardPressed(_ sender: UIButton) {
        advanceToNextInputMode()
    }
    
    @IBAction func shiftPressed(_ sender: UIButton) {
        shiftStatus = shiftStatus > 0 ? 0 : 1
        
        shiftChange(row1)
        shiftChange(row2)
        shiftChange(row3)
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        let string = sender.titleLabel!.text
        proxy.insertText("\(string!)")
        
        if shiftStatus == 1 {
            shiftPressed(self.shiftButton)
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            sender.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: { (_) -> Void in
            sender.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        })
    }
    
    @IBAction func charSetPressed(_ sender: UIButton) {
        if sender.titleLabel!.text == "!@#" {
            numberSet.isHidden = true
            charSet.isHidden = false
            sender.setTitle("123", for: UIControlState())
        } else {
            numberSet.isHidden = false
            charSet.isHidden = true
            sender.setTitle("!@#", for: UIControlState())
        }
    }
    
    @IBAction func backSpacePressed(_ sender: UIButton) {
        proxy.deleteBackward()
    }
    
    @IBAction func returnPressed(_ sender: UIButton) {
        proxy.insertText("\n")
    }
    
    @IBAction func spacePressed(_ sender: UIButton) {
        proxy.insertText(" ")
    }
    
    @IBAction func shiftDoubleTapped(_ sender: UITapGestureRecognizer) {
        shiftStatus = 2
        shiftChange(row1)
        shiftChange(row2)
        shiftChange(row3)
    }
    
    @IBAction func shiftTrippleTapped(_ sender: UITapGestureRecognizer) {
        shiftStatus = 0
        shiftPressed(self.shiftButton)
    }
    
    func shiftChange(_ containerView: UIStackView) {
        for view in containerView.subviews {
            if let button = view as? UIButton {
                let buttonTitle = button.titleLabel!.text
                if shiftStatus == 0 {
                    let text = buttonTitle!.lowercased()
                    button.setTitle("\(text)", for: UIControlState())
                } else {
                    let text = buttonTitle!.uppercased()
                    button.setTitle("\(text)", for: UIControlState())
                }
            }
        }
    }
    
    deinit {
       // let storeManager = StoreManager.shared
        NotificationCenter().removeObserver(self)
    }
}
