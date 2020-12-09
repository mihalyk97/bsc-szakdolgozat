import Fluent
import Vapor
import Smtp

func routes(_ app: Application) throws {

    try app.register(collection: EmployeeController())
    try app.register(collection: ClientController())
    try app.register(collection: AdminController())
        
    func indexPage(req: Request) throws -> EventLoopFuture<View> {
        return req.view.render("index.html")
    }
    
    app.get("", use: indexPage)
    app.get("pages","**", use: indexPage)
    app.get("auth","**", use: indexPage)
    app.get("pages", use: indexPage)
    app.get("auth", use: indexPage)
}
