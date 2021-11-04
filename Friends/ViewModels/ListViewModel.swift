//
//  ListViewModel.swift
//  Friends
//
//  Created by Emiray Nakip on 4.11.2021.
//

import Foundation

// MARK: -
struct ResultsViewModel {
    var results : [Result]
}

extension ResultsViewModel {
    var numberOfSection : Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.results.count
    }
    
    func modelAt(_ index : Int) -> ListViewModel {
        return ListViewModel(results[index])
    }
    
    mutating func append(appendResults:[Result]) -> [Result] {
        appendResults.forEach { (result) in
            results.append(result)
        }
        return results
    }
    
}

// MARK: -
struct ListViewModel {
    private let result : Result
}

extension ListViewModel {
    init(_ result : Result) {
        self.result = result
    }
    
    var gender: String {
        return self.result.gender?.rawValue ?? ""
    }
    
    var title: String {
        return self.result.name?.title ?? ""
    }
    
    var fName: String {
        return self.result.name?.first ?? ""
    }
    
    var lName: String {
        return self.result.name?.last ?? ""
    }
    
    var pictureThumbnail: String {
        return self.result.picture?.thumbnail ?? ""
    }
    
    var pictureMedium: String {
        return self.result.picture?.medium ?? ""
    }
    
    var pictureLarge: String {
        return self.result.picture?.large ?? ""
    }
    
    var dob: String {
        return self.result.dob?.date ?? ""
    }
    
    var dob_date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dob) {
             return date
        }
        return Date()
    }
    
    var dob_formatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: dob_date)
    }
    
    var dob_age: String {
        return String(self.result.dob?.age ?? 0)
    }
    
    var email: String {
        return self.result.email ?? ""
    }
    
    var phone: String {
        return (self.result.phone ?? "")
    }
    
    var cell: String {
        return (self.result.cell ?? "")
    }
    
    var locationStreet: String {
        return self.result.location?.street?.name ?? ""
    }
    
    var locationStrretNo: String {
        return String(self.result.location?.street?.number ?? 0)
    }
    
    var locationCity: String {
        return self.result.location?.city ?? ""
    }
    
    var locationCountry: String {
        return self.result.location?.country ?? ""
    }
    
    var coordinate: Coordinates {
        return self.result.location?.coordinates ?? Coordinates(latitude: "", longitude: "")
    }
    
    var lat: String {
        return coordinate.latitude ?? ""
    }
    
    var lon: String {
        return coordinate.longitude ?? ""
    }
    
    var coord: String {
        return "Lat:"+lat+" Lon:"+lon+"\nTap for see in map."
    }
    
    var address: String {
        return "Street:"+locationStreet+" No:"+locationStrretNo+"\n"+locationCity+" "+locationCountry
    }
}


