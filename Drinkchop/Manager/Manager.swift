//
//  Manager.swift
//  Momentum
//
//  Created by Mac on 19/07/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import JHSpinner
import Alamofire
import Stripe

class Manager {
    
    typealias barsAlias = ([DrinkBar]?) -> ()
    typealias barAlias = (DrinkBar?) -> ()
    typealias eventsAlias = ([DrinkEvent]?) -> ()
    typealias eventAlias = (DrinkEvent?) -> ()
    typealias extrasAlias = ([DrinkExtras]?) -> ()
    typealias extraAlias = (DrinkExtras?) -> ()
    typealias settingsAlias = ([Settings]?) -> ()
    typealias settingAlias = (Settings?) -> ()
    typealias cardsAlias = ([DrinkCard]?) -> ()
    typealias cardAlias = (DrinkCard?) -> ()
    typealias usersAlias = ([DrinkUser]?) -> ()
    typealias userAlias = (DrinkUser?) -> ()
    typealias coversAlias = ([DrinkCover]?) -> ()
    typealias coverAlias = (DrinkCover?) -> ()
    typealias drinksAlias = ([Drink]?) -> ()
    typealias drinkAlias = (Drink?) -> ()
    typealias happyHoursAlias = ([DrinkHappyHour]?) -> ()
    typealias happyHourAlias = (DrinkHappyHour?) -> ()
    typealias ordersAlias = ([DrinkOrder]?) -> ()
    typealias orderAlias = (DrinkOrder?) -> ()
    typealias tablesAlias = ([DrinkTable]?) -> ()
    typealias tableAlias = (DrinkTable?) -> ()
    
    
    typealias eventsHappyHrsAlias = ([DrinkEvent]?, [DrinkHappyHour]?) -> ()
    typealias favoritesAlias = ([DrinkEvent]?, [Drink]?) -> ()
    typealias barDrinksAlias = ([Drink]?, [String]?) -> ()
    
    static var getData:AlamofireRequestFetch = AlamofireRequestFetch(baseUrl: DrinkChopBaseURL)
    
    static var textLabel:UILabel!
    
    static var spinner:JHSpinnerView!
    
    static var access_token:String!
    
    class func getaccess_token() {
        self.access_token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    class func saveaccess_token(token: String?) {
        self.access_token = token ?? ""
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    class func showLoader(text: String, view: UIView) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        spinner = JHSpinnerView.showOnView(view, spinnerColor: appTintColor, overlay:.custom(CGSize(width: 150, height: 150), 20), overlayColor:UIColor.black.withAlphaComponent(0.6), fullCycleTime:4.0, text: text)
    }
    
    class func hideLoader() {
        UIApplication.shared.endIgnoringInteractionEvents()
        spinner.dismiss()
    }
    
    // MARK: - Parser
    
