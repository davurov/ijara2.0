//
//  ChildrensAdditionalInfoTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 05/12/23.
//

import UIKit

class ChildrensAdditionalInfoTVC: UITableViewCell {
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var minimumConditionsLbl: UILabel!
    
    @IBOutlet weak var minConditions: UILabel!
    
	static let identifier: String = String(describing: ChildrensAdditionalInfoTVC.self)
	static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}

	
    override func awakeFromNib() {
        super.awakeFromNib()
		contentView.backgroundColor = .clear
    }
    
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if selected {
			contentView.backgroundColor = .white
		}
	}
	
	func updateCell(_ party: ChildrensParty){
		locationLbl.text = party.forchildrenzone
		minimumConditionsLbl.text = SetLanguage.setLang(type: .minimumConditions) + ":"
		minConditions.text = party.minconditions
	}
	
}
