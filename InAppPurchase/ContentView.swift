//
//  ContentView.swift
//  InAppPurchase
//
//  Created by Massa Antonio on 30/07/21.
//

import SwiftUI
import StoreKit

//Fetch Products
//Purchase Product
//Update UI

struct ContentView: View {
	@StateObject var viewModel = ViewModel()

    var body: some View {
		VStack {
			Image(systemName: "applelogo")
				.resizable()
				.aspectRatio(nil, contentMode: .fit)
				.frame(width: 70, height: 70)

			Text("Apple Store")
				.bold()
				.font(.system(size: 32))

			Image("watch")
				.resizable()
				.frame(width: 250, height: 250)
				.aspectRatio(nil, contentMode: .fit)

			if let product = viewModel.products.first {
				Text(product.displayName)
				Text(product.description)
				Button(action: {
					if viewModel.purchasedIds.isEmpty {
						viewModel.purchase()
					}
				}) {
					Text(viewModel.purchasedIds.isEmpty ? "Buy Now \(product.displayPrice)" : "Purchased")
						.bold()
						.foregroundColor(Color.white)
						.frame(width: 220, height: 50)
						.background(viewModel.purchasedIds.isEmpty ? Color.blue : Color.green)
						.cornerRadius(10)
				}
			}
		}
		.onAppear {
				viewModel.fetchProducts()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
