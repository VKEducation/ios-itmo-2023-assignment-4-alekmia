import Foundation


let ff = ThreadSafeArray<Int>()

for i in 0..<10 {
    DispatchQueue.global(qos: .userInteractive).async {
        ff.append(newElement: i)
        print(ff.toString())
    }
}

RunLoop.current.run()

//for i in 0..<10 {
//    DispatchQueue.global(qos: .userInteractive).async {
//        ff[i] = 100 + i
//        print(ff.toString())
//    }
//}
//
//RunLoop.current.run()
