//
//  DetailsView.swift
//  SpendKeeper
//
//  Created by Mehmet Jiyan Atalay on 20.07.2024.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var spendings: [Spendings] = [Spendings(amount: 0, description: "", day: 0)]
    
    @FocusState private var isInputActive: Bool
    
    var item : Item
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("\(item.getMonthName() ?? "") Harcamaları")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Total : \(item.totalSpendings)")
                        .font(.title2)
                    
                    ForEach(0..<spendings.count, id: \.self) { index in
                        GroupBox {
                            VStack {
                                HStack {
                                    TextField("Enter description", text: $spendings[index].description)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .focused($isInputActive)
                                }.padding(.vertical, 5)
                                HStack {
                                    TextField("Enter amount", text: Binding(get: {
                                        String(spendings[index].amount)
                                    }, set: {
                                        if let value = Int($0) {
                                            spendings[index].amount = value
                                        }
                                    }))
                                    .keyboardType(.numberPad)
                                    .focused($isInputActive)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onChange(of: spendings[index].amount) {
                                        item.totalSpendings = spendings.reduce(0) { $0 + $1.amount}
                                    }
                                    
                                    Picker("", selection: $spendings[index].day) {
                                        ForEach(Array(stride(from: 0, through: 30, by: 1)), id: \.self) { i in
                                            Text("Day \(i)").tag(i)
                                        }
                                    }
                                    .frame(width: 100)
                                    .clipped()
                                    
                                    Button(action: {
                                        withAnimation {
                                            spendings.remove(at: index)
                                            item.totalSpendings = spendings.reduce(0) { $0 + $1.amount}
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal)
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                spendings.append(Spendings(amount: 0, description: "", day: 0))
                            }
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding()
                        
                        Button(action: {
                            
                            item.spendings = spendings
                            
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            dismiss()
                            
                        }, label: {
                            Text("Save")
                                .padding()
                                .foregroundColor(.blue)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                        })
                    }
                    Spacer()
                }
            }.toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
        }
        .onAppear {
            self.spendings = self.item.spendings
        }
        
    }
}

#Preview {
    DetailsView(item: Item(month: 7, year: 2024))
}
