//
//  HomePresenter.swift
//  ijara
//
//  Created by Sarvar Qosimov on 01/01/24.
//

import Foundation

protocol HomePresenterDelegate: AnyObject {
    func getHouses()
    func findPriceInterval(from allHouses: [CountryhouseData])
    func searchByKey(from allHouses: [CountryhouseData], searchKey: String, province: String)
    func sortByProvince(with allHouses: [CountryhouseData], province: String)
    func filtrHouses(with allHouses: [CountryhouseData], filtrParametrs: FiltrHousesModel, province: String)
}

class HomePresenter: HomePresenterDelegate {
    
    weak var view: HomeViewProtocol?
    
    init(view: HomeViewProtocol) {
        self.view = view
    }
    //MARK: viewLoaded
    func getHouses() {
        API.getAllHouses {  [self] houses in
//            guard let self = self else { return }
            guard let houses = houses else {
                view?.setHouses(houses: nil)
                Alert.showAlert(forState: .warning, message: "Error")
                
                return
            }
            view?.setHouses(houses: houses)
        }
    }
    
    //MARK: findPriceInterval
    func findPriceInterval(from allHouses: [CountryhouseData]) {
        var minHousePrice = allHouses.first?.priceForWorkingDays ?? 0
        var maxHousePrice = allHouses.first?.priceForWeekends ?? 0
        
        for house in allHouses {
            if house.priceForWorkingDays < minHousePrice {
                minHousePrice = house.priceForWorkingDays
            } else if house.priceForWeekends > maxHousePrice {
                maxHousePrice = house.priceForWeekends
            }
        }
        
        view?.setPirceInterval(min: minHousePrice, max: maxHousePrice)
    }
    
    func searchByKey(from allHouses: [CountryhouseData], searchKey: String, province: String) {
        var searchedHouses = [CountryhouseData]()
        
        if searchKey.replacingOccurrences(of: " ", with: "") != "" {
            for i in allHouses {
                let houseName = i.name.lowercased().replacingOccurrences(of: " ", with: "")
                let searchName = searchKey.lowercased().replacingOccurrences(of: " ", with: "")
                
                if province == SetLanguage.setLang(type: .allCategory) && houseName.contains(searchName) {
                    searchedHouses.append(i)
                } else if i.province == province && houseName.contains(searchName) {
                    searchedHouses.append(i)
                }
            }
        } else {
            searchedHouses = allHouses
        }
        
        view?.searchedHouses(houses: searchedHouses)
    }
    
    func sortByProvince(with allHouses: [CountryhouseData], province: String) {
        var sortedHouses = [CountryhouseData]()
        
        if province == SetLanguage.setLang(type: .allCategory) {
            sortedHouses = allHouses
        } else {
            for house in allHouses where house.province == province {
                sortedHouses.append(house)
            }
        }
        
        view?.sortedHousesByProvince(sortedHouses: sortedHouses)
    }
    
    func filtrHouses(with allHouses: [CountryhouseData], filtrParametrs: FiltrHousesModel, province: String) {
        var filtredHouses = [CountryhouseData]()
//        var result = [CountryhouseData]()
        
        for house in allHouses {
            if isFiltered(house, filtrModel: filtrParametrs) {
                filtredHouses.append(house)
            }
        }
        
        if province != SetLanguage.setLang(type: .allCategory) {
            filtredHouses = filtredHouses.filter({ $0.province == province })
        }
        
        view?.setFiltredHouses(filtredHouses: filtredHouses)
    }
    
    private func isFiltered(_ house: CountryhouseData, filtrModel: FiltrHousesModel) -> Bool {
        ///# check price range
        if house.priceForWorkingDays < filtrModel.selectedMinimumPrice || house.priceForWeekends > filtrModel.selectedMaximumPrice {
            return false
        }

        ///# check guestType
        if !filtrModel.selectedGuestType.isContainsSelectedParamentr(house.companiesId()) {
            return false
        }
        
        ///# check additionFetures
        if !filtrModel.selectedAdditionalFeatures.isContainsSelectedParamentr(house.additionFeaturesId()) {
            return false
        }
        
        ///# check alcohol
        if filtrModel.isUserSelectedAlcohol && !house.alcohol {
            return false
        }
        
        ///# check approved
        if filtrModel.isVerified && !house.approved {
            return false
        }
        
        ///# check number of people
        if let numPeople = filtrModel.selectedNumberOfPeople {
            // user selected number of people
            if numPeople == 9 && house.numberofpeople <= 8 {
                return false
            } else if numPeople != 9 && numPeople != house.numberofpeople {
                return false
            }
        }
        
        return true
    }
    
}

