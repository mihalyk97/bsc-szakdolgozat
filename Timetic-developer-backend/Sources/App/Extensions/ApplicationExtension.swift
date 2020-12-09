import Foundation
import Vapor
import Leaf

//https://losingfight.com/blog/2018/12/30/sending-email-from-swift-vapor/
extension Application {
    func render<E>(fileName: String, extension: String, context: E) throws -> EventLoopFuture<String> where E: Encodable {
        
        return self.view.render(fileName, context).flatMapThrowing { view in
            guard let str = String(data: Data(buffer: view.data), encoding: .utf8) else {
                throw Abort(.internalServerError)
            }
            return str
        }
    }
}