    class func parseHappyHoursData(response: Any?, isForBar: Bool = false) -> [DrinkHappyHour]? {
        if let res = response as? [String:Any] {
            let key = isForBar ? "status" : "status1"
            if let success = res[key] as? Bool {
                if success {
                    let key1 = isForBar ? "users" : "users1"
                    if let dictArr = res[key1] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkHappyHour].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseEventData(response: Any?, isForFav: Bool = false) -> [DrinkEvent]? {
        if let res = response as? [String:Any] {
            let key = isForFav ? "success" : "status"
            if let success = res[key] as? Bool {
                if success {
                    let key1 = isForFav ? "events" : "users"
                    if let dictArr = res[key1] as? [[String:Any]] {
                        do {
                            
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkEvent].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseOrdersData(response: Any?) -> [DrinkOrder]? {
        if let res = response as? [String:Any] {
            let key = "status"//"success"
            if let success = res[key] as? Bool {
                if success {
                    let key1 = "users"//"packages"
                    if let dictArr = res[key1] as? [[String:Any]] {
                        do {
                            
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkOrder].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseTablesData(response: Any?) -> [DrinkTable]? {
        if let res = response as? [String:Any] {
            let key = "status"//"success"
            if let success = res[key] as? Bool {
                if success {
                    let key1 = "users"//"packages"
                    if let dictArr = res[key1] as? [[String:Any]] {
                        do {
                            
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkTable].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseBarsData(response: Any?) -> [DrinkBar]? {
        if let res = response as? [String:Any] {
            if let success = res["success"] as? Bool {
                if success {
                    if let dictArr = res["users"] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                             return try decoder.decode([DrinkBar].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseBarData(response: [String:Any], key: String) -> DrinkBar? {
        if let dictArr = response[key] as? [[String:Any]] {
            do {
                guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(DrinkBar.self, from: data)
            } catch let error as Error {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseExtrasData(response: Any?) -> [DrinkExtras]? {
        if let res = response as? [String:Any] {
            if let success = res["status"] as? Bool {
                if success {
                    if let dictArr = res["users"] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkExtras].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseSettingsData(response: Any?) -> [Settings]? {
        if let res = response as? [String:Any] {
            if let success = res["status"] as? Bool {
                if success {
                    if let dictArr = res["users"] as? [[String:Any]] {
                        do {
                            
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([Settings].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseCardsData(response: Any?) -> [DrinkCard]? {
        if let res = response as? [String:Any] {
            if let success = res["status"] as? Bool {
                if success {
                    if let dictArr = res["users"] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkCard].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseUsersData(response: Any?, isSignin: Bool = false) -> [DrinkUser]? {
        if let res = response as? [String:Any] {
            if let success = res["success"] as? Int {
                if(isSignin && success == 1) || (!isSignin && success == 3) {
                    if let dictArr = res["user"] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkUser].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseCoversData(response: Any?) -> [DrinkCover]? {
        if let res = response as? [String:Any] {
            if let success = res["status"] as? Int {
                if(success == 1) {
                    if let dictArr = res["users"] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([DrinkCover].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseDrinksData(response: Any?, key: String, key1: String) -> [Drink]? {
        if let res = response as? [String:Any] {
            if let success = res[key] as? Int {
                if(success == 1) {
                    if let dictArr = res[key1] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return nil}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return try decoder.decode([Drink].self, from: data)
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseBarDrinksData(response: Any?, key: String, key1: String) -> ([Drink]?, [String]?) {
        if let res = response as? [String:Any] {
            if let success = res[key] as? Int {
                if(success == 1) {
                    if let dictArr = res[key1] as? [[String:Any]] {
                        do {
                            guard let data = try? JSONSerialization.data(withJSONObject: dictArr, options: .prettyPrinted) else {return (nil,nil)}
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            return (try decoder.decode([Drink].self, from: data), res["types"] as? [String] ?? [])
                        } catch let error as Error {
                            print(error.localizedDescription)
                            return (nil,nil)
                        }
                    } else {
                        return (nil,nil)
                    }
                } else {
                    return (nil,nil)
                }
            } else {
                return (nil,nil)
            }
        } else {
            return (nil,nil)
        }
    }
    
    
    class func parseCardStatusData(response: Any?) -> Bool? {
        if let res = response as? [String:Any] {
            if let success = res["status"] as? Bool {
                if success {
                    return true
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func parseChangePassData(response: Any?) -> Bool? {
        if let res = response as? [String:Any] {
            if let success = res["success"] as? Bool {
                if success {
                    return true
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // MARK: - API Calls
    class func getBarsDataFromServer(lat: Double, lng: Double, distance: Double, completionHandler: @escaping barsAlias) {
        getData.getDataFromServer(subUrl: "\(BarsURL)?lat=\(lat)&lng=\(lng)&distance=\(distance)") { (response) in
            print(response)
            completionHandler(self.parseBarsData(response: response))
        }
    }
 
    class func getHappyHoursDataFromServer(lat: Double, lng: Double, distance: Double, completionHandler: @escaping eventsAlias) {
        getData.getDataFromServer(subUrl: "\(EventsURL)?lat=\(lat)&lng=\(lng)&distance=\(distance)") { (response) in
            print(response)
            completionHandler(parseEventData(response: response))
        }
    }
    
    class func getEventsDataFromServer(lat: Double, lng: Double, distance: Double, completionHandler: @escaping eventsAlias) {
        getData.getDataFromServer(subUrl: "\(EventsURL)?lat=\(lat)&lng=\(lng)&distance=\(distance)") { (response) in
            print(response)
           completionHandler(parseEventData(response: response))
        }
    }
    
    class func getEventsHappyHoursDataFromServer(completionHandler: @escaping eventsHappyHrsAlias) {
        getData.getDataFromServer(subUrl: getAllEventsHappyHoursURL) { (response) in
            print(response)
            completionHandler(parseEventData(response: response), parseHappyHoursData(response: response))
        }
    }
    
    class func getEventsDataFromServer(Id: Int, completionHandler: @escaping eventsAlias) {
        getData.getDataFromServer(subUrl: "\(BarEventsURL)?bar_id=\(Id)") { (response) in
            print(response)
            completionHandler(parseEventData(response: response))
        }
    }
    
    class func getHappyHoursDataFromServer(Id: Int, completionHandler: @escaping happyHoursAlias) {
        getData.getDataFromServer(subUrl: "\(BarHoursURL)?bar_id=\(Id)") { (response) in
            print(response)
            completionHandler(parseHappyHoursData(response: response, isForBar: true))
        }
    }
    
    
    class func getSuperExtrasFromServer(completionHandler: @escaping extrasAlias) {
        getData.getDataFromServer(subUrl: GetExtrasURL) { (response) in
            print(response)
            completionHandler(parseExtrasData(response: response))
        }
    }
    
    class func getSettingsFromServer(id:Int, completionHandler: @escaping settingsAlias) {
        getData.getDataFromServer(subUrl: "\(GetSettingsURL)?user_id=\(id)") { (response) in
            print(response)
            completionHandler(parseSettingsData(response: response))
        }
    }
    
    class func getCoversFromServer(id: String, completionHandler: @escaping coversAlias) {
        getData.getDataFromServer(subUrl: "\(PreviousCoversURL)?user_id=\(id)") { (response) in
            print(response)
            completionHandler(parseCoversData(response: response))
        }
    }
    
    class func getCardsFromServer(id:Int, completionHandler: @escaping cardsAlias) {
        getData.getDataFromServer(subUrl: "\(CardsURL)?user_id=\(id)") { (response) in
            print(response)
            completionHandler(parseCardsData(response: response))
        }
    }
    
    class func addCardStatusFromServer(id:Int, cardId: Int, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(CardStatusURL)?user_id=\(id)&card_id=\(cardId)") { (response) in
            print(response)
            completionHandler(parseCardStatusData(response: response))
        }
    }
    
    class func deleteCardFromServer(id:Int, cardId: Int, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(DeleteCardURL)?user_id=\(id)&card_id=\(cardId)") { (response) in
            print(response)
            completionHandler(parseCardStatusData(response: response))
        }
    }
    
    class func createUserOnServer(name: String, phone: String, email: String, password: String, Type: String, token: String, completionHandler: @escaping usersAlias) {
        getData.getDataFromServer(subUrl: "\(SignupURL)?name=\(name)&phone=\(phone)&password=\(password)&email=\(email)&token=\(token)&Type=\(Type)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (response) in
            print(response)
            completionHandler(parseUsersData(response: response))
        }
    }
    
    class func signinUserOnServer(email: String, password: String, completionHandler: @escaping usersAlias) {
        getData.getDataFromServer(subUrl: "\(SigninURL)?password=\(password)&email=\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (response) in
            print(response)
            completionHandler(parseUsersData(response: response, isSignin: true))
        }
    }
    
    class func changePasswordOnServer(id:Int, password: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(ChangePasswordURL)?user_id=\(id)&password=\(password)&check=1") { (response) in
            print(response)
            completionHandler(parseChangePassData(response: response))
        }
    }
    
    class func saveSettingsOnServer(id: Int, settings: [String], completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(SaveSettingsURL)?user_id=\(id)&1=\(settings[0])&2=\(settings[1])&3=\(settings[2])&4=\(settings[3])&5=\(settings[4])&6=\(settings[5])") { (response) in
            completionHandler(parseChangePassData(response: response))
        }
    }

    class func addCardOnServer(subURL: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(AddCardURL)?\(subURL)") { (response) in
            completionHandler(parseChangePassData(response: response))
        }
    }
    
    class func saveAllergyOnServer(id: String, allergy: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(SaveAllergyURL)?user_id=\(id)&allergy=\(allergy)")
        { (response) in
            print(response)
            completionHandler(parseCardStatusData(response: response))
        }
    }
    
    class func updateTokenOnServer(completionHandler: @escaping (Bool?) -> ()) {
        let token = UserDefaults.standard.string(forKey: fcmTokenDefaultsID) ?? ""
        getData.getDataFromServer(subUrl: "\(UpdateTokenURL)?token=\(token)&email=\(DrinkUser.iUser.userEmail!)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func forgotPasswordOnServer(email: String, type: String, completionHandler: @escaping (Bool?) -> ()) {
        let params:[String:Any] = ["type": type,"email": email]
        getData.UpdateRequestWithRequestStringToServer(subUrl: "\(ForgotPasswordURL)", method: .post, parameters: params) { (response) in
            print(response)
            if let res = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func checkFavoritesOnServer(item: String,barId: String, type: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(CheckFavURL)?type=\(type)&item=\(item)&bar_id=\(barId)&user_id=\(DrinkUser.iUser.userId!)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func saveFavoritesOnServer(itemId: String, check: Int, barId: String, type: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(SetFavURL)?check=\(check)&type=\(type)&item_id=\(itemId)&bar_id=\(barId)&user_id=\(DrinkUser.iUser.userId!)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func saveHelpOnServer(email:String, problem: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(SaveHelpURL)?problem=\(problem)&email=\(email)&name=\(DrinkUser.iUser.userName!)&user_id=\(DrinkUser.iUser.userId!)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    class func getBarDistanceFromServer(lat: String, lng: String, barId: String, completionHandler: @escaping barAlias) {
        getData.getDataFromServer(subUrl: "\(BarDistanceURL)?bar_id=\(barId)&lat=\(lat)&lng=\(lng)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(parseBarData(response: res, key: "users"))
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func checkRoomsOnServer(barId: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(CheckForCheckinURL)?bar_id=\(barId)&user_id=\(DrinkUser.iUser.userId!)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func checkforCheckinOnServer(userId: String, barId: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(CheckForCheckinURL)?user_id=\(userId)&bar_id=\(barId)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["status"] as? Int {
                    if success == 1 {
                        if let barId = res["bar_id"] as? String {
                            completionHandler(true)
                        } else {
                            completionHandler(nil)
                        }
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func saveConfirmationTokenOnServer(confirmation_token: String, ppl_count: String, amount: String, barId: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(SaveConfirmationTokenURL)?bar_id=\(barId)&user_id=\(DrinkUser.iUser.userId!)&amount=\(amount)*ppl_count=\(ppl_count)&confirmation_token=\(confirmation_token)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int {
                    if success == 1 {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func saveVisaPaymentOnServer(secretKey: String, instructions: String, description: String, currency: String, token: String, ppl_count: String, amount: String, barId: String, completionHandler: @escaping (Bool?) -> ()) {
        let params:[String:Any] = ["bar_id":barId,
                                   "user_id": DrinkUser.iUser.userId!,
                                   "amount":amount,
                                   "currency":currency,
                                   "token": token,
                                   "description": description,
                                   "username":DrinkUser.iUser.userName!,
                                   "instructions": instructions,"secret_key": secretKey]
        getData.UpdateRequestToServer(subUrl: "\(SaveVisaPaymentURL)", method: .post, parameters: params) { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let err = res["error"] as? Bool {
                    if !err  {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func saveOrderPaymentOnServer(object: String, secretKey: String, instructions: String, description: String, currency: String, token: String, tax: String, tips: String, amount: String, barId: String, completionHandler: @escaping (Bool?) -> ()) {
        let params:[String:Any] = ["bar_id":barId,
                                   "user_id": DrinkUser.iUser.userId!,
                                   "amount":amount,
                                   "object": object,
                                   "currency":currency,
                                   "token": token,
                                   "payment": "Pending",
                                   "description": description,
                                   "username":DrinkUser.iUser.userEmail!,
                                   "instructions": instructions,
                                   "secret_key": secretKey,
                                   "tips": tips,
                                   "tax": tax]
        getData.UpdateRequestWithRequestStringToServer(subUrl: "\(SaveOrderPaymentURL)", method: .post, parameters: params) { (response) in
            print(response)
            if let res = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
                if let err = res["error"] as? Bool {
                    if !err  {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func uploadUserImageOnServer(imgData: Data, fileURL: URL, completionHandler: @escaping (String?) -> ()) {
        let fileName = fileURL.path
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(imgData, withName: "FILE", fileName: fileName ,mimeType: "image/jpeg")
            formData.append("\(DrinkUser.iUser.userName!)".data(using: .utf8)!, withName: "name")
            formData.append(DrinkUser.iUser.userId!.data(using: .utf8)!, withName: "user_id")
        }, to: "\(DrinkChopBaseURL)add_user_picture.php") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    if let res = response.result.value as? [String:Any] {
                        if let success = res["success"] as? Int {
                            if success == 1 {
                                completionHandler(res["img"] as? String ?? "")
                            } else {
                                completionHandler(nil)
                            }
                        } else {
                            completionHandler(nil)
                        }
                    } else {
                        completionHandler(nil)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(nil)
            }
        }
    }
    
    class func getFavoritesFromServer(id:Int, completionHandler: @escaping favoritesAlias) {
        getData.getDataFromServer(subUrl: "\(GetFavoritesURL)?user_id=\(id)") { (response) in
            print(response)
            completionHandler(parseEventData(response: response, isForFav: true), parseDrinksData(response: response,key: "success1",key1: "drinks"))
        }
    }
    
    class func getOrdersFromServer(id:Int, completionHandler: @escaping ordersAlias) {
        getData.getDataFromServer(subUrl: "\(GetOrdersURL)?user_id=\(id)") { (response) in
            print(response)
            completionHandler(parseOrdersData(response: response))
        }
    }
    
    class func getTablesFromServer(id: String, completionHandler: @escaping tablesAlias) {
        let params:[String:Any] = ["bar_id": id]
        getData.UpdateRequestWithRequestStringToServer(subUrl: "\(GetTablesURL)", method: .post, parameters: params) { (response) in
            print(response)
            completionHandler(parseTablesData(response: convertStringToJSON(jsonString: response.value!)))
        }
    }
    
    class func reserveTablesFromServer(barId: String, tableId: String, completionHandler: @escaping (Bool?)->()) {
        let params:[String:Any] = ["bar_id": barId,"user_id": DrinkUser.iUser.userId!,"table_id": tableId]
        getData.UpdateRequestWithRequestStringToServer(subUrl: "\(ReserveTableURL)", method: .post, parameters: params) { (response) in
            print(response)
            if let response = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
                if let success = response["status"] as? Bool {
                    if success {
                        completionHandler(true)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func getDrinksFromServer(id:Int, completionHandler: @escaping barDrinksAlias) {
        getData.getDataFromServer(subUrl: "\(GetDrinksURL)?bar_id=\(id)") { (response) in
            print(response)
            let res = parseBarDrinksData(response: response,key: "status", key1: "users")
            completionHandler(res.0, res.1)
        }
    }
    
    class func checkUserOnServer(emailId: String, name: String, completionHandler: @escaping (Bool?) -> ()) {
        getData.getDataFromServer(subUrl: "\(CheckUserURL)?email=\(emailId)&name=\(name)") { (response) in
            print(response)
            if let res = response as? [String:Any] {
                if let success = res["success"] as? Int, let err = res["error"] as? Int {
                    if err == 0 {
                        completionHandler(success == 1)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    class func getTableServiceFromServer(userId: String, tableID: String, completionHandler: @escaping (Bool?) -> ()) {
        let params:[String:Any] = ["user_id": userId, "table_id":tableID]
        getData.UpdateRequestWithRequestStringToServer(subUrl: "\(GetTableServiceURL)", method: .post, parameters: params) { (response) in
            print(response)
            if let response = convertStringToJSON(jsonString: response.value!) as? [String:Any] {
                if let success = response["status"] as? Bool, let res = response["users"] as? String  {
                    if success {
                        if !res.contains("error") {
                            completionHandler(true)
                        } else {
                            completionHandler(nil)
                        }
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
}
