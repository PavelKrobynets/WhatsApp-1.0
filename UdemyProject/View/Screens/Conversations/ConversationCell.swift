//
//  ConversationCell.swift
//  UdemyProject
//
//  Created by mac on 03.09.2021.
//

import SwiftUI
import Kingfisher

struct ConversationCell: View {
    @ObservedObject var viewModel: ConversationsCellViewModel
    var body: some View {
        if let user = viewModel.message.user{
            NavigationLink(destination: ChatView(user: user), label: {
                VStack {
                    HStack{
                        KFImage(viewModel.partnersProfilePhotoUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading){
                            Text(viewModel.fullname)
                                    .font(.system(size: 14, weight: .semibold))
                            
                            Text(viewModel.message.text)
                                .font(.system(size: 15, weight: .light))
                        }.foregroundColor(.primary)
                        Spacer()
                    }.padding(.horizontal)
                    Divider()
                }
            })
        }
    }
}

 
