import SwiftUI
import MapKit

struct MapView: View {
    @State private var currentUserLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.751999, longitude: 37.617734)
    @State private var destinationLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 56.184479, longitude: 36.984314)
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.95, longitude: 30.3), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @StateObject var viewModel: MapViewModel
    
    @State var route: MKRoute?
    @State var time: TimeInterval?
    @State var distance: CLLocationDistance?
    
    @State var showContextInfo: MapViewModel.Location?
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                ForEach(MapViewModel.locations, id: \.self) { item in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                        ZStack {
                            Circle()
                                .fill()
                                .foregroundColor(getColor(capacity: item.capacity).opacity(0.8))
                                .frame(width: 46, height: 46)
                            
                            Image("pin")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 2)) {
                                position = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    showContextInfo = item
                                }
                            }
                        }
                    }
                }
                
            
                if let chosenItem = showContextInfo {
                    Annotation(
                        "",
                        coordinate: CLLocationCoordinate2D(latitude: chosenItem.latitude, longitude: chosenItem.longitude),
                        anchor: .top
                    ) {
                        VStack {
                            Text("Какое то отделение")
                            Button {
                                showContextInfo = nil
                                destinationLocation = CLLocationCoordinate2D(latitude: chosenItem.latitude, longitude: chosenItem.longitude)
                                getRoute()
                            } label: {
                                Text("Построить маршрут")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue.opacity(0.3))
                        }
                        .frame(width: 200)
                        .padding(.vertical)
                        .background(.black, in: RoundedRectangle(cornerRadius: 20))
                    }
                }
                
                if let route = route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            
            VStack {
                HStack {
                    if let time = time, let distance = distance {
                        Text("\(time) - \(distance)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.black, in: RoundedRectangle(cornerRadius: 25.0))
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
//                        withAnimation(.easeOut(duration: 2)) {
//                            position = .region(MKCoordinateRegion(center: currentUserLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
//                        }
                        getRoute()
                    } label: {
                        Image(systemName: "location")
                            .foregroundColor(.gray)
                            .padding(16)
                            .background(.black, in: Circle())
                            
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.askForPermission()
        }
    }
    
    func getColor(capacity: Int) -> Color {
        if capacity < 25 {
            return .green
        } else if capacity < 50 {
            return .yellow
        } else if capacity < 75 {
            return .orange
        } else {
            return .red
        }
    }
    
    func getRoute() {
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentUserLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation))
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }
            DispatchQueue.main.async {
                withAnimation(.bouncy) {
                    self.route = response.routes[0]
                    self.time = self.route?.expectedTravelTime
                    self.distance = self.route?.distance
                    let mapRect: MKMapRect = route?.polyline.boundingMapRect ?? .null
                    var rect: CGRect = CGRect(x: mapRect.minX, y: mapRect.minY, width: mapRect.width, height: mapRect.height)
                    rect = CGRect(x: rect.minX - 50000, y: rect.minY - 50000, width: rect.width + 100000, height: rect.height + 100000)
                    let newMapRect = MKMapRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height)
                    position = .rect(newMapRect)
//                    position = .rect(route?.polyline.boundingMapRect ?? .null)
                }
            }
//                            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)

//                            let rect = route.polyline.boundingMapRect
//                            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
}

#Preview {
    MapView(viewModel: MapViewModel())
}
