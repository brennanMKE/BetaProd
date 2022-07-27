import SwiftUI

struct ContentView: View {
    let appEnvironment = AppEnvironment()

    var body: some View {
        Text(appEnvironment.environmentName)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
