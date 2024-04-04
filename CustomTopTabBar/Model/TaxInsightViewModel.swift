//
//  TaxInsightViewModel.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 16/03/23.
//

import UIKit

class TaxInsightViewModel: UIViewController, ObservableObject {

    @Published var viewSummaryData = [TaxStatusOfWorkModel]()
    
    static var currencyType = ""
    
    @Published var tasksInComplete : [TasksModel] = []
    var efileData  = [TasksModel]()
    var efileChips : [String] = []
    var paperData = [TasksModel]()
    var paperChips : [String] = []
    var paymentData = [TasksModel]()
    var paymentChips : [String] = []
    
    @Published var tasksComplete : [TasksModel] = []
    var efileDataC  = [TasksModel]()
    var efileChipsC : [String] = []
    var paperDataC = [TasksModel]()
    var paperChipsC : [String] = []
    var paymentDataC = [TasksModel]()
    var paymentChipsC : [String] = []
    var moneyValue = [Int]()
    var moneyValueC = [Int]()
    
    @Published var taxResultsView : [TaxReturnResultsModel] =  []
    var refundToMe = [TaxReturnResultsModel]()
    var paymentDue = [TaxReturnResultsModel]()
    var refundToMeChips : [String] = []
    var paymentDueChips : [String] = []
    var refundToMeValue = [Int]()
    var paymentDueValue = [Int]()
    
    func dataAdded(){
        let jsonArray = """
                        [{"countryExtraInfo":"","taxYear":2022,"currency":"USD","taxPeriod":{"startDate":"0001-01-01T00:00:00Z","endDate":"0001-01-01T00:00:00Z"},"estimatedCompleteDate":"2023-06-22T00:00:00Z","documentDeliverables":{"taxReturn":1,"teq":0,"other":0},"questionnaire":{"dueDate":"2023-03-30T12:00:00Z","milestones":[{"name":"Notified","status":"Done","doneDate":"2023-03-16T00:00:00Z"},{"name":"InProcess","status":"Done","doneDate":"2023-03-16T00:00:00Z"},{"name":"Submitted","status":"Done","doneDate":"2023-03-16T00:00:00Z"}]},"milestones":[{"name":"TaxReturnInProcess","status":"Done","doneDate":"2023-03-24T00:00:00Z"},{"name":"TaxReturnDelivered","status":"Done","doneDate":"2023-03-24T00:00:00Z"},{"name":"TaxReturnCompleted","status":"InProgress","doneDate":null}],"missingInformation":[],"taxReturnInfo":{"hasRejectedConsents":false,"files":[{"fileId":"5fafbf3e-6581-4a23-9d79-18b47a757bfd","firstDownloadAt":"2023-03-24T07:15:23"},{"fileId":"b1823bc7-c1b9-4c4c-b184-6a2b4cba0714","firstDownloadAt":"2023-03-24T07:15:25"},{"fileId":"777ec3c2-467b-475e-acb8-9954cf973d83","firstDownloadAt":"2023-03-24T07:15:26"},{"fileId":"abf2aa45-f401-4cc7-9daa-b4ea15fb548d","firstDownloadAt":"2023-03-24T07:15:28"},{"fileId":"adfa8e18-90c6-426a-8f00-c18d425c9bf2","firstDownloadAt":"2023-03-23T17:50:45"},{"fileId":"0d85be8e-8831-4951-b6b4-d27fbbc83000","firstDownloadAt":"2023-03-16T12:06:43"}],"efile":{"id":null,"hasSigned":false,"isJointEfile":false,"hasInvited":false,"hasJointSigned":false,"hasOptOut":false},"efileJurisdictions":["Federal","California"],"latestTaxReturnFileId":"abf2aa45-f401-4cc7-9daa-b4ea15fb548d","hasFilingItem":true,"isDashboardPublished":true,"filingDetails":[{"id":13949,"taxAuthority":"Federal","filingStatus":"Taxpayer","filingMethod":"EFile","consentMethod":"ElectronicConsent","refundOrPaymentDue":500.00,"refundOrPaymentDueOption":"RefundSentToAssignee","actionDueDate":"2023-04-30T00:00:00","filingAddress":null,"refundLink":"https://www.irs.gov/refunds","paymentLink":"https://www.irs.gov/payments","taxAuthorityType":"Federal","efileId":null,"statusOfFiling":"NotTransmitted","acceptedDate":null,"markAsPaid":false,"markAsFiled":false},{"id":14013,"taxAuthority":"California","filingStatus":"Taxpayer","filingMethod":"EFile","consentMethod":"ElectronicConsent","refundOrPaymentDue":12200.00,"refundOrPaymentDueOption":"RefundSentToAssignee","actionDueDate":"2023-04-23T00:00:00","filingAddress":null,"refundLink":"https://www.ftb.ca.gov/refund/index.asp","paymentLink":"https://www.ftb.ca.gov/pay/","taxAuthorityType":"State","efileId":null,"statusOfFiling":"NotTransmitted","acceptedDate":null,"markAsPaid":false,"markAsFiled":false}],"taxEqualization":{"taxEqualizationAmount":null,"fileIds":[]},"taxHighlights":{"employmentIncome":1000,"personalIncome":20000,"totalIncome":21000,"effectiveTaxRate":0.2200,"taxBalanceReason":"Personal income due to stocks"},"voucherFileIds":["f39c1e26-ffe8-4072-9feb-f993ff9c2fab"],"workRecordOtherFileIds":[]},"canVerifyIdentityForEsign":true,"efileElectronicConsentSignRequired":true,"pendingAssigneeDownloadTaxReturnFiles":false,"id":586549,"name":"2022 - US - Rizzy Global US Tax Return","practiceType":"Tax","primaryService":"Rizzy Global US Tax Return","countryCode":"US"}]
                    """
        do {
            let jsonArray = try JSONDecoder().decode([TaxStatusOfWorkModel].self, from: jsonArray.data(using: .utf8)!)
            self.viewSummaryData = jsonArray
            TaxInsightViewModel.currencyType = jsonArray[0].currency
            self.tasksModel()
        } catch {
            print(error)
        }
    }
  
