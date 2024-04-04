//
//  FilingDetailsModel.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 28/03/23.
//

import Foundation

internal struct TaxReturnInfoFilingDetails{
    var id: Int
    var taxAuthority, filingStatus, filingMethod, consentMethod: String
    var refundOrPaymentDue: Int
    var actionDueDate : String?
    var filingAddress: String?
    var refundLink: String
    var paymentLink: String
    var taxAuthorityType: String
    var efileId: String?
    var statusOfFiling: String
    var acceptedDate: String?
    var markAsPaid, markAsFiled: Bool
}

extension TaxReturnInfoFilingDetails: Decodable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case taxAuthority
        case filingStatus
        case filingMethod
        case consentMethod
        case refundOrPaymentDue
        case actionDueDate
        case filingAddress
        case refundLink
        case paymentLink
        case taxAuthorityType
        case efileId
        case statusOfFiling
        case acceptedDate
        case markAsPaid
        case markAsFiled
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        taxAuthority = try values.decode(String.self, forKey: .taxAuthority)
        filingStatus = try values.decode(String.self, forKey: .filingStatus)
        filingMethod = try values.decode(String.self, forKey: .filingMethod)
        consentMethod = try values.decode(String.self, forKey: .consentMethod)
        refundOrPaymentDue = try values.decode(Int.self, forKey: .refundOrPaymentDue)
        if let dateString = try values.decodeIfPresent(String.self, forKey: .actionDueDate) {
            actionDueDate = DateFormatManager.utcDateForAPI.date(from: dateString)!.getFormattedDate(format: "MMM d, yyyy")
        }
        filingAddress = try values.decodeIfPresent(String.self, forKey: .filingAddress) ?? nil
        refundLink = try values.decode(String.self, forKey: .refundLink)
        paymentLink = try values.decode(String.self, forKey: .paymentLink)
        taxAuthorityType = try values.decode(String.self, forKey: .taxAuthorityType)
        efileId = try values.decodeIfPresent(String.self, forKey: .efileId) ?? nil
        statusOfFiling = try values.decode(String.self, forKey: .statusOfFiling)
        acceptedDate = try values.decodeIfPresent(String.self, forKey: .acceptedDate) ?? nil
        markAsPaid = try values.decode(Bool.self, forKey: .markAsPaid)
        markAsFiled = try values.decode(Bool.self, forKey: .markAsFiled)
    }
}

internal struct TaxReturnInfoTaxHighlights{
    var employmentIncome, personalIncome, totalIncome: Int
    var effectiveTaxRate: Double
    var taxBalanceReason: String
}

extension TaxReturnInfoTaxHighlights: Decodable {
    enum CodingKeys: String, CodingKey {
        case employmentIncome
        case personalIncome
        case totalIncome
        case effectiveTaxRate
        case taxBalanceReason
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        employmentIncome = try values.decode(Int.self, forKey: .employmentIncome)
        personalIncome = try values.decode(Int.self, forKey: .personalIncome)
        totalIncome = try values.decode(Int.self, forKey: .totalIncome)
        effectiveTaxRate = try values.decode(Double.self, forKey: .effectiveTaxRate)
        taxBalanceReason = try values.decode(String.self, forKey: .taxBalanceReason)
    }
}
