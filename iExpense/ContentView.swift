//
//  ContentView.swift
//  iExpense
//
//  Created by Yury Prokhorov on 13.01.2022.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items" )
            }
        }
    }
    
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                
                return
            }
        }
    
    items = []
    }
}





struct ContentView: View {
    
    @StateObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    
    var body: some View{
        NavigationView {
            List{
                ForEach(expenses.items){ item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
            .toolbar{
                Button{
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("iExpenses")
        
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
