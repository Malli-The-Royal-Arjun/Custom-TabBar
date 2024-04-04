//
//  TaxSummaryModel.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 28/03/23.
//

import Foundation
import UIKit

internal protocol BaseStatusOfWork {
    var id: Int {get set}
    var practiceType: Enums.practiceType {get set}
    var typeOfService: Enums.StatusOfWorkEnums.typeOfServiceStatus {get set}
    var name: String {get set}
    var primaryService: String {get set}
    var countryCode: String {get set}
}


internal protocol BaseComplianceStatusOfWork: BaseStatusOfWork {
    var id: Int {get set}
    var practiceType: Enums.practiceType {get set}
    var typeOfService: Enums.StatusOfWorkEnums.typeOfServiceStatus {get set}
    var name: String {get set}
    var primaryService: String {get set}
    var countryCode: String {get set}
    var missingInformation: [MissingInformationModel] {get set}
    var milestones: [BaseMilestone] {get set}
    var missingInfoStatus: Enums.StatusOfWorkEnums.missingInfoStatus {get set}
    var activeStatusSection: Enums.StatusOfWorkEnums.activeStatusSection {get set}
}

internal struct TaxStatusOfWorkModel: BaseComplianceStatusOfWork {
    var id: Int
    var practiceType: Enums.practiceType
    var typeOfService: Enums.StatusOfWorkEnums.typeOfServiceStatus
    var name: String
    var primaryService: String
    var countryCode: String
    var currency: String
    var missingInformation: [MissingInformationModel]
    var milestones: [BaseMilestone]
    var missingInfoStatus: Enums.StatusOfWorkEnums.missingInfoStatus
    var questionnaireMilestones: [QuestionnaireMilestone]
    var activeStatusSection: Enums.StatusOfWorkEnums.activeStatusSection
    var questionnaireDueDate: Date
    
    var year: Int
    
    var countryExtraInfo: String
    var estimatedCompletionDate: Date?
    var taxPeriod: TaxPeriodInfo?
    
    
    var taxReturnInfo: TaxReturnInfo?
    
    var canVerifyIdentityForEsign: Bool
    var efileElectronicConsentSignRequired: Bool
    var pendingAssigneeDownloadTaxReturnFiles: Bool
    
    var efileStatus: Enums.StatusOfWorkEnums.esignStatus
}

extension TaxStatusOfWorkModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case practiceType
        case primaryService
        case name
        case countryCode
        case missingInformation
        case milestones
        case countryExtraInfo
        case taxYear
        case estimatedCompletionDate = "estimatedCompleteDate"
        case taxPeriod
        case questionnaire
        case canVerifyIdentityForEsign
        case efileElectronicConsentSignRequired
        case pendingAssigneeDownloadTaxReturnFiles
        case taxReturnInfo
        case currency
        
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        practiceType = try Enums.practiceType(stringValue: values.decode(String.self, forKey: .practiceType))
        typeOfService = .taxStandardItem
        primaryService = try values.decodeIfPresent(String.self, forKey: .primaryService) ?? ""
        countryCode = try values.decode(String.self, forKey: .countryCode)
        missingInformation = try values.decodeIfPresent([MissingInformationModel].self, forKey: .missingInformation) ?? [MissingInformationModel]()

        year = try values.decode(Int.self, forKey: .taxYear)
        countryExtraInfo = try values.decodeIfPresent(String.self, forKey: .countryExtraInfo) ?? ""
        if let dateString = try values.decodeIfPresent(String.self, forKey: .estimatedCompletionDate) {
            estimatedCompletionDate = DateFormatManager.utcDateForAPI.date(from: dateString)!
        }
        taxPeriod = try values.decodeIfPresent(TaxPeriodInfo.self, forKey: .taxPeriod)
        milestones = try values.decodeIfPresent([TaxMilestone].self, forKey: .milestones) ?? [TaxMilestone]()
        
        missingInfoStatus = HomeMissingInfoPresenter.determineStatus(missingInformation)
     
        let questionnaire = try values.decode(Questionnaire.self, forKey: .questionnaire)
        questionnaireDueDate = questionnaire.dueDate
        questionnaireMilestones = questionnaire.milestones
        
        activeStatusSection = .milestoneSection
        if questionnaireMilestones.filter({$0.doneDate != nil && $0.key == Enums.StatusOfWorkEnums.questionnaireMilestone.submitted.key()}).isEmpty {
            activeStatusSection = .questionnaireSection
        }
        
        canVerifyIdentityForEsign = try values.decodeIfPresent(Bool.self, forKey: .canVerifyIdentityForEsign) ?? false
        efileElectronicConsentSignRequired = try values.decodeIfPresent(Bool.self, forKey: .efileElectronicConsentSignRequired) ?? false
        pendingAssigneeDownloadTaxReturnFiles = try values.decodeIfPresent(Bool.self, forKey: .pendingAssigneeDownloadTaxReturnFiles) ?? false
        
        taxReturnInfo = try values.decodeIfPresent(TaxReturnInfo.self, forKey: .taxReturnInfo) ?? nil
        
        efileStatus = .unknown
        currency = try values.decode(String.self, forKey: .currency)
    }
}

