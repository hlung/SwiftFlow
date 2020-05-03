//
//  ContentView.swift
//  SwiftFlow
//
//  Created by Kolyutsakul, Thongchai on 3/5/20.
//  Copyright © 2020 Thongchai Kolyutsakul. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      GraphViewWrapper()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
