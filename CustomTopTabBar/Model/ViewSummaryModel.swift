////
////  ViewSummaryModel.swift
////  CustomTopTabBar
////
////  Created by Mupparaju M Rao TPR on 16/03/23.
////
//
//import Foundation
//
//struct ViewSummaryModel{
//    var countryExtraInfo: String
//    var taxYear: Int
//    var currency: String
//    var taxPeriod: TaxPeriod
//    var estimatedCompleteDate: String
//    var documentDeliverables: DocumentDeliverables
//    var questionnaire: Questionnaire
//    var milestones: [Milestone]
////    var missingInformation: [Any?]
//    var taxReturnInfo: TaxReturnInfo
//    var canVerifyIdentityForEsign, efileElectronicConsentSignRequired, pendingAssigneeDownloadTaxReturnFiles: Bool
//    var id: Int
//    var name, practiceType, primaryService, countryCode: String
//}
//
//extension ViewSummaryModel: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case countryExtraInfo
//        case taxYear
//        case currency
//        case taxPeriod
//        case estimatedCompleteDate
//        case documentDeliverables
//        case questionnaire
//        case milestones
////        case missingInformation
//        case taxReturnInfo
//        case canVerifyIdentityForEsign
//        case efileElectronicConsentSignRequired
//        case pendingAssigneeDownloadTaxReturnFiles
//        case id
//        case name
//        case practiceType
//        case primaryService
//        case countryCode
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.countryExtraInfo = try values.decode(String.self, forKey: .countryExtraInfo)
//        self.taxYear = try values.decode(Int.self, forKey: .taxYear)
//        self.currency = try values.decode(String.self, forKey: .currency)
//        self.taxPeriod = try values.decode(TaxPeriod.self, forKey: .taxPeriod)
//        self.estimatedCompleteDate = try values.decode(String.self, forKey: .estimatedCompleteDate)
//        self.documentDeliverables = try values.decode(DocumentDeliverables.self, forKey: .documentDeliverables)
//        self.questionnaire = try values.decode(Questionnaire.self, forKey: .questionnaire)
//        self.milestones = try values.decode([Milestone].self, forKey: .milestones)
////        self.missingInformation = try values.decode(AnyObject.self, forKey: .missingInformation)
//        self.taxReturnInfo = try values.decode(TaxReturnInfo.self, forKey: .taxReturnInfo)
//        self.canVerifyIdentityForEsign = try values.decode(Bool.self, forKey: .canVerifyIdentityForEsign)
//        self.efileElectronicConsentSignRequired = try values.decode(Bool.self, forKey: .efileElectronicConsentSignRequired)
//        self.pendingAssigneeDownloadTaxReturnFiles = try values.decode(Bool.self, forKey: .pendingAssigneeDownloadTaxReturnFiles)
//        self.id = try values.decode(Int.self, forKey: .id)
//        self.name = try values.decode(String.self, forKey: .name)
//        self.practiceType = try values.decode(String.self, forKey: .practiceType)
//        self.primaryService = try values.decode(String.self, forKey: .primaryService)
//        self.countryCode = try values.decode(String.self, forKey: .countryCode)
//    }
//}
//
//struct DocumentDeliverables {
//    var taxReturn, teq, other: String
//}
//
//extension DocumentDeliverables: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case taxReturn
//        case teq
//        case other
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.taxReturn = try values.decode(String.self, forKey: .taxReturn)
//        self.teq = try values.decode(String.self, forKey: .teq)
//        self.other = try values.decode(String.self, forKey: .other)
//    }
//}
//
//
//struct Milestone {
//    var name, status: String
//    var doneDate: String?
//}
//
//extension Milestone: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case name
//        case status
//        case doneDate
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try values.decode(String.self, forKey: .name)
//        self.status = try values.decode(String.self, forKey: .status)
//        self.doneDate = try values.decode(String.self, forKey: .doneDate)
//    }
//}
//
//
//struct Questionnaire {
//    var dueDate: String
//    var milestones: [Milestone]
//}
//
//extension Questionnaire: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case dueDate
//        case milestones
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.dueDate = try values.decode(String.self, forKey: .dueDate)
//        self.milestones = try values.decode([Milestone].self, forKey: .milestones)
//    }
//}
//
//
//struct TaxPeriod {
//    var startDate, endDate: String
//}
//
//extension TaxPeriod: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case startDate
//        case endDate
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.startDate = try values.decode(String.self, forKey: .startDate)
//        self.endDate = try values.decode(String.self, forKey: .endDate)
//    }
//}
//
//struct TaxReturnInfo {
//    var hasRejectedConsents: Bool
//    var files: [File]
//    var efile: Efile
//    var efileJurisdictions: [String]
//    var latestTaxReturnFileId: String
//    var hasFilingItem, isDashboardPublished: Bool
//    var filingDetails: [FilingDetail]
//    var taxEqualization: TaxEqualization
//    var taxHighlights: TaxHighlights
////    var voucherFileIDS, workRecordOtherFileIDS: [Any?]
//}
//
//extension TaxReturnInfo: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case hasRejectedConsents
//        case files
//        case efile
//        case efileJurisdictions
//        case latestTaxReturnFileId
//        case hasFilingItem
//        case isDashboardPublished
//        case filingDetails
//        case taxEqualization
//        case taxHighlights
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.hasRejectedConsents = try values.decode(Bool.self, forKey: .hasRejectedConsents)
//        self.files = try values.decode([File].self, forKey: .files)
//        self.efile = try values.decode(Efile.self, forKey: .efile)
//        self.efileJurisdictions = try values.decode([String].self, forKey: .efileJurisdictions)
//        self.latestTaxReturnFileId = try values.decode(String.self, forKey: .latestTaxReturnFileId)
//        self.hasFilingItem = try values.decode(Bool.self, forKey: .hasFilingItem)
//        self.isDashboardPublished = try values.decode(Bool.self, forKey: .isDashboardPublished)
//        self.filingDetails = try values.decode([FilingDetail].self, forKey: .filingDetails)
//        self.taxEqualization = try values.decode(TaxEqualization.self, forKey: .taxEqualization)
//        self.taxHighlights = try values.decode(TaxHighlights.self, forKey: .taxHighlights)
//    }
//}
//
//
//struct Efile {
//    var id: Int
//    var hasSigned, isJointEfile, hasInvited, hasJointSigned: Bool
//    var hasOptOut: Bool
//}
//
//extension Efile: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case hasSigned
//        case isJointEfile
//        case hasInvited
//        case hasJointSigned
//        case hasOptOut
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try values.decode(Int.self, forKey: .id)
//        self.hasSigned = try values.decode(Bool.self, forKey: .hasSigned)
//        self.isJointEfile = try values.decode(Bool.self, forKey: .isJointEfile)
//        self.hasInvited = try values.decode(Bool.self, forKey: .hasInvited)
//        self.hasJointSigned = try values.decode(Bool.self, forKey: .hasJointSigned)
//        self.hasOptOut = try values.decode(Bool.self, forKey: .hasOptOut)
//    }
//}
//
//struct File {
//    var fileId: String
//    var firstDownloadAt: String
//}
//
//extension File: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case fileId
//        case firstDownloadAt
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.fileId = try values.decode(String.self, forKey: .fileId)
//        self.firstDownloadAt = try values.decode(String.self, forKey: .firstDownloadAt)
//    }
//}
//
//
//struct FilingDetail {
//    var id: Int
//    var taxAuthority, filingStatus, filingMethod, consentMethod: String
//    var refundOrPaymentDue: Int
//    var actionDueDate, filingAddress: String
//    var refundLink: String
//    var paymentLink: String
//    var taxAuthorityType: String
//    var efileId: String
//    var statusOfFiling: String
//    var acceptedDate: String
//    var markAsPaid, markAsFiled: Bool
//}
//
//extension FilingDetail: Decodable, Identifiable, Hashable {
//    enum CodingKeys: String, CodingKey {
//        case id
//        case taxAuthority
//        case filingStatus
//        case filingMethod
//        case consentMethod
//        case refundOrPaymentDue
//        case actionDueDate
//        case filingAddress
//        case refundLink
//        case paymentLink
//        case taxAuthorityType
//        case efileId
//        case statusOfFiling
//        case acceptedDate
//        case markAsPaid
//        case markAsFiled
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try values.decode(Int.self, forKey: .id)
//        self.taxAuthority = try values.decode(String.self, forKey: .taxAuthority)
//        self.filingStatus = try values.decode(String.self, forKey: .filingStatus)
//        self.filingMethod = try values.decode(String.self, forKey: .filingMethod)
//        self.consentMethod = try values.decode(String.self, forKey: .consentMethod)
//        self.refundOrPaymentDue = try values.decode(Int.self, forKey: .refundOrPaymentDue)
//        self.actionDueDate = try values.decode(String.self, forKey: .acceptedDate)
//        self.filingAddress = try values.decode(String.self, forKey: .filingAddress)
//        self.refundLink = try values.decode(String.self, forKey: .refundLink)
//        self.paymentLink = try values.decode(String.self, forKey: .paymentLink)
//        self.taxAuthorityType = try values.decode(String.self, forKey: .taxAuthorityType)
//        self.efileId = try values.decode(String.self, forKey: .efileId)
//        self.statusOfFiling = try values.decode(String.self, forKey: .statusOfFiling)
//        self.acceptedDate = try values.decode(String.self, forKey: .acceptedDate)
//        self.markAsPaid = try values.decode(Bool.self, forKey: .markAsPaid)
//        self.markAsFiled = try values.decode(Bool.self, forKey: .markAsFiled)
//    }
//}
//
//
//
//struct TaxEqualization {
//    var taxEqualizationAmount: Int
////    var fileIDS: [Any?]
//}
//
//extension TaxEqualization: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case taxEqualizationAmount
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.taxEqualizationAmount = try values.decode(Int.self, forKey: .taxEqualizationAmount)
//    }
//}
//
//
//struct TaxHighlights {
//    var employmentIncome, personalIncome, totalIncome: Int
//    var effectiveTaxRate: Double
//    var taxBalanceReason: String
//}
//
//extension TaxHighlights: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case employmentIncome
//        case personalIncome
//        case totalIncome
//        case effectiveTaxRate
//        case taxBalanceReason
//    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.employmentIncome = try values.decode(Int.self, forKey: .employmentIncome)
//        self.personalIncome = try values.decode(Int.self, forKey: .personalIncome)
//        self.totalIncome = try values.decode(Int.self, forKey: .totalIncome)
//        self.effectiveTaxRate = try values.decode(Double.self, forKey: .effectiveTaxRate)
//        self.taxBalanceReason = try values.decode(String.self, forKey: .taxBalanceReason)
//    }
//}
