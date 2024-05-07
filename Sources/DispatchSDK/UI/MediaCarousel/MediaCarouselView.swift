import SwiftUI

struct MediaCarouselView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ProductMediaViewModel
    
    init(viewModel: ProductMediaViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        AsyncImage(url: URL(string: viewModel.images[index])) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width)
                                .frame(minHeight: 200, maxHeight: 360)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        if viewModel.images.count > 1 {
                            VStack {
                                ForEach(viewModel.images.indices, id: \.self) { index in
                                    Button(action :{
                                        withAnimation {
                                            viewModel.currentIndex = index
                                        }
                                    }) {
                                        AsyncImage(url: URL(string: viewModel.images[index])) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Group {
                                                if index == viewModel.currentIndex {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(Color.black.opacity(0.4))
                                                } else {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(Color(hex: "#E8E8E8"))
                                                }
                                            }
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .frame(width: 60)
                    Spacer()
                }
                
                
                
                VStack {
                    Spacer()
                    if viewModel.images.count > 1 {
                        HStack(spacing: 8) {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    viewModel.onPreviousButtonTapped()
                                }
                            }) {
                                Image(systemName: "chevron.left")
                            }
                            .buttonStyle(CarouselArrowButtonStyle())
                            
                            Button(action: {
                                withAnimation {
                                    viewModel.onNextButtonTapped()
                                }
                            }) {
                                Image(systemName: "chevron.right")
                            }
                            .buttonStyle(CarouselArrowButtonStyle())
                        }
                    }
                }
                .padding(.trailing)
                .padding(.bottom)
            }
            .frame(width: geometry.size.width)
            .frame(minHeight: 200, maxHeight: 360)
            .clipped()
        }
    }

}

#Preview {
    let viewModel: ProductMediaViewModel = .init(images: [])
    return MediaCarouselView(viewModel: viewModel)
}