internal struct MissingInformationModel {
    var workRecordID: Int
    var practiceType: Enums.practiceType
    var year: Int
    var countryCode: String
    var itemID: Int
    var pending: Bool
    var from: Enums.StatusOfWorkEnums.missingInfoFrom
    var since: Date
    var description: String
}

extension MissingInformationModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case pending
        case from
        case since
        case description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        itemID = try values.decode(Int.self, forKey: .id)
        pending = try values.decode(Bool.self, forKey: .pending)
        let fromValue: String = try values.decode(String.self, forKey: .from)
        from = Enums.StatusOfWorkEnums.missingInfoFrom(rawString: fromValue)
        description = try values.decode(String.self, forKey: .description)
        let datestring = try values.decode(String.self, forKey: .since)
        since = DateFormatManager.utcDateForAPI.date(from: datestring)!
        
        // Placeholders
        workRecordID = 0
        practiceType = .tax
        countryCode = ""
        year = 0
    }
}

internal struct TaxMilestone: BaseMilestone {
    var key: Int
    var name: String
    var status: Enums.StatusOfWorkEnums.statusOfWorkMilestoneStatus
    var doneDate: Date?
}

extension TaxMilestone: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case doneDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        key = Enums.StatusOfWorkEnums.taxMilestoneInfo(rawString: name).key()
        if let dateString = try values.decodeIfPresent(String.self, forKey: .doneDate) {
            doneDate = DateFormatManager.utcDateForAPI.date(from: dateString)!
        }
        status = try Enums.StatusOfWorkEnums.statusOfWorkMilestoneStatus(rawString: values.decode(String.self, forKey: .status))
    }
}

internal protocol BaseMilestone {
    var key: Int {get set}
    var name: String {get set}
    var status: Enums.StatusOfWorkEnums.statusOfWorkMilestoneStatus {get set}
    var doneDate: Date? {get set}
}



internal struct Questionnaire: Decodable {
    var dueDate: Date
    var milestones: [QuestionnaireMilestone]
}
extension Questionnaire {
    enum CodingKeys: String, CodingKey {
        case dueDate
        case milestones
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        milestones = try values.decode([QuestionnaireMilestone].self, forKey: .milestones)
        let dateString = try values.decode(String.self, forKey: .dueDate)
        dueDate = DateFormatManager.utcDateForAPI.date(from: dateString)!
    }
}

internal struct QuestionnaireMilestone: BaseMilestone {
    var key: Int
    var name: String
    var status: Enums.StatusOfWorkEnums.statusOfWorkMilestoneStatus
    var doneDate: Date?
}

extension QuestionnaireMilestone: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case doneDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        key = Enums.StatusOfWorkEnums.questionnaireMilestone(rawString: name).key()
        if let dateString = try values.decodeIfPresent(String.self, forKey: .doneDate) {
            doneDate = DateFormatManager.utcDateForAPI.date(from: dateString)!
        }
        status = try Enums.StatusOfWorkEnums.statusOfWorkMilestoneStatus(rawString: values.decode(String.self, forKey: .status))
    }
}

internal struct TaxPeriodInfo {
    var startDate: String?
    var endDate: String?
}

extension TaxPeriodInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case startDate
        case endDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? nil
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? nil
    }
}

internal struct TaxReturnInfo {
    var files: [TaxReturnInfoFiles]
    var efile: TaxReturnInfoEFileType?
    var filingDetails : [TaxReturnInfoFilingDetails?] // Added this
    var hasRejectedConsents: Bool
    var efileJurisdictions: [String]
    var latestTaxReturnFileId: String?
    var hasFilingItem: Bool
    var isDashboardPublished : Bool
    var taxHighlights: TaxReturnInfoTaxHighlights? // Added this
}

extension TaxReturnInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case files
        case efile
        case hasRejectedConsents
        case estimatedCompletionDate
        case efileJurisdictions
        case latestTaxReturnFileId
        case hasFilingItem
        case isDashboardPublished
        case filingDetails // Added this
        case taxHighlights
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        files = try values.decodeIfPresent([TaxReturnInfoFiles].self, forKey: .files) ?? [TaxReturnInfoFiles]()
        efile = try values.decodeIfPresent(TaxReturnInfoEFileType.self, forKey: .efile) ?? nil
        
        hasRejectedConsents = try values.decode(Bool.self, forKey: .hasRejectedConsents)
        efileJurisdictions = try values.decodeIfPresent([String].self, forKey: .efileJurisdictions) ?? [String]()
        latestTaxReturnFileId = try values.decodeIfPresent(String.self, forKey: .latestTaxReturnFileId) ?? nil
        hasFilingItem = try values.decode(Bool.self, forKey: .hasFilingItem)
        isDashboardPublished = try values.decode(Bool.self, forKey: .isDashboardPublished)
        filingDetails = try values.decodeIfPresent([TaxReturnInfoFilingDetails].self, forKey: .filingDetails) ?? [TaxReturnInfoFilingDetails]()
        taxHighlights = try values.decodeIfPresent(TaxReturnInfoTaxHighlights.self, forKey: .taxHighlights) ?? nil
    }
}


