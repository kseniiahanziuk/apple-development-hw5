import XCTest
@testable import hw5

final class BankAccountTests: XCTestCase {
    
    func testPositiveDeposit() {
        let bankAccount = BankAccount()
        bankAccount.deposit(amount: 500.0)
        XCTAssertEqual(bankAccount.balance, 500.0, "Balance should be equal to the added positive amount.")
    }
    
    func testNegativeDeposit() {
        let bankAccount = BankAccount()
        bankAccount.deposit(amount: -600.0)
        XCTAssertEqual(bankAccount.balance, 0.0, "Balance should not be affected by a negative deposit.")
    }
    
    func testWithdrawalWithinBalance() {
        let bankAccount = BankAccount()
        bankAccount.deposit(amount: 100.0)
        let result = bankAccount.withdraw(amount: 50.0)
        
        XCTAssertEqual(result, true, "Withdrawal should succeed within balance.")
        XCTAssertEqual(bankAccount.balance, 50.0, "Balance should decrease by the withdrawal.")
    }
    
    func testNegativeWithdrawal() {
        let bankAccount = BankAccount()
        bankAccount.deposit(amount: 100.0)
        let result = bankAccount.withdraw(amount: -50.0)
        
        XCTAssertEqual(result, false, "Withdrawal should fail with a negative num.")
        XCTAssertEqual(bankAccount.balance, 100.0, "Balance shouldn't decrease by a negative withdrawal.")
    }
    
    func testWithdrawalExceedingBalance() {
        let bankAccount = BankAccount()
        bankAccount.deposit(amount: 50.0)
        let result = bankAccount.withdraw(amount: 150.0)
        
        XCTAssertEqual(result, false, "Withdrawal should fail when it exceeds balance.")
        XCTAssertEqual(bankAccount.balance, 50.0, "Balance should stay unchanged after a withdrawal failure.")
    }
    
    func testTakingCreditWithinLimit() {
        let bankAccount = BankAccount()
        let result = bankAccount.takeCredit(amount: 500.0)
        XCTAssertEqual(result, true, "Taking credit within limit should succeed.")
        XCTAssertEqual(bankAccount.balance, 500.0, "Balance should include the taken credit.")
        XCTAssertEqual(bankAccount.creditLoan, 500.0, "Credit loan should reflect the taken credit.")
    }
    
    func testTakingCreditExceedingLimit() {
        let bankAccount = BankAccount()
        let result = bankAccount.takeCredit(amount: 50000.0)
        XCTAssertEqual(result, false, "Taking credit exceeding the limit should fail.")
        XCTAssertEqual(bankAccount.balance, 0.0, "Balance should stay unchanged after a credit failure.")
    }
    
    func testPayingCreditWithinLoan() {
        let bankAccount = BankAccount()
        let credit = bankAccount.takeCredit(amount: 2000.0)
        let result = bankAccount.payCredit(amount: 500.0)
        XCTAssertEqual(result, true, "Paying within credit loan should succeed.")
        XCTAssertEqual(bankAccount.creditLoan, 1500.0, "Credit loan should decrease by credit payment.")
    }
    
    func testPayingCreditExceedingLoan() {
        let bankAccount = BankAccount()
        let credit = bankAccount.takeCredit(amount: 2000.0)
        let result = bankAccount.payCredit(amount: 3000.0)
        XCTAssertEqual(result, false, "Paying credit loan exceeding the credit should fail.")
        XCTAssertEqual(bankAccount.creditLoan, 2000.0, "Credit loan should stay unchanged after credit payment failure.")
    }
    
    func testTransactionHistory() {
        let bankAccount = BankAccount()
        bankAccount.deposit(amount: 100.0)
        _ = bankAccount.withdraw(amount: 10.0)
        _ = bankAccount.takeCredit(amount: 200.0)
        let transactions = bankAccount.getTransactionHistory()
        XCTAssertEqual(transactions.count, 3)
        XCTAssertEqual(transactions[0].type, .deposit)
        XCTAssertEqual(transactions[1].type, .withdrawal)
        XCTAssertEqual(transactions[2].type, .credit)
    }
}
