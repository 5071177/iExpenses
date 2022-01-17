//
//  FormatStyle-LocalCurrency.swift
//  iExpense
//
//  Created by Yury Prokhorov on 17.01.2022.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var localCurrency: Self {
        .currency(code: Locale.current.currencyCode ?? "USD")
    }
}