internal struct TaxReturnInfoFiles {
    var fileID: String
    var firstDownloadAt: String
}

extension TaxReturnInfoFiles: Decodable {
    enum CodingKeys: String, CodingKey {
        case fileId
        case firstDownloadAt
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fileID = try values.decode(String.self, forKey: .fileId)
        firstDownloadAt = try values.decodeIfPresent(String.self, forKey: .firstDownloadAt) ?? ""
    }
}

internal struct TaxReturnInfoEFileType {
    var efileID: String
    var hasSigned: Bool
    var isJointEfile: Bool
    var hasInvited: Bool
    var hasJointSigned: Bool
    var hasOptOut: Bool
}

extension TaxReturnInfoEFileType: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case hasSigned
        case isJointEfile
        case hasInvited
        case hasJointSigned
        case hasOptOut
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        efileID = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        hasSigned = try values.decode(Bool.self, forKey: .hasSigned)
        isJointEfile = try values.decode(Bool.self, forKey: .isJointEfile)
        hasInvited = try values.decode(Bool.self, forKey: .hasInvited)
        hasJointSigned = try values.decode(Bool.self, forKey: .hasJointSigned)
        hasOptOut = try values.decode(Bool.self, forKey: .hasOptOut)
    }
}



















internal struct Enums {
        
    internal enum featureSections: String {
        case home = "home"
        case messages = "messages"
        case statusOfWork = "status"
        case documents = "documents"
        case digitalBriefing = "briefings"
        case contacts = "contacts"
        case travelDocuments = "travel-docs"
        case settings = "settings"
        case calendar = "calendar"
        
        func notificationName() -> String {
            return "\(self.rawValue)-notify"
        }
        
        static func allItems() -> [featureSections] {
            return [.home, .calendar, .messages, .statusOfWork, .documents, .digitalBriefing, .contacts, .travelDocuments, .settings]
        }
    }

    internal enum pinCodeItemType: Int {
        case phoneNumber = 1
        case email = 2
    }
    
    internal enum pinCodeRequestType: String {
        case primaryPhoneNumber = "PrimaryPhoneNumber"
        case secondaryPhoneNumber = "SecondaryPhoneNumber"
        case primaryEmail = "PrimaryEmail"
        case secondaryEmail = "SecondaryEmail"
    }
                            
    internal enum apiResultsCode {
        case success
        case tokenExpired
        case error
        case networkNotAvailable
        case timeOut
        case networkError
        case invalidModel
        func displayString() -> String {
            switch self {
            case .success:
                return "success"
            case .tokenExpired:
                return "tokenExpired"
            case .error:
                return "error"
            case .networkNotAvailable:
                return "networkNotAvailable"
            case .timeOut:
                return "timeOut"
            case .networkError:
                return "timeOut"
            case .invalidModel:
                return "invalidModel"
            }
        }
    }
    
    internal enum authenticationStatus {
        case success
        case invalidLogin
        case error
        case userLocked
        case registrationIncomplete
        case consentNotSigned
        case timeOut
        case networkError
        case invalidModel
        case invalidPinCode
        case lockedPinCode
        case networkNotAvailable
        case tokenExpired
        
        internal init(codeValue: String) {
            switch codeValue.uppercased() {
            case "NO_CONNECTION_AVAILABLE":
                self = .networkNotAvailable
            case "INVALID_PIN_CODE":
                self = .invalidPinCode
            case "LOCKED_PIN_CODE":
                self = .lockedPinCode
            case "INVALID_LOGIN":
                self = .invalidLogin
            case "USER_LOCKED":
                self = .userLocked
            case "REGISTRATION_INCOMPLETE":
                self = .registrationIncomplete
            case "CONSENT_NOT_SIGNED":
                self = .consentNotSigned
            default:
                self = .error
            }
        }
        func displayString() -> String {
            switch self {
            case .networkNotAvailable:
                return "networkNotAvailable"
            case .success:
                return "success"
            case .invalidLogin:
                return "invalidLogin"
            case .error:
                return "error"
            case .userLocked:
                return "userLocked"
            case .registrationIncomplete:
                return "registrationIncomplete"
            case .consentNotSigned:
                return "consentNotSigned"
            case .timeOut:
                return "timeOut"
            case .networkError:
                return "networkError"
            case .invalidModel:
                return "invalidModel"
            case .invalidPinCode:
                return "invalidPinCode"
            case .lockedPinCode:
                return "lockedPinCode"
            case .tokenExpired:
                return "tokenExpired"
            }
        }
    }

    internal enum practiceType: Int {
        case tax = 0
        case immigration = 1
        case social_security = 2
        case technology = 4
        case managed_services = 5
                
        func displayString() -> String {
            switch self {
            case .immigration:
                return "Immigration"
            case .social_security:
                return "Social Security"
            case .technology:
                return "Technology"
            case .managed_services:
                return "Managed Services"
            default:
                return "Tax"
            }
        }
        