    func tasksModel(){
        let data = viewSummaryData[0].taxReturnInfo!.filingDetails
        for index in 0..<data.count {

            if data[index]!.filingMethod.lowercased() == "efile" && !(viewSummaryData[0].taxReturnInfo?.efile!.hasSigned)!{
                self.efileChips.append(data[index]!.taxAuthority)
                self.efileData = [TasksModel(image: "efileIcon", imageName: "E-FILE", chips: Array(Set(efileChips)), taskName: "Complete E-file requirements", taskDueDate: "Due \(data[index]!.actionDueDate!)")]
            }
            
            if data[index]!.filingMethod.lowercased() == "paperfile" && !data[index]!.markAsFiled{
                self.paperChips.append(data[index]!.taxAuthority)
                self.paperData = [TasksModel(image: "paperfileIcon", imageName: "PAPER FILE", chips: Array(Set(paperChips)), taskName: "Complete Paper Filing", taskDueDate: "Due \(data[index]!.actionDueDate!)")]
            }
            
            if !data[index]!.markAsPaid {
                self.paymentChips.append(data[index]!.taxAuthority)
                if data[index]!.refundOrPaymentDue < 0 {
                    self.moneyValue.append(data[index]!.refundOrPaymentDue)
                    self.paymentData = [TasksModel(image: "paymentIcon", imageName: "PAYMENT", chips: Array(Set(paymentChips)), taskName: "Complete tax payment of \(abs(moneyValue.reduce(0, +))) \(viewSummaryData[0].currency)", taskDueDate: "Due Apr \(data[index]!.actionDueDate!)")]
                }
                
            }
        }
        
        if !efileData.isEmpty {
            self.tasksInComplete.append(efileData[0])
        }
        if !paperChips.isEmpty {
            self.tasksInComplete.append(paperData[0])
        }
        if !paymentData.isEmpty {
            self.tasksInComplete.append(paymentData[0])
        }
        for index in 0..<data.count {
            if data[index]!.filingMethod.lowercased() == "efile" && (viewSummaryData[0].taxReturnInfo?.efile!.hasSigned)!{
                self.efileChipsC.append(data[index]!.taxAuthority)
                self.efileDataC = [TasksModel(image: "completedIcon", imageName: "E-FILE", chips: Array(Set(efileChipsC)), taskName: "Complete E-file requirements", taskDueDate: "Filed on \(data[index]!.actionDueDate!)")]
            }
            
            if data[index]!.filingMethod.lowercased() == "paperfile" && data[index]!.markAsFiled{
                self.paperChipsC.append(data[index]!.taxAuthority)
                self.paperDataC = [TasksModel(image: "completedIcon", imageName: "PAPER FILE", chips: Array(Set(paperChipsC)), taskName: "Complete Paper Filing", taskDueDate: "Filed on \(data[index]!.actionDueDate!)")]
            }
            
            if data[index]!.markAsPaid {
                self.paymentChipsC.append(data[index]!.taxAuthority)
                if data[index]!.refundOrPaymentDue < 0 {
                    self.moneyValueC.append(data[index]!.refundOrPaymentDue)
                }
                self.paymentDataC = [TasksModel(image: "completedIcon", imageName: "PAYMENT", chips: Array(Set(paymentChipsC)), taskName: "Complete tax payment of \(abs(moneyValueC.reduce(0, +))) \(viewSummaryData[0].currency)", taskDueDate: "Paid on \(data[index]!.actionDueDate!)")]
            }
        }
        
        if !efileDataC.isEmpty {
            self.tasksComplete.append(efileDataC[0])
        }
        if !paperChipsC.isEmpty {
            self.tasksComplete.append(paperDataC[0])
        }
        if !paymentDataC.isEmpty {
            self.tasksComplete.append(paymentDataC[0])
        }
        
        
        for index in 0..<data.count {
            if data[index]!.refundOrPaymentDue < 0 {
                self.refundToMeChips.append(data[index]!.taxAuthority)
                self.refundToMeValue.append(data[index]!.refundOrPaymentDue)
                self.refundToMe = [TaxReturnResultsModel(header: "REFUNDED TO ME", chips: refundToMeChips, value: refundToMeValue)]
            }
            
            if data[index]!.refundOrPaymentDue > 0 {
                self.paymentDueChips.append(data[index]!.taxAuthority)
                self.paymentDueValue.append(data[index]!.refundOrPaymentDue)
                self.paymentDue = [TaxReturnResultsModel(header: "PAYMENTS DUE FROM ME", chips: paymentDueChips, value: paymentDueValue)]
            }
            
        }
        
        if !refundToMe.isEmpty {
            self.taxResultsView.append(refundToMe[0])
        }
        if !paymentDue.isEmpty {
            self.taxResultsView.append(paymentDue[0])
        }
    }
    
//    func taxReturnModel(){
//        for value in viewSummaryData[0].taxReturnInfo.filingDetails{
//            self.filingList = [FilingList(icon: value.markAsFiled ? "checkmark-circle" : value.markAsPaid ? "info" : "alert-circle-bold", filingMethod: value.filingMethod.lowercased() == "efile" ? "E-File Consent Required" :  value.filingMethod.lowercased() == "paper" ?  "Paper Filing \(value.markAsFiled ? "Complete" : "Required")" : "1,450 USD \(value.markAsPaid ? "Refund" : "Payment Due")", constentMethod: value.filingMethod == "paper" && value.markAsFiled  ? "Marked as Filed on Feb 16, 2023" :  value.filingMethod.lowercased() != "efile" && value.markAsPaid ? "This refund will be sent directly to your employer" : value.taxAuthority.lowercased() != "efile" && !value.markAsPaid ? "This payment will be direct debited from your account" : "", trackFund: value.markAsPaid), FilingList(icon: value.markAsFiled ? "checkmark-circle" : value.markAsPaid ? "info" : "alert-circle-bold", filingMethod: value.filingMethod.lowercased() == "efile" ? "E-File Consent Required" :  value.filingMethod.lowercased() == "paper" ?  "Paper Filing \(value.markAsFiled ? "Complete" : "Required")" : "1,450 USD \(value.markAsPaid ? "Refund" : "Payment Due")", constentMethod: value.filingMethod == "paper" && value.markAsFiled  ? "Marked as Filed on Feb 16, 2023" :  value.filingMethod.lowercased() != "efile" && value.markAsPaid ? "This refund will be sent directly to your employer" : value.taxAuthority.lowercased() != "efile" && !value.markAsPaid ? "This payment will be direct debited from your account" : "", trackFund: value.markAsPaid)]
//            print(self.filingList)
//        }
//        
//        for value in viewSummaryData[0].taxReturnInfo.filingDetails{
//            self.filingDetails.append(FilingDetails(taxAuthority: value.taxAuthority, isCompleted: false, filingList: filingList))
//            print(self.filingDetails)
//        }
//
//        for value in viewSummaryData[0].taxReturnInfo.filingDetails {
//            self.filingDetails.append(FilingDetails(taxAuthority: <#T##String#>, isCompleted: <#T##Bool#>, filingList: filingList))
//        }
//
//        for value in viewSummaryData{
//            self.taxReturnData.append(TaxReturnModel(actionType: <#Bool#>, tasks: <#String#>, filingDetails: filingDetails))
//        }
        
//        self.taxReturnData.append(TaxReturnModel(actionType: true, tasks: "5 Tasks Complete", filingDetails: [FilingDetails(taxAuthority: "Federal", isCompleted: false, filingList: [FilingList(icon: "alert-circle-bold", filingMethod: "E-File Consent Required", constentMethod: "", trackFund: false), FilingList(icon: "info", filingMethod: "856 USD Refund", constentMethod: "", trackFund: true)]), FilingDetails(taxAuthority: "Ohio", isCompleted: true, filingList: [FilingList(icon: "checkmark-circle", filingMethod: "Paper Filing Complete", constentMethod: "Marked as Filed on Feb 16, 2023", trackFund: false), FilingList(icon: "info", filingMethod: "5,643.23 USD Refund", constentMethod: "This refund will be applied to your next year tax due", trackFund: true)]), FilingDetails(taxAuthority: "District of Colombia", isCompleted: false, filingList: [FilingList(icon: "alert-circle-bold", filingMethod: "Paper Filing Required", constentMethod: "", trackFund: false), FilingList(icon: "alert-circle-bold", filingMethod: "5,643.23 USD Payment Due", constentMethod: "This payment due will be made by your employer", trackFund: false)])]))
//    }

}

