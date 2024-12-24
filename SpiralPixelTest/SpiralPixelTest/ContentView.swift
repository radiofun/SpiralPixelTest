import SwiftUI

struct ContentView: View {
    
    @State private var progress = 1.0;
    @State private var viewSize = CGSize(width:380,height:240)
    @State private var dragPoint = CGPoint(x:190,y:120)
    
    var body: some View {
        ZStack{
            Color.yellow
                .ignoresSafeArea()
            VStack {
                Image("sample")
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea()
            .frame(width:viewSize.width,height:viewSize.height)
            .layerEffect(ShaderLibrary.particle(.float2(380,380),.float2(dragPoint),.float(progress)), maxSampleOffset:CGSize(width:400,height:400))
            .onTapGesture { location in
                dragPoint = location

                withAnimation(.spring(.smooth(duration:1.0))){
                    progress = 1.0
                    dragPoint = CGPoint(x:200,y:200)
                }
                
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragPoint = value.location
                    }
                    .onEnded { value in
                        withAnimation(.spring(.smooth(duration:1.0))){
                            progress = 1.0
                        }
                    }
                )
            VStack{
                Spacer()
                HStack{
                    Text("Intensity: \(progress, specifier: "%.2f")")
                        .font(.system(size: 14, design: .monospaced))
                        .bold()
                        .foregroundStyle(.yellow)
                    Slider(value: $progress, in: 0...1)
                        .tint(.yellow)
                }
            }
            .padding()

        }
    }
}

#Preview {
    ContentView()
}