        internal init(rawValue: Int) {
            switch rawValue {
            case 1:
                self = .immigration
            case 2:
                self = .social_security
            case 4:
                self = .technology
            case 5:
                self = .managed_services
            default:
                self = .tax
            }
        }
        
        internal init(stringValue: String) {
            switch stringValue.uppercased() {
            case "IMMIGRATION":
                self = .immigration
            case "SOCIAL_SECURITY", "SOCIALSECURITY", "SOCIAL SECURITY":
                self = .social_security
            case "TECHNOLOGY":
                self = .technology
            case "MANAGEDSERVICE":
                self = .managed_services
            default:
                self = .tax
            }
        }
        
        func getValueforDb() -> Int {
            return self.rawValue
        }
    }
    
    internal enum notificationType: String {
        case AppEnteredForeground = "APPLICATION_ENTERED_FOREGROUND"
        case notificationsBadgeUpdate = "NOTIFICATION_BADGE_UPDATE"
        case statusBadgeUpdate = "STATUS_BADGE_UPDATE"
        case launchByURL = "LAUNCH_BY_URL"
        case loggedIn = "USER_LOGGED_IN"
        case loggedInFrontDoor = "USER_LOGGED_IN_FRONT_DOOR"
        case profileUpdated = "PROFILE_UPDATED"
        case backgrounded = "BACKGROUNDED"
        case homeScreenGoToFileCabinet = "GO_TO_FC"
        case homeScreenGoToDigitalBriefings = "GO_TO_DIGITAL_BRIEFINGS"
        case homeScreenRefreshNotifications = "HOME_REFRESH_NOTIFICATIONS"
        case homeScreenRefreshStatusOrAlerts = "HOME_REFRESH_STATUS_OR_ALERTS"
        case fcRefreshStatus = "FILE_CABINET_REFRESH"
        case calendarActionChange = "CALENDAR-CHANGED"
        case calendarActionSync = "CALENDAR-SYNC"
        case esignCloseWindowsAndRefresh = "ESIGN_CLOSE_AND_REFRESH"
        case ssoRefresh = "SSO_REFRESH"
    }
    
    internal enum travelDocumentType: Int {
        case pdf = 1
        case note = 2
    }
}

extension Enums {
    internal struct StatusOfWorkEnums {

        enum esignIntroScreenType: Int {
            case standard = 1
            case requireManualOptOut = 2
        }
        
        
        internal enum taxReturnDeliveryStatus {
            case notReady, readyForDownload, downloaded
        }
        
        internal enum esignDisplayStatus: Int {
            case standardCard = 0
            case esignCardStatusAvailable = 1
            case esignCardStatusSigned = 2
            case esignCardStatusAwaitingSpouseSignature = 3
            case esignCardStatusComplete = 4
            case esignCardStatusManualConsent = 5
        }
        
        internal enum esignStatus: Int {
            case unknown = 0
            case notEnabled = 1
            case hasOptOut = 2
            case readyToSign = 3
            case signed = 4
            case canManuallyConsentOnly = 5
            internal init(rawValue: Int) {
                switch rawValue {
                case 1:
                    self = .notEnabled
                case 2:
                    self = .hasOptOut
                case 3:
                    self = .readyToSign
                case 4:
                    self = .signed
                case 5:
                    self = .canManuallyConsentOnly
                default:
                    self = .unknown
                }
            }
        }
        
        internal enum statusDisplayPriority: Int {
            case critical = 3
            case high = 2
            case med = 1
            case low = 0
        }
       
        
        internal enum taxItemStatus: Int {
            case questionnaireNotStarted = 0
            case questionnaireStarted = 1
            case questionnaireOverdue = 2
            case questionnaireSubmitted = 3
            case inPreparation = 4
            case deliveried = 5
            case completed = 6
        }
        
        internal enum activeStatusSection: Int {
            case questionnaireSection = 0
            case milestoneSection = 1
            internal init(rawValue: Int) {
                switch rawValue {
                case 0:
                    self = .questionnaireSection
                default:
                    self = .milestoneSection
                }
            }
        }
        
        internal enum statusViewDisplayType {
            case missingInfo, overdue, standard, esign
        }
        
        internal enum missingInfoStatus: Int {
            case none = 0
            case assignee = 1
            case company = 2
            case pwc = 3
            case companyAndPwC = 4
            
            internal init(rawValue: Int) {
                switch rawValue {
                case 1:
                    self = .assignee
                case 2:
                    self = .company
                case 3:
                    self = .pwc
                case 4:
                    self = .companyAndPwC
                default:
                    self = .none
                }
            }
        }
        
        internal enum questionnaireMilestone: Int {
            case notified = 0
            case inProgress = 1
            case submitted = 2
            internal init(rawValue: Int) {
                switch rawValue {
                case 2:
                    self = .submitted
                case 1:
                    self = .inProgress
                default:
                    self = .notified
                }
            }
            internal init(rawString: String) {
                switch rawString.lowercased() {
                case "submitted":
                    self = .submitted
                case "inprogress":
                    self = .inProgress
                default:
                    self = .notified
                }
            }
            
