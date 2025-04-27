//
//  ErrorView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 18.6.22..
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Greska!")
                    .font(.system(size: 38, weight: .black))
                    .padding(.bottom)
                
                Text(errorWrapper.guidance)
                    .font(.headline)
                
                /*Text(errorWrapper.error.localizedDescription)
                    .font(.caption)
                    .padding(.top)*/
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 0) {
                        Image("Icon_RC_500x500")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 6)
                        
                        Text("EduChat: Error")
                            .font(.system(size: 11, weight: .black))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zatvori") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: LogInView.logErrors.noNameEntered,
                     guidance: LogInView.logErrors.noNameEntered.message)
    }
    
    static var previews: some View {
        ErrorView(errorWrapper: wrapper)
    }
}
