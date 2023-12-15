//
//  TaxiServiceVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 01/12/23.
//

import UIKit

class TaxiServiceVC: UIViewController {
   
    @IBOutlet weak var recommendedBtn: UIButton!
    
    @IBOutlet weak var cheaperBtn: UIButton!
    
    @IBOutlet weak var expensiveBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var taxiServices: [TaxiDM] = []
    var sortingTaxis: [TaxiDM] = []
    var sortingTaxisID: [Int] = []
    var cars: [TaxiDM] = []
    
    var recommendedCars: [TaxiDM] = []
    var cheaperCars    : [TaxiDM] = []
    var expensiveCars  : [TaxiDM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loader.start()
        
        navigationItem.backButtonTitle = SetLanguage.setLang(type: .taxi)
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        navigationController?.navigationBar.prefersLargeTitles = true
        title = SetLanguage.setLang(type: .taxi)
        
        getAllTaxiServices()
//        var timer: Timer?
//        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { [self] _ in
//            sortTaxiServices(services: getTaxiServices())
//
//            if sortingTaxis.count == 8 {
//                timer?.invalidate()
//                timer = nil
//
//                taxiServices = sortingTaxis
//                setupTableView()
//                setMaxAndMinTaxis()
//                tableView.reloadData()
//                Loader.stop()
//            }
//        })
//        timer?.fire()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func recommendedBtnPressed(_ sender: Any) {
        taxiServices = recommendedCars
        
        clearButtons()
        
        recommendedBtn.backgroundColor = AppColors.mainColor
        recommendedBtn.setTitleColor(.white, for: .normal)
        recommendedBtn.setTitle(" \(SetLanguage.setLang(type: .recommendedCars)) ", for: .normal)
        
        tableView.reloadData()
    }
    
    @IBAction func cheaperBtnPressed(_ sender: Any) {
        taxiServices = cheaperCars
        
        clearButtons()
        
        cheaperBtn.backgroundColor = AppColors.mainColor
        cheaperBtn.setTitleColor(.white, for: .normal)
        cheaperBtn.setTitle(" \(SetLanguage.setLang(type: .cheaperCars)) ", for: .normal)
        
        tableView.reloadData()
    }
    
    @IBAction func expansiveBtnPressed(_ sender: Any) {
        taxiServices = expensiveCars
        
        clearButtons()
        
        expensiveBtn.backgroundColor = AppColors.mainColor
        expensiveBtn.setTitleColor(.white, for: .normal)
        expensiveBtn.setTitle(" \(SetLanguage.setLang(type: .expensiveCars)) ", for: .normal)
        
        tableView.reloadData()
    }
    
    private func setMaxAndMinTaxis(){
        ///(price, id)
        var pricesWithID: [(Int, Int)] = []
        
        taxiServices.forEach { taxi in
            let price = taxi.startingPrice.replacingOccurrences(of: ".", with: "")
            pricesWithID.append((Int(price) ?? 0, taxi.id))
        }
        
        let expensive = SortingPrices.sortByExpensive(pricesWithID).map({$0})
        let cheaper = Array(expensive.reversed())
        
        expensive.forEach { expensiceID in
            guard let expensiveCar = self.findTaxiByID(expensiceID) else { return }
            self.expensiveCars.append(expensiveCar)
        }
        
        cheaper.forEach { cheaperID in
            guard let cheaperCar = self.findTaxiByID(cheaperID) else { return }
            self.cheaperCars.append(cheaperCar)
        }
        
        recommendedCars = taxiServices
    }
    
    private func findTaxiByID(_ id: Int) -> TaxiDM? {
        for taxiService in taxiServices {
            if taxiService.id == id {
                return taxiService
            }
        }
        return nil
    }
    
    
    private func clearButtons(){
        recommendedBtn.backgroundColor = .white
        recommendedBtn.setTitleColor(AppColors.customBlackText, for: .normal)
        recommendedBtn.setTitle(" \(SetLanguage.setLang(type: .recommendedCars)) ", for: .normal)
        
        cheaperBtn.backgroundColor = .white
        cheaperBtn.setTitleColor(AppColors.customBlackText, for: .normal)
        cheaperBtn.setTitle(" \(SetLanguage.setLang(type: .cheaperCars)) ", for: .normal)
        
        expensiveBtn.backgroundColor = .white
        expensiveBtn.setTitleColor(AppColors.customBlackText, for: .normal)
        expensiveBtn.setTitle(" \(SetLanguage.setLang(type: .expensiveCars)) ", for: .normal)
    }
    