            func displayName() -> String {
                switch self {
                case .inProgress:
                    return "InProgress"
                case .notified:
                    return "Notified"
                default:
                    return "Submitted"
                }
            }
            func order() -> Int {
                return self.rawValue
            }
            func key() -> Int {
                return self.rawValue
            }
        }
        internal enum statusOfWorkMilestoneStatus: Int {
            case notStarted = 0
            case inProgress = 1
            case done = 2
            internal init(rawValue: Int) {
                switch rawValue {
                case 2:
                    self = .done
                case 1:
                    self = .inProgress
                default:
                    self = .notStarted
                }
            }
            internal init(rawString: String) {
                switch rawString.lowercased() {
                case "done":
                    self = .done
                case "inprogress":
                    self = .inProgress
                default:
                    self = .notStarted
                }
            }
            func getValueforDb() -> Int {
                return self.rawValue
            }
            func getStringValue() -> String {
                switch self {
                case .done:
                    return "Done"
                case .notStarted:
                    return "NotStarted"
                default:
                    return "InProgress"
                }
            }
        }
        
        internal enum taxMilestoneInfo: Int {
            case inPreparation = 0
            case delivered = 1
            case completed = 2
            
            internal init(rawString: String) {
                switch rawString.lowercased() {
                case "taxreturninprocess":
                    self = .inPreparation
                case "taxreturndelivered":
                    self = .delivered
                default:
                    self = .completed
                }
            }
            func key() -> Int {
                return self.rawValue
            }
            func order() -> Int {
                return self.rawValue
            }
        }
        
        internal enum immigrationMilestoneInfo: Int {
            case postWork = 99
            case gatherInformation = 0
            case inAssessment = 1
            case inPreparation = 2
            case submittedToAuthorities = 3
            case completed = 4
         
            internal init(rawValue: Int) {
                switch rawValue {
                case 1:
                    self = .inAssessment
                case 2:
                    self = .inPreparation
                case 3:
                    self = .submittedToAuthorities
                case 4:
                    self = .completed
                default:
                    self = .gatherInformation
                }
            }
            
            internal init(rawString: String) {
                switch rawString.lowercased() {
                case "initiation":
                    self = .gatherInformation
                case "assessment":
                    self = .inAssessment
                case "preparation":
                    self = .inPreparation
                case "submission":
                    self = .submittedToAuthorities
                case "issuance":
                    self = .completed
                default:
                    self = .postWork
                }
            }
            func key() -> Int {
                return self.rawValue
            }
            func order() -> Int {
                return self.rawValue
            }
        }
        
        internal enum CoCMilestoneInfo: Int {
            case initiated = 99
            case gatherInformation = 0
            case inPreparation = 1
            case submittedToAuthorities = 2
            case completed = 3

            internal init(rawValue: Int) {
                switch rawValue {
                case 1:
                    self = .inPreparation
                case 2:
                    self = .submittedToAuthorities
                case 3:
                    self = .completed
                default:
                    self = .gatherInformation
                }
            }
            
            internal init(rawString: String) {
                switch rawString.lowercased() {
                case "initiated":
                    self = .initiated
                case "informationrequestissued":
                    self = .gatherInformation
                case "certificatereceived":
                    self = .completed
                case "submittedtoauthorities":
                    self = .submittedToAuthorities
                default:
                    self = .inPreparation
                }
            }

            func key() -> Int {
                return self.rawValue
            }
            
            func order() -> Int {
                return self.rawValue
            }
        }
        
        internal enum missingInfoFrom: Int {
            case none = 0
            case assignee = 1
            case company = 2
            case pwc = 3
            
            internal init(rawString: String) {
                switch rawString.lowercased() {
                case "assignee":
                    self = .assignee
                case "company", "client":
                    self = .company
                case "pwc":
                    self = .pwc
                default:
                    self = .none
                }
            }
            
            internal init(rawValue: Int) {
                switch rawValue {
                case 1:
                    self = .assignee
                case 2:
                    self = .company
                case 3:
                    self = .pwc
                default:
                    self = .none
                }
            }
        }
        
        internal enum extendedServiceType: Int {
            case unknown = -1
            case ARKitBriefing = 0
            
            internal init(rawValue: Int) {
                switch rawValue {
                case 0:
                    self = .ARKitBriefing
                default:
                    self = .unknown
                }
            }
            
        }
        
        internal enum typeOfServiceStatus: Int {
            case unknown = -1
            case taxStandardItem = 0
            case immigrationStandardItem = 1
            case certificateOfCoverageItem = 2
            case briefingItem = 3
            case digitalBriefing = 4
            internal init(rawValue: Int) {
                switch rawValue {
                case 0:
                    self = .taxStandardItem
                case 1:
                    self = .immigrationStandardItem
                case 2:
                    self = .certificateOfCoverageItem
                case 3:
                    self = .briefingItem
                case 4:
                    self = .digitalBriefing
                default:
                    self = .unknown
                }
            }
        }
    }

}

