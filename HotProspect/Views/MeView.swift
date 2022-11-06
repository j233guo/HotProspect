//
//  MeView.swift
//  HotProspect
//
//  Created by Jiaming Guo on 2022-11-06.
//

import SwiftUI

struct MeView: View {
    var body: some View {
        NavigationView {
            Text("Me")
                .navigationTitle("Me")
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
