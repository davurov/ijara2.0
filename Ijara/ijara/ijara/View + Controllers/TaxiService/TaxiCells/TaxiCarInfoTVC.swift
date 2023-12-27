//
//  TaxiCarInfoTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 02/12/23.
//

import UIKit

class TaxiCarInfoTVC: UITableViewCell {
    
    @IBOutlet weak var taxiTypeLbl: UILabel!
    @IBOutlet weak var directionLbl: UILabel!
    @IBOutlet weak var passangersLbl: UILabel!
    
    @IBOutlet weak var minimumConditionsTitle: UILabel!
    
    @IBOutlet weak var minimumConditionsLbl: UILabel!
    
    static let identifier = String(describing: TaxiCarInfoTVC.self)
    static func nib() -> UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .white
        }
    }
    
    func updateCell(taxiType: String, direction: String, passangers: String, minimumConditions: String){
        taxiTypeLbl.text = taxiType
        directionLbl.text = direction
        passangersLbl.text = passangers
        minimumConditionsLbl.text = minimumConditions
    }
    
    private func setupViews(){
        minimumConditionsTitle.text = "\(SetLanguage.setLang(type: .minimumConditions)):"
    }
    
}
