//
//  ForChilderensServiceVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 04/12/23.
//

import UIKit

class ChildrensServiceVC: UIViewController {
	
	let titleLbl = UILabel()
	var tableView: UITableView!
	var sortBtn = UIButton()
	var sortLbl = UILabel()
	let stackView1 = UIStackView()
	let stackView2 = UIStackView()
	let stackViewForTitle = UIStackView()
	
	/// This array shows parties to user
	var childrenPartiesServices: [ChildrensParty] = []
	var sortingChildrens: [ChildrensParty] = []
	var sortingChildrensID: [Int] = []
	let screenWidth = UIScreen.main.bounds.width
	
	//filtred
	var expensiveParties  : [ChildrensParty] = []
	var cheaperParties	  : [ChildrensParty] = []
	var recommendedParties: [ChildrensParty] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = SetLanguage.setLang(type: .childrens)
		navigationItem.backButtonTitle = ""
		Loader.start()
		setupViews()
		self.scrollViewDidScroll(tableView)
		
		getAllParties()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationController?.navigationBar.isHidden = true
		tableView.reloadData()
	}
	
	private func getAllParties(){
		Loader.start()
		
		API.getAllChildrenParties { [weak self] allChildrenParties in
			guard let self = self else { return }
			guard let allChildrenParties = allChildrenParties else { return }
			
			childrenPartiesServices = allChildrenParties
			sortingChildrens = allChildrenParties
			sortPartiesByPrice()
			setupMenuButton()
			tableView.reloadData()
			Loader.stop()
		}
	}
	
	private func sortPartiesByPrice(){
		// convert all events to (price, id)
		var priceWithID: [(Int, Int)] = []
		
		for party in childrenPartiesServices {
			let price = party.startingprice.replacingOccurrences(of: ".", with: "")
			priceWithID.append((Int(price) ?? 0, party.id))
		}
		
		let expensiveIDs = SortingPrices.sortByExpensive(priceWithID)
		//expensiveParties
		for expensiveID in expensiveIDs {
			guard let expensiveParty = findPartyByID(expensiveID) else { return }
			expensiveParties.append(expensiveParty)
		}
		//cheaperParties
		cheaperParties = expensiveParties.reversed()
		
		//recommendedParties
		recommendedParties = sortingChildrens
	}
	
	private func findPartyByID(_ id: Int) -> ChildrensParty? {
		for partyService in sortingChildrens {
			if partyService.id == id {
				return partyService
			}
		}
		return nil
	}
	
	private func setupMenuButton(){
		let action1 = UIAction(title: SetLanguage.setLang(type: .recommendedCars)) { [weak self] _ in
			guard let self = self else { return }
			
			sortLbl.text = SetLanguage.setLang(type: .recommendedCars)
			childrenPartiesServices = recommendedParties
			tableView.reloadData()
		}
		
		let action2 = UIAction(title: SetLanguage.setLang(type: .cheaperCars)) { [weak self] _ in
			guard let self = self else { return }
			
			sortLbl.text = SetLanguage.setLang(type: .cheaperCars)
			childrenPartiesServices = cheaperParties
			tableView.reloadData()
		}

		let action3 = UIAction(title: SetLanguage.setLang(type: .expensiveCars)) { [weak self] _ in
			guard let self = self else { return }
			
			sortLbl.text = SetLanguage.setLang(type: .expensiveCars)
			childrenPartiesServices = expensiveParties
			tableView.reloadData()
		}
		
		let menu = UIMenu(title: SetLanguage.setLang(type: .priceRange), children: [action1, action2, action3])
		
		sortBtn.menu = menu
		sortBtn.showsMenuAsPrimaryAction = true
	}

	private func setupViews(){
		view.backgroundColor = .white
		navigationController?.navigationBar.tintColor = AppColors.mainColor
		
		tableView = UITableView(frame: view.bounds, style: .grouped)
		
		addSubviews(stackViewForTitle, stackView1, stackView2, tableView)
		
		titleLbl.text = SetLanguage.setLang(type: .childrenEvents)
		titleLbl.font = .systemFont(ofSize: 25, weight: .bold)//UIFont(name: "Futura Bold", size: 25)
		titleLbl.textColor = AppColors.mainColor
		titleLbl.textAlignment = .left
		
		stackViewForTitle.addArrangedSubview(titleLbl)
		stackViewForTitle.alignment = .leading
		stackViewForTitle.axis = .vertical
		
		sortLbl.font = .systemFont(ofSize: 17, weight: .bold)//UIFont(name: "Futura Bold", size: 17)
		sortLbl.text = SetLanguage.setLang(type: .recommendedCars)
		sortLbl.textColor = AppColors.mainColor
		sortLbl.textAlignment = .right
		
		sortBtn.setImage(UIImage(named: "filter"), for: .normal)
		sortBtn.backgroundColor = .clear
		sortBtn.layer.cornerRadius = 10
		sortBtn.clipsToBounds = true
		sortBtn.layer.borderColor = AppColors.selectedTabbarCollor.cgColor
		sortBtn.layer.borderWidth = 2
		sortBtn.isUserInteractionEnabled = true
		
		stackView1.addArrangedSubview(sortLbl)
		stackView1.addArrangedSubview(sortBtn)
		stackView1.axis = .horizontal
		stackView1.spacing = 15
		stackView1.alignment = .trailing
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(ChildrensPartyTVC.nib(), forCellReuseIdentifier: ChildrensPartyTVC.identifer)
		tableView.backgroundColor = .clear
		tableView.showsVerticalScrollIndicator = false
		
		stackView2.addArrangedSubview(stackViewForTitle)
		stackView2.addArrangedSubview(stackView1)
		stackView2.addArrangedSubview(tableView)
		stackView2.axis = .vertical
		stackView2.alignment = .fill
		stackView2.spacing = 7
		
		addConstraints()
	}
	
	private func addConstraints(){
		
		NSLayoutConstraint.activate([
			stackView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
			stackView2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
			stackView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
			stackView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			
			sortBtn.widthAnchor.constraint(equalToConstant: 50),
			sortBtn.heightAnchor.constraint(equalToConstant: 50),
			
			sortLbl.centerYAnchor.constraint(equalTo: sortBtn.centerYAnchor)
		])
	}
	
	private func addSubviews(_ views: UIView...){
		for v in views {
			view.addSubview(v)
			v.translatesAutoresizingMaskIntoConstraints = false
		}
	}
}