internal struct HomeMissingInfoPresenter {
    static func determineStatus(_ models: [MissingInformationModel]) -> Enums.StatusOfWorkEnums.missingInfoStatus {
        if models.isEmpty {
            return .none
        }
        if models.filter({ $0.from == Enums.StatusOfWorkEnums.missingInfoFrom.assignee }).notEmpty {
            return .assignee
        }
        
        let hasCompanyMissingInfo: Bool = models.filter({ $0.from == Enums.StatusOfWorkEnums.missingInfoFrom.company }).notEmpty
        let hasPwCMissingInfo: Bool = models.filter({ $0.from == Enums.StatusOfWorkEnums.missingInfoFrom.pwc }).notEmpty
        
        if hasCompanyMissingInfo && hasPwCMissingInfo {
            return .companyAndPwC
        }
        
        if hasCompanyMissingInfo {
            return .company
        }

        if hasPwCMissingInfo {
            return .pwc
        }
        return .none
    }
}

extension Array {
    var notEmpty: Bool {
        // swiftlint:disable empty_count
        return self.count > 0
    }
}

internal struct CalendarConstants {
    struct dateFormats {
        internal static let calendarDateFormat: String = "yyyy-MM-dd"
        internal static let calendarDateTimeFormat: String = "yyyy-MM-dd HH:mm'Z'"
        internal static let calendarDateDisplayFormat: String = "d MMM YYYY"
    }
}
internal final class DateFormatManager {
    
    internal enum DateFormatterType: Int {
        case calendarDateForAPI = 0
        case timeShortFormat = 1
        case calendarDateDisplay = 2
        case calendarDateTimeForAPI = 3
    }
    
    private var cachedFormatters = [Int: DateFormatter]()
    
    static let shared: DateFormatManager = {
        let instance = DateFormatManager()
        return instance
    }()
    
    private init() { }
    
    static let utcDateForAPI: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = AppConst.apiDateFormat
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static func dateMediumStyle(_ timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    static func dateFromDateFormat(_ dateFormat: String, timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }

    static func dateFullStyle(_ timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = .full
        return dateFormatter
    }
    
    func get(_ formatterName: DateFormatterType) -> DateFormatter {
        if let cachedFormatter: DateFormatter = cachedFormatters[formatterName.rawValue] {
            return cachedFormatter
        }
        switch formatterName {
        case .calendarDateForAPI:
            return calendarDateForAPI()
        case .timeShortFormat:
            return timeShortFormat()
        case .calendarDateDisplay:
            return calendarDateDisplay()
        case .calendarDateTimeForAPI:
            return calendarDateTimeForAPI()
        }
    }

    private func timeShortFormat() -> DateFormatter {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        cachedFormatters[DateFormatterType.timeShortFormat.rawValue] = timeFormatter
        return timeFormatter
    }
    
    private func calendarDateForAPI() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = CalendarConstants.dateFormats.calendarDateFormat
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        cachedFormatters[DateFormatterType.calendarDateForAPI.rawValue] = formatter
        return formatter
    }
    
    private func calendarDateDisplay() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = CalendarConstants.dateFormats.calendarDateDisplayFormat
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        cachedFormatters[DateFormatterType.calendarDateDisplay.rawValue] = formatter
        return formatter
    }
    
    private func calendarDateTimeForAPI() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = CalendarConstants.dateFormats.calendarDateTimeFormat
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        cachedFormatters[DateFormatterType.calendarDateTimeForAPI.rawValue] = formatter
        return formatter
    }
}


internal struct AppConst {
    internal static let newLine: String = "\r\n"
    internal static let apiDateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    internal static let confirmationBriefingID: Int = -9099
    internal static let fileSizeWarningLimit: Int = 12000000
    internal static let fileSizeMaxLimit: Int = 24000000
    internal static let defaultDateFormat: String = "0001-01-01T00:00:00Z"
}

internal final class CalendarDateManager {
    private let timeZone: TimeZone = TimeZone.init(identifier: "UTC")!
    
    static let shared: CalendarDateManager = {
        let instance = CalendarDateManager()
        return instance
    }()
    
    private init() { }
    
