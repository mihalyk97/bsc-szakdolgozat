@testable import App
import XCTVapor
import Foundation

final class ClientRepositoryTests: XCTestCase {
    let email = "simonadél@gmail.com"
    
    func testCreateNewClient() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let client = CommonClient(_id: nil,
                                  name: "Kis Ilona",
                                  phone: "+3611231234",
                                  email: "kisilona@szolgaltato.com",
                                  personalInfos: [
                                    "Adószám":"121212",
                                    "Taj szám":"123000987"
                                  ])
        let createdClient = try ClientRepository.createOrModifyClient(clientData: client, db: app.db).wait()
        XCTAssertNotNil(createdClient.id)
    }
    
    func testCreateNewClientWithFewerPersonalInfoThanNeeded() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
        
        let client = CommonClient(_id: nil,
                                  name: "Kis Ilona",
                                  phone: "+3611231234",
                                  email: "kisilona@szolgaltato.com",
                                  personalInfos: [
                                    "Adószám":"121212"
                                  ])
        XCTAssertThrowsError(try ClientRepository.createOrModifyClient(clientData: client, db: app.db).wait())
    }
    
    func testCreateNewClientWithAlreadyExistingEmail() throws {
        let app = try TestConfiguration.getApplication()
        defer { app.shutdown() }
                
        XCTAssertNoThrow(try ClientRepository.getClientByEmail(email, db: app.db).wait())
        
        let client = CommonClient(_id: nil,
                                  name: "Kis Ilona",
                                  phone: "+3611231234",
                                  email: email,
                                  personalInfos: [
                                    "Adószám":"121212",
                                    "Taj szám":"123000987"
                                  ])
        XCTAssertThrowsError(try ClientRepository.createOrModifyClient(clientData: client, db: app.db).wait())
    }
}
