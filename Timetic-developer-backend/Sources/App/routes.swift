import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    func indexPage(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("index.html")
    }
    
    try app.register(collection: AdministrationController())
    try app.register(collection: MobileController())
    app.get("", use: indexPage)
    app.get("pages","**", use: indexPage)
    app.get("auth","**", use: indexPage)
    app.get("pages", use: indexPage)
    app.get("auth", use: indexPage)
}
