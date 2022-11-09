//
//  MeView.swift
//  HotProspect
//
//  Created by Jiaming Guo on 2022-11-06.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "a@b.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                TextField("Email Address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
            }
            .navigationTitle("Your Code")
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