    private final func getNormalizedDateFormatter(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    private final func getDateUsingFormatMask(_ input: String, format: String, timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Date {
        let dateFormatter = self.getNormalizedDateFormatter(format)
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: input)!
    }

    final func getDatesByRange(from: Date, to: Date) -> [Date] {
        var dates: [Date] = []
        var date = from
        
        while date <= to {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    final func startingYear() -> Date {
        let template: String = "2001-01-01"
        let date = self.getDateUsingFormatMask(template, format: "yyyy-MM-dd", timeZone: timeZone)
        return date
    }
    
//    final func getWeekday(_ input: Date) -> Enums.CalendarEnums.workday {
//        switch input.dayNumberOfWeek() {
//        case 1:
//            return Enums.CalendarEnums.workday.sunday
//        case 2:
//            return Enums.CalendarEnums.workday.monday
//        case 3:
//            return Enums.CalendarEnums.workday.tuesday
//        case 4:
//            return Enums.CalendarEnums.workday.wednesday
//        case 5:
//            return Enums.CalendarEnums.workday.thursday
//        case 6:
//            return Enums.CalendarEnums.workday.friday
//        default:
//            return Enums.CalendarEnums.workday.saturday
//        }
//    }
    
//    final func getDefaultDeviceCalendarFirstDay() -> Int {
//        switch Calendar.current.firstWeekday {
//        case 1:
//            return Enums.CalendarEnums.workday.sunday.getIndex()
//        case 2:
//            return Enums.CalendarEnums.workday.monday.getIndex()
//        case 3:
//            return Enums.CalendarEnums.workday.tuesday.getIndex()
//        case 4:
//            return Enums.CalendarEnums.workday.wednesday.getIndex()
//        case 5:
//            return Enums.CalendarEnums.workday.thursday.getIndex()
//        case 6:
//            return Enums.CalendarEnums.workday.friday.getIndex()
//        default:
//            return Enums.CalendarEnums.workday.saturday.getIndex()
//        }
//    }
    
//    final func getDayIDfromLocalDate(_ input: Date) -> Int? {
//        let template: String = "\(input.year())-\(input.month().zeroPad())-\(input.day().zeroPad())"
//        let date = self.getDateUsingFormatMask(template, format: "yyyy-MM-dd", timeZone: timeZone)
//        return date.between(startingYear(), timeZone: timeZone).day
//    }
//
    final func getDayIDfromUTCDate(_ input: Date) -> Int {
        let template: String = "\(input.yearUTC())-\(input.monthUTC().zeroPad())-\(input.dayUTC().zeroPad())"
        let date = self.getDateUsingFormatMask(template, format: "yyyy-MM-dd", timeZone: timeZone)
        return date.between(startingYear(), timeZone: timeZone).day!
    }

    final func getUTCDateforDayID(_ input: Int) -> Date {
        return startingYear().add(NSCalendar.Unit.day, amount: input, timeZone: timeZone)
    }
//
//    final func getLocalDateforDayID(_ input: Int) -> Date {
//        let date: Date = startingYear().add(NSCalendar.Unit.day, amount: input, timeZone: timeZone)
//        let template: String = "\(date.yearUTC())-\(date.monthUTC().zeroPad())-\(date.dayUTC().zeroPad())"
//        let localDate = self.getDateUsingFormatMask(template, format: "yyyy-MM-dd", timeZone: TimeZone.autoupdatingCurrent)
//        return localDate
//    }
//
//    final func convertDateCompnentsToDayUTCDate(year: Int, month: Int, day: Int) -> Date {
//        let template: String = "\(year)-\(month.zeroPad())-\(day.zeroPad())"
//        let formatter = DateFormatManager.shared.get(.calendarDateForAPI)
//        let date: Date = formatter.date(from: template)!
//        return date
//    }
    
    final func convertAPIDateStringToDayDate(_ input: String) -> Date {
        let formatter = DateFormatManager.shared.get(.calendarDateForAPI)
        let date: Date = formatter.date(from: input) ?? Date()
        return date
    }
    
    final func convertAPIDateStringToDayID(_ input: String) -> Int {
        let formatter = DateFormatManager.shared.get(.calendarDateForAPI)
        return getDayIDfromUTCDate(formatter.date(from: input)!)
    }
    
    final func convertDayIDToAPIDateString(_ input: Int) -> String {
        let date = getUTCDateforDayID(input)
        let formatter = DateFormatManager.shared.get(.calendarDateForAPI)
        return formatter.string(from: date)
    }
}

extension Date {
    internal struct pwcExt {
        static let hashUTCDayFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }()
        static let hashLocalDayFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }()
        static func UTCtoLocal(_ date: Date) -> Date? {
            let dateString = Date.pwcExt.hashLocalDayFormatter.string(from: date)
            return Date.pwcExt.hashLocalDayFormatter.date(from: dateString)
        }
        static func normalizeAMPMTime(hour: Int) -> Int {
            if hour < 13 {
                if hour == 0 {
                    return 12
                }
                return hour
            }
            let result = hour - 12
            return result == 0 ? 12 : result
        }
//        static func getAMPMIndicator(hour: Int) -> String {
//            if hour > 0 && hour < 12 {
//                return "AM".localized
//            }
//            if hour == 24 {
//                return "AM".localized
//            }
//            return "PM".localized
//        }
    }
    
    func hashLocalDay() -> String {
        return Date.pwcExt.hashLocalDayFormatter.string(from: self)
    }
    
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
}

// pecker:ignore all
extension Date {
    // Convert local time to UTC (or GMT)
    func toUTCDate() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalDate() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    private func getCalendar() -> Calendar {
        return self.getCalendar(TimeZone.autoupdatingCurrent)
    }
    
    private func getCalendar(_ timeZone: TimeZone) -> Calendar {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        return calendar
    }
 