extension ChildrensServiceVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		childrenPartiesServices.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ChildrensPartyTVC.identifer, for: indexPath) as? ChildrensPartyTVC else { return UITableViewCell() }
		
		
		let isLiked = LikedProducts.likedProducts.isLiked(
			sevriceType: .party,
			id: childrenPartiesServices[indexPath.row].id
		)
		
		
		cell.partyID = childrenPartiesServices[indexPath.row].id
		
		let heartImg = UIImage(systemName: isLiked ? "heart.fill" : "heart")
		
		cell.updateCell(childrenPartiesServices[indexPath.row], heartImage: heartImg ?? UIImage())
		cell.selectionStyle = .none
		
		return cell
	}
}

extension ChildrensServiceVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let vc = ChildrensServiceDetailVC(nibName: "ChildrensServiceDetailVC", bundle: nil)
		vc.setValues(childrenPartiesServices[indexPath.row])
		vc.hidesBottomBarWhenPushed = true
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if scrollView == tableView {
			if tableView.contentOffset.y > 10.0 {
				UIView.animate(withDuration: 0.3) {
					self.stackView1.transform = CGAffineTransform(translationX: 0, y: -33)
				} completion: { _ in
					self.stackView1.isHidden = true
					self.stackViewForTitle.isHidden = true
				}
				
			}
			
			if tableView.contentOffset.y < 10.0 {
				UIView.animate(withDuration: 0.3) {
					self.stackView1.transform = .identity
				} completion: { _ in
					self.stackView1.isHidden = false
					self.stackViewForTitle.isHidden = false
				}
				
			}
		}
	}
	
//	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		return 175
//	}
}