    private func getAllTaxiServices() {
        Loader.start()
        
        API.getAllTaxiServices { [weak self] allTaxiServices in
            guard let self = self else { return }
            guard let allTaxiServices = allTaxiServices else { return }
            
            taxiServices = allTaxiServices

            setupTableView()
            setMaxAndMinTaxis()
            tableView.reloadData()
            Loader.stop()
        }
    }
    
    private func sortTaxiServices(services: [TaxiDM]) {
        for taxi in services {
            if taxi.title != "" && !sortingTaxisID.contains(taxi.id) {
                sortingTaxis.append(taxi)
                sortingTaxisID.append(taxi.id)
            }
        }
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaxiServiceTVC.nib(), forCellReuseIdentifier: TaxiServiceTVC.identifire)
    }
    
    private func setupViews(){
        recommendedBtn.backgroundColor = AppColors.mainColor
        recommendedBtn.setTitleColor(.white, for: .normal)
        recommendedBtn.setTitle(" \(SetLanguage.setLang(type: .recommendedCars)) ", for: .normal)
        recommendedBtn.titleLabel?.numberOfLines = 0
        recommendedBtn.layer.borderWidth = 3
        recommendedBtn.layer.borderColor = AppColors.mainColor.cgColor
        recommendedBtn.layer.cornerRadius = 15
        recommendedBtn.clipsToBounds = true
        
        cheaperBtn.backgroundColor = .white
        cheaperBtn.setTitleColor(AppColors.customBlackText, for: .normal)
        cheaperBtn.setTitle(" \(SetLanguage.setLang(type: .cheaperCars)) ", for: .normal)
        cheaperBtn.titleLabel?.numberOfLines = 0
        cheaperBtn.layer.borderWidth = 3
        cheaperBtn.layer.borderColor = AppColors.mainColor.cgColor
        cheaperBtn.layer.cornerRadius = 15
        cheaperBtn.clipsToBounds = true
        
        expensiveBtn.backgroundColor = .white
        expensiveBtn.setTitleColor(AppColors.customBlackText, for: .normal)
        expensiveBtn.setTitle(" \(SetLanguage.setLang(type: .expensiveCars)) ", for: .normal)
        expensiveBtn.titleLabel?.numberOfLines = 0
        expensiveBtn.layer.borderWidth = 3
        expensiveBtn.layer.borderColor = AppColors.mainColor.cgColor
        expensiveBtn.layer.cornerRadius = 15
        expensiveBtn.clipsToBounds = true
    }
    
}

//MARK: UITableViewDataSource
extension TaxiServiceVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taxiServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let taxiCell = tableView.dequeueReusableCell(withIdentifier: TaxiServiceTVC.identifire, for: indexPath) as! TaxiServiceTVC
        
        let currentTaxi = taxiServices[indexPath.row]
        
        taxiCell.updateCell(
            carType: currentTaxi.taxiType,
            passangers: currentTaxi.passengers,
            cost: currentTaxi.startingPrice,
            carImages: currentTaxi.carImages
        )
        
        taxiCell.cellIndex = indexPath.row
        taxiCell.didTappedDelegate = self
        
        return taxiCell
    }
    
}

//MARK: UITableViewDelegate
extension TaxiServiceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = TaxiDetailVC()
        vc.setValues(taxi: taxiServices[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 400
    }
}

//MARK: ShowTaxiDetailProtocol
extension TaxiServiceVC: ShowTaxiDetailProtocol {
    func openTaxiDetail(index: Int) {
        let vc = TaxiDetailVC()
        vc.setValues(taxi: taxiServices[index])
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
