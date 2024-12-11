import Foundation

final class ShoppingCart {
    private(set) var items: [Item] = []
    private var appliedCoupons: [Coupon] = []
    
    // Adds an item to the cart
    func addItem(_ item: Item) {
        items.append(item)
    }
    
    // Removes an item from the cart
    func removeItem(_ item: Item) {
        items.removeAll { $0.name == item.name && $0.price == item.price && $0.quantity == item.quantity }
    }
    
    // Calculates the total price without discount
    func calculateTotalPrice() -> Double {
        return items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    // Calculates the final price after applying discount
    @discardableResult
    func applyCoupon(_ coupon: Coupon) -> Bool {
        guard !appliedCoupons.contains(where: { $0.code == coupon.code }) else { return false }
        let total = calculateTotalPrice()
        if let _ = coupon.apply(to: total) {
            appliedCoupons.append(coupon)
            return true
        }
        return false
    }
    
    // Calculate final price with coupon discounts
    func calculateFinalPrice() -> Double {
        let total = calculateTotalPrice()
        let totalDiscount = appliedCoupons.reduce(0) { partialResult, currentCoupon in
            partialResult + (currentCoupon.apply(to: total) ?? 0)
        }
        return total - totalDiscount
    }

}