//Test Case 1 :
//[{"countryExtraInfo":"","taxYear":2022,"currency":"USD","taxPeriod":{"startDate":"0001-01-01T00:00:00Z","endDate":"0001-01-01T00:00:00Z"},"estimatedCompleteDate":"2022-12-31T00:00:00Z","documentDeliverables":{"taxReturn":"FileReadyToDownload","teq":"NoFileToDownload","other":"NoFileToDownload"},"questionnaire":{"dueDate":"2022-12-31T12:00:00Z","milestones":[{"name":"Notified","status":"Done","doneDate":"2022-07-12T00:00:00Z"},{"name":"InProcess","status":"Done","doneDate":"2022-07-12T00:00:00Z"},{"name":"Submitted","status":"Done","doneDate":"2022-07-12T00:00:00Z"}]},"milestones":[{"name":"TaxReturnInProcess","status":"Done","doneDate":"2022-07-12T00:00:00Z"},{"name":"TaxReturnDelivered","status":"Done","doneDate":"2022-07-12T00:00:00Z"},{"name":"TaxReturnCompleted","status":"NotStarted","doneDate":"2022-07-12T00:00:00Z"}],"missingInformation":[],"taxReturnInfo":{"hasRejectedConsents":false,"files":[{"fileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","firstDownloadAt":"usa"}],"efile":{"id":13345,"hasSigned":false,"isJointEfile":true,"hasInvited":false,"hasJointSigned":true,"hasOptOut":false},"efileJurisdictions":["Federal","California"],"latestTaxReturnFileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","hasFilingItem":true,"isDashboardPublished":true,"filingDetails":[{"id":12434,"taxAuthority":"Federal","filingStatus":"Taxpayer","filingMethod":"EFile","consentMethod":"ElectronicConsent","refundOrPaymentDue":-4758.00,"actionDueDate":"2022-09-01T00:00:00","filingAddress":"Canada","refundLink":"https://www.irs.gov/refunds","paymentLink":"https://www.irs.gov/payments","taxAuthorityType":"Federal","efileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","statusOfFiling":"NotTransmitted","acceptedDate":"2023-03-31","markAsPaid":false,"markAsFiled":false},{"id":12451,"taxAuthority":"California","filingStatus":"Joint","filingMethod":"EFile","consentMethod":"ElectronicConsent","refundOrPaymentDue":894.00,"actionDueDate":"2023-03-25","filingAddress":"Canada","refundLink":"https://www.ftb.ca.gov/refund/index.asp","paymentLink":"https://www.ftb.ca.gov/pay/","taxAuthorityType":"State","efileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","statusOfFiling":"NotTransmitted","acceptedDate":"2023-03-31","markAsPaid":false,"markAsFiled":false},{"id":12453,"taxAuthority":"Ohio","filingStatus":"Taxpayer","filingMethod":"EFile","consentMethod":"ElectronicConsent","refundOrPaymentDue":-357.00,"actionDueDate":"2022-10-15T00:00:00","filingAddress":"Canada","refundLink":"https://tax.ohio.gov/wps/portal/gov/tax/individual/refund-status/check-my-refund-status","paymentLink":"https://tax.ohio.gov/wps/portal/gov/tax/individual/pay-online/payonline","taxAuthorityType":"State","efileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","statusOfFiling":"NotTransmitted","acceptedDate":"2023-03-31","markAsPaid":true,"markAsFiled":false},{"id":12678,"taxAuthority":"Utah","filingStatus":"Taxpayer","filingMethod":"EFile","consentMethod":"ElectronicConsent","refundOrPaymentDue":0.00,"actionDueDate":"2023-03-25","filingAddress":"Canada","refundLink":"https://tap.tax.utah.gov/TaxExpress/_/#1","paymentLink":"https://tap.tax.utah.gov/TaxExpress/_/#1","taxAuthorityType":"State","efileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","statusOfFiling":"NotTransmitted","acceptedDate":"2023-03-31","markAsPaid":false,"markAsFiled":false},{"id":12454,"taxAuthority":"Cincinnati, OH","filingStatus":"Taxpayer","filingMethod":"PaperFile","consentMethod":"None","refundOrPaymentDue":-656.00,"actionDueDate":"2023-03-25","filingAddress":"Canada","refundLink":"https://www.cincinnati-oh.gov/finance/income-taxes/","paymentLink":"https://www.cincinnati-oh.gov/finance/income-taxes/e-filing/","taxAuthorityType":"Local","efileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","statusOfFiling":"None","acceptedDate":"2023-03-31","markAsPaid":true,"markAsFiled":true},{"id":12452,"taxAuthority":"FBAR","filingStatus":"Joint","filingMethod":"EFile","consentMethod":"ElectronicConsent","refundOrPaymentDue":0.00,"actionDueDate":"2023-03-25","filingAddress":"Canada","refundLink":"","paymentLink":"","taxAuthorityType":"NonPaymentReturn","efileId":"e36f205b-6ff5-4a0d-b071-366ca4e8df96","statusOfFiling":"NotTransmitted","acceptedDate":"2023-03-31","markAsPaid":false,"markAsFiled":false}],"taxEqualization":{"taxEqualizationAmount":-600.00,"fileIds":[]},"taxHighlights":{"employmentIncome":100000,"personalIncome":20000,"totalIncome":120000,"effectiveTaxRate":0.2200,"taxBalanceReason":"You have a tax liability due on your sale of HSBC stock that created capital gains for you and your spouse within the tax year "},"voucherFileIds":[],"workRecordOtherFileIds":[]},"canVerifyIdentityForEsign":true,"efileElectronicConsentSignRequired":true,"pendingAssigneeDownloadTaxReturnFiles":true,"id":577395,"name":"2022 - US - Tax Return","practiceType":"Tax","primaryService":"Tax Return","countryCode":"US"}]
