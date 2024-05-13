import SwiftUI

@available(iOS 15.0, *)
struct MediaCarouselView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ProductMediaViewModel
    @State private var fullscreenScale: CGFloat = 1
    
    let isZoomable: Bool
    
    init(viewModel: ProductMediaViewModel, isZoomable: Bool) {
        self.viewModel = viewModel
        self.isZoomable = isZoomable
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        if isZoomable {
                            ZoomableScrollView(scale: $fullscreenScale) {
                                CacheAsyncImage(url: URL(string: viewModel.images[index])) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding()
                            }
                            .background(theme.backgroundColor)

                        } else {
                            CacheAsyncImage(url: URL(string: viewModel.images[index])) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width)
                                    .frame(minHeight: 200, maxHeight: 360)
                            } placeholder: {
                                ProgressView()
                            }
                            .onTapGesture {
                                viewModel.onImageTapped(at: index)
                            }
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
                                        CacheAsyncImage(url: URL(string: viewModel.images[index])) { image in
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
            .frame(minHeight: 200, maxHeight: isZoomable ? .infinity : 360)
            .clipped()
        }
    }

}

@available(iOS 15.0, *)
#Preview {
    let viewModel: ProductMediaViewModel = .init(images: [], analyticsClient: MockAnalyticsClient())
    return MediaCarouselView(viewModel: viewModel, isZoomable: false)
}
