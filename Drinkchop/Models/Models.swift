////
//  Models.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit


struct DrinkUser: Codable {
    static var iUser = DrinkUser()
    var userId: String?
    var userEmail: String?
    var userPhone: String?
    var userName: String?
    var userImage: String?
    var lat: String?
    var lng: String?
    var registrationIds: String?
    var userPassword: String?
    var salt: String?
    var resetTime: String?
    var emailHash: String?
    var userAllergies: String?
}

struct DrinkBar: Codable {
    
    var barId: String?
    var email: String?
    var name: String?
    var address: String?
    var lat: String?
    var lng: String?
    var cardNumber: String?
    var openingTime: String?
    var closingTime: String?
    var registrationIds: String?
    var picture: String?
    var about: String?
    var doorman: String?
    var table: String?
    var buyDrink: String?
    var entryRate: String?
    var secretKey: String?
    var publicKey: String?
    var rating: String?
    var barStatus: String?
    var statusChangeDate: String?
    var tax: String?
    var totalRoomOccupancy: String?
    var facebook: String?
    var instagram: String?
    var twitter: String?
    var peopleInRoom: String?
    var events: Int?
    var hours: Int?
    var barDistance: Int?
    
    
}

struct DrinkEvent : Codable {
    
    var name: String?
    var id: String?
    var eventId: String?
    var barId: String?
    var eventName: String?
    var eventAbout: String?
    var eventStartTime: String?
    var eventEndTime: String?
    var eventImage: String?
    var lat: String?
    var lng: String?
    
}

struct DrinkHappyHour : Codable {
    
    var happyHourId:String?
    var barId:String?
    var happyHourName:String?
    var happyHourAbout:String?
    var happyHourStartTime:String?
    var happyHourEndTime:String?
    var happyHourImage:String?

}

struct DrinkExtras : Codable {
    var extraId: String?
    var extraName: String?
    var extraPicture: String?
    var extraCost: String?
}

struct DrinkCover: Codable {
    var name: String?
    var barEntryId: String?
    var barId: String?
    var userId: String?
    var confirmationId: String?
    var entryCount: String?
    var entryStatus: String?
    var amount: String?
    var coverDate: String?
    var doormanId: String?
    var userName: String?
}

struct Settings : Codable {
    
    static var iSettings = Settings()
    
    var settingsId: String?
    var userId: String?
    var settingsNotification: String?
    var settingsWakeScreen: String?
    var settingsFlashScreen: String?
    var settingsLed: String?
    var settingsVibrate: String?
    var settingsSound: String?
}


struct DrinkCard: Codable {
    var cardId: String?
    var userId: String?
    var userName: String?
    var cardName: String?
    var cardNumber: String?
    var cardCvv: String?
    var expMonth: String?
    var expYear: String?
    var defaultStatus: String?
}

struct Drink: Codable {
    var drinkId:String?
    var barId:String?
    var drinkName:String?
    var drinkAlcohal:String?
    var drinkType:String?
    var drinkDescription:String?
    var drinkCost:String?
    var drinkIngredients:String?
    var drinkPicture:String?
    var extras: [DrinkExtras]?
    var itemId:String?
    var itemTableId:String?
    var quantity: String?
    var orderId: String?
    var userId:String?
    
}


struct DrinkOrder: Codable {
    
    var drinkId:String?
    var barId:String?
    var drinkName:String?
    var drinkAlcohal:String?
    var drinkType:String?
    var drinkDescription:String?
    var drinkCost:String?
    var drinkIngredients:String?
    var drinkPicture:String?
    var orderId:String?
    var userId:String?
    var orderTime:String?
    var payment:String?
    var totalPrice:String?
    var orderState:String?
    var orderInstructions:String?
    var paymentId:String?
    var barTender_id:String?
    var tips:String?
    var taxAmount:String?
    var name:String?
    var items: [Drink]?
}


class DrinkTable: Codable {
    var ID: String?
    var tableId: String?
    var barId: String?
    var status: String?
    var numSitting: String?
    var createdAt: String?
    var userId: String?
}