    func get(_ unit: NSCalendar.Unit, inUnit: NSCalendar.Unit, timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Int {
        return (self.getCalendar(timeZone) as NSCalendar).ordinality(of: unit, in: inUnit, for: self)
    }
    
    func year(_ timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Int {
        return Calendar.current.dateComponents(in: timeZone, from: self).year!
    }
    
    func month(_ timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Int {
        return self.get(.month, inUnit: .year, timeZone: timeZone)
    }

    func day(_ timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Int {
        return self.get(.day, inUnit: .month, timeZone: timeZone)
    }

    func yearUTC() -> Int {
        return Calendar.current.dateComponents(in: TimeZone.init(identifier: "UTC")!, from: self).year!
    }
    
    func monthUTC() -> Int {
        return self.get(.month, inUnit: .year, timeZone: TimeZone.init(identifier: "UTC")!)
    }
    
    func dayUTC() -> Int {
        return self.get(.day, inUnit: .month, timeZone: TimeZone.init(identifier: "UTC")!)
    }
    
    func hour(_ timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Int {
        return Calendar.current.dateComponents(in: timeZone, from: self).hour!
    }
    
    func add(_ unit: NSCalendar.Unit, amount: Int, timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Date {
        return (self.getCalendar(timeZone) as NSCalendar).date(
            byAdding: unit, value: amount, to: self,
            options: NSCalendar.Options(rawValue: 0))!
    }
    
    func subtract(_ unit: NSCalendar.Unit, amount: Int, timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> Date {
        return self.add(unit, amount: (amount * -1))
    }
    
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func between(_ toDate: Date, units: NSCalendar.Unit = [NSCalendar.Unit.day], timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> DateComponents {
        return (self.getCalendar(timeZone) as NSCalendar).components(units, from: toDate, to: self, options: [])
    }
    
    func is24HourFormat() -> Bool {
        let locale = Locale.current
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
        return dateFormat.range(of: "a") == nil
    }
    
    func tomorrow() -> Date {
        return self.add(.day, amount: 1)
    }

    func tomorrowUTC() -> Date {
        return self.add(.day, amount: 1, timeZone: TimeZone.init(identifier: "UTC")!)
    }
    
    func yesterDay() -> Date {
        return self.subtract(.day, amount: 1)
    }
    
    func dayInYear() -> Int {
        return getCalendar().ordinality(of: .day, in: .year, for: self)!
    }
    
    func getWeekOfYear() -> Int {
        return getCalendar().ordinality(of: .weekOfYear, in: .year, for: self)!
    }
    
    func dayInEra() -> Int {
        return getCalendar().ordinality(of: .day, in: .era, for: self)!
    }
    
    func thisYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func thisMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func lastMonth() -> Int {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!.month()
    }
    
    func nextMonth() -> Int {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!.month()
    }
    
    func startOfMonth() -> Date {
        return Date.from(year: self.year(), month: self.month(), day: 1)!
    }
    
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
    
    func dayNumberOfWeek() -> Int {
        // returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
        let calendar = Calendar.init(identifier: .gregorian)
        return calendar.dateComponents([.weekday], from: self).weekday!
    }

    func dayNumberOfMonth() -> Int {
        return Calendar.current.dateComponents([.day], from: self).day!
    }
    
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func daysInYear() -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .year, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func endOfMonth() -> Date {
        let startOfMonth = Date.from(year: self.year(), month: self.month(), day: 1)
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth!)!
    }
    
    func toComponents() -> (year: Int, month: Int) {
        let year = Calendar.current.component(.year, from: self)
        let month = Calendar.current.component(.month, from: self)
        return (year, month)
    }
    
//    static func getDate(year: Int, month: Int, day: Int) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        let template: String = "\(year)-\(month.zeroPad())-\(day.zeroPad())"
//        return formatter.date(from: template)!
//    }
    
    var millisecondsSince1970: Double {
        (self.timeIntervalSince1970 * 1000.0).rounded()
    }
    
    init(milliseconds:Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

// pecker:ignore all
extension Date {
    static func kernelBootTimerInterval() -> TimeInterval? {
        var managementInformationBase = [CTL_KERN, KERN_BOOTTIME]
        var bootTime: timeval = timeval()
        var bootTimeSize: Int = MemoryLayout<timeval>.size
        guard sysctl(&managementInformationBase, UInt32(managementInformationBase.count), &bootTime, &bootTimeSize, nil, 0) != -1 else { return nil}
        return Date().timeIntervalSince1970 - (TimeInterval(bootTime.tv_sec) + TimeInterval(bootTime.tv_usec) / 1_000_000.0)
    }
}

extension Int {
    
    var toBool: Bool {
        return (self == 1) ? true : false
    }
    
    func toString() -> String {
        return String(self)
    }
    
    var isZero: Bool {
        return self == 0
    }
    
    var notZero: Bool {
        return !isZero
    }
    
  public func zeroPad() -> String {
        if self > 9 || self < 0 {
            return "\(self)"
        }
        return "0\(self)"
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
}
