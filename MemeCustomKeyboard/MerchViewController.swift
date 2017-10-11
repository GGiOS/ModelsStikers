

import UIKit
import StoreKit

   
class MerchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    //  @IBOutlet weak var goToDetail: UIButton!

    //  @IBOutlet var carousel: iCarousel!

    private let tableHeader:EmojiHeaderView! = nil
    
    private let modelCovers = [#imageLiteral(resourceName: "justinamoji1.png"),#imageLiteral(resourceName: "karlaPnk.png"),#imageLiteral(resourceName: "lomoji1.png")]
    private let colors = [UIColor(red: 252/255, green: 29/255, blue: 0/255, alpha: 1),
        UIColor(red: 253/255, green: 190/255, blue: 207/255, alpha: 1),
        UIColor(red: 251/255, green: 135/255, blue: 3/255, alpha: 1)]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // print(StoreContent().getEmojiSets())
        
        // Do any additional setup after loading the view, typically from a nib.
       
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
   
        let restoreButton = UIBarButtonItem(title: "Restore",
                                            style: .plain,
                                            target: self,
                                            action: #selector(MerchViewController.restoreTapped(_:)))
        
        
        navigationItem.rightBarButtonItem = restoreButton

        
        let cellnib = UINib(nibName:String(describing:ProductTableViewCell.self), bundle: nil)
    
        tableView.register(cellnib, forCellReuseIdentifier:String(describing:ProductTableViewCell.self))
     
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        //Hide all lines
        
        tableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint(), size: CGSize.init(width: UIScreen.main.bounds.size.width, height: 0.0001)))
        
        //First thing we need to show the product which we loaded from iTunes connect in order for us to buy it
        
        //In the previous video we used post notification whenever the products are done loading from the server
        
        //Let's add an observer so we get notifed whenever the products get loaded
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SKProductsDidLoadFromiTunes), name: NSNotification.Name.init("SKProductsHaveLoaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.StoreManagerDidPurchaseNonConsumable(notification:)), name: NSNotification.Name.init("DidPurchaseNonConsumableProductNotification"), object: nil)
        
        //We need also to call the function anyway when the view did load in case the products got loaded before our oberver is added
        
        SKProductsDidLoadFromiTunes()
    }
    
    func restoreTapped(_ sender: AnyObject) {
        
        StoreManager.shared.restoreAllPurchases()
    }

    func StoreManagerDidPurchaseNonConsumable(notification:Notification){
        
        guard (notification.userInfo?["id"]) != nil else {
            return
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func SKProductsDidLoadFromiTunes(){
        
        
        //Now we need to update the table since we have the products ready
        
        //We need to use the main thread when updating the UI
        
        DispatchQueue.main.async {
            
       //  self.indicator.stopAnimating()
            
            self.tableView.isHidden = false
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        }

    func didTapCellButton(sender:CustomButton){
        
        let index = sender.index
        
        let product = StoreManager.shared.productsFromStore[index!.row]
        
        StoreManager.shared.buy(product: product)
        
    }
    
    func didTapGoToDetailButton(sender:CustomButton){
       
   let  index = sender.index
        
        //  let product = StoreManager.shared.productsFromStore[index!.row]
      
        switch index!.row  {
        
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "JustinaDetailMerchViewController")
            self.navigationController?.show(viewController, sender: (Any).self)
        case 1:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "DetailMerchViewController" )
            self.navigationController?.show(viewController, sender: (Any).self)
        case 2:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier:"LoDetailMerchViewController")
            self.navigationController?.show(viewController, sender: (Any).self)

                   default:
            return
    
        }
        
    }

    // Cell Height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 283
    
    }
    
    //Number of sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Let's feed our table with the number of products
        print(StoreManager.shared.productsFromStore.count)

        return StoreManager.shared.productsFromStore.count
    
    }

    //Cell for row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product  = StoreManager.shared.productsFromStore[indexPath.row]
    
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        
        cell.productName.text = product.localizedTitle
        cell.configureImage(image:modelCovers[indexPath.row])
        cell.modelImage.backgroundColor = colors[indexPath.row]

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        
        cell.productPrice.text = formatter.string(from: product.price)
        cell.goToDetail.index = indexPath
        cell.productStatus.index = indexPath
        cell.productStatus.addTarget(self, action: #selector(self.didTapCellButton(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.goToDetail.addTarget(self, action: #selector(self.didTapGoToDetailButton(sender:)), for: UIControlEvents.touchUpInside)
        
        //Let's change the button from Buy to Purchased and change the color as well when the item is already purchased
        
        if StoreManager.shared.isPurchased(id: product.productIdentifier){
            
            cell.productStatus.setTitle("Purchased", for: .normal)
            cell.productStatus.setTitleColor(UIColor.green, for: .normal)
        }
        
        return cell
    }
    
    @IBAction func showDetails(_ sender: Any) {
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"DetailMerchViewController")
        self.navigationController?.show(viewController, sender: (Any).self)

    }
 
    @IBAction func showDetail(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"DetailMerchViewController")
        self.navigationController?.show(viewController, sender: (Any).self)

    }
    
    
}



