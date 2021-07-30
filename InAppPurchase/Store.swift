	//
	//  Store.swift
	//  Store
	//
	//  Created by Massa Antonio on 30/07/21.
	//

import Foundation
import SwiftUI
import StoreKit

class ViewModel: ObservableObject {
	@Published var products: [Product] = []
	@Published var purchasedIds: [String] = []

	func fetchProducts() {
		Task.init {
			do {
				let products = try await Product.products(for: ["com.apple.watch_new"])
				DispatchQueue.main.async {
					self.products = products
				}
				if let product = products.first {
					await isPurchased(product: product)
				}
			} catch {
				print(error)
			}
		}
	}

	func isPurchased(product: Product) async {
		guard let state = await product.currentEntitlement else { return }
		print("Checking state")
		switch state {
			case .verified(let transaction):
				DispatchQueue.main.async {
					self.purchasedIds.append(transaction.productID)
				}
			case .unverified(_):
				break
		}
	}
	func purchase() {
		Task.init {
			guard let product = products.first else { return }
			do {
				let result = try await product.purchase()
				switch result {
					case .success(let verification):
						switch verification {
							case .verified(let transaction):
								DispatchQueue.main.async {
									self.purchasedIds.append(transaction.productID)
								}
							case .unverified(_):
								break
						}
						break
					case .userCancelled:
						break
					case .pending:
						break
					@unknown default:
						break
				}
			} catch {
				print(error)
			}
		}
	}
}

