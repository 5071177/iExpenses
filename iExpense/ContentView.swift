//
//  ContentView.swift
//  iExpense
//
//  Created by Yury Prokhorov on 13.01.2022.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable, Equatable {
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
    
    var personalItems: [ExpenseItem] {
        items.filter {$0.type == "Personal"}
    }
    
    var businessItems: [ExpenseItem] {
        items.filter {$0.type == "Business"}
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
    
    
    func removeItems(at offsets: IndexSet, in inputArray: [ExpenseItem]) {
        var objectsToDelete = IndexSet()
        
        for offset in offsets {
            let item = inputArray[offset]
            
            if let index = expenses.items.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }
        expenses.items.remove(atOffsets: objectsToDelete)
    }
    
    func removePersonalItems (at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.personalItems)
    }
    
    func removeBusinessItems (at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.businessItems)
    }
    
    
    var body: some View{
        NavigationView {
            List{
                ExpenseSection(title: "Business", expenses: expenses.businessItems, deleteItems: removeBusinessItems)
                
                ExpenseSection(title: "Personal", expenses: expenses.personalItems, deleteItems: removePersonalItems)
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
            .navigationTitle("iExpenses")
        }
        
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
