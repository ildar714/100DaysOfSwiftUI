//
//  AstronautView.swift
//  Project8_Moonshot_practice
//
//  Created by Ильдар Нигметзянов on 09.03.2020.
//  Copyright © 2020 Ildar. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut
    let mission: Mission
    
    var body: some View {
        GeometryReader{ geometry in
            ScrollView(.vertical){
                VStack{
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .accessibility(removeTraits: .isImage)
                    Text("Mission: \(self.mission.displayName)")
                    Text(self.astronaut.description)
                        .padding()
                    .layoutPriority(1)
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name),displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let mission: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0],mission: mission[0])
    }
}
