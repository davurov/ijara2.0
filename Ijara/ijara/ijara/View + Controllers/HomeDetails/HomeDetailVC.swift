//
//  HomeDetailVC.swift
//  ijara
//
//  Created by Abduraxmon on 16/09/23.
//

import UIKit

class HomeDetailVC: UIViewController {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewSafeConst: NSLayoutConstraint!
    @IBOutlet weak var callCont: UIView!
    
    var previousContentOffset: CGFloat = 0.0
    var images = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhotoTVC.nib(), forCellReuseIdentifier: PhotoTVC.identifier)
        
        navigationController?.navigationBar.isHidden = true
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let topPadding = window?.safeAreaInsets.top
        tableviewSafeConst.constant = -topPadding!
        
        callCont.addShadowByHand(offset: CGSize(width: 0, height: 0), color: AppColors.customBlack.cgColor, radius: 5, opacity: 0.2)
        callCont.layer.cornerRadius = 20
        callCont.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension HomeDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as! PhotoTVC
            
            cell.houseImgs = images
            
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
          
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            return 50
        }
    }
}

extension HomeDetailVC {
    //TELS WHEATER CELL IN THE SCREEN OR NOT
    func isCellVisible(indexPath: IndexPath) -> Bool {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            return visibleIndexPaths.contains(indexPath)
        }
        return false
    }
}

extension HomeDetailVC: UIScrollViewDelegate {
    //MARK: - TELLS SCROLLED UP OR DAWN
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = scrollView.contentOffset.y
        //WORKES WHEN WHEN SWIPED DAWN AND NOT 0 CELL IS NOT ON SCREEN
        if currentContentOffset > previousContentOffset && !navView.isHidden && !isCellVisible(indexPath: IndexPath(row: 0, section: 0)) {
            // IF SCROLLED DAWN IT HIDES VIEW
            UIView.animate(withDuration: 0.3) {
                self.navView.alpha = 0.0
            }
            print("Scrolling down")
        } else if currentContentOffset < previousContentOffset && (navView.alpha == 0 || isCellVisible(indexPath: IndexPath(row: 0, section: 0))) {
            //SHOWS NAVVIEW BUT COLOR IS CLEAR
            if !isCellVisible(indexPath: IndexPath(row: 0, section: 0))  {
                navView.backgroundColor = AppColors.mainColor
            } else {
                //SHOWS NAVVIEW BUT COLOR IS MAIN COLOR
                UIView.transition(with: navView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.navView.backgroundColor = .clear
                }, completion: nil)
            }
            UIView.animate(withDuration: 0.3) {
                self.navView.alpha = 1.0
            }
            
            print("Scrolling up")
        }
        
        previousContentOffset = currentContentOffset
    }
}
