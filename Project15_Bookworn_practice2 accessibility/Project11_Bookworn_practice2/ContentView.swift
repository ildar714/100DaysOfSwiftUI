//
//  ContentView.swift
//  Project11_Bookworn_practice2
//
//  Created by Ильдар Нигметзянов on 22.03.2020.
//  Copyright © 2020 Ildar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Book.title,ascending: true),NSSortDescriptor(keyPath: \Book.author, ascending: true)]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(books,id: \.self){book in
                    NavigationLink(destination: DetailView(book: book)){
                        
                        EmojiRatingView(rating: book.rating)
                            //.font(.largeTitle)
                        
                        VStack(alignment: .leading){
                            if book.rating == 1 {
                                AnyView(Text(book.title ?? "Unknown Title")
                                    .foregroundColor(Color.red))
                                
                            } else {
                                AnyView(Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                )
                            }
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Bookworn")
                .navigationBarItems(trailing: Button(action:{
                    self.showingAddScreen.toggle()
                }){
                    Image(systemName: "plus")
                })
                .sheet(isPresented:$showingAddScreen){
                    AddBookView().environment(\.managedObjectContext,self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet){
        for offset in offsets {
            let book = books[offset]
            
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
