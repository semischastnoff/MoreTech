import SwiftUI
import MapKit

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            MapFactory.make()
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
