import Foundation

struct AbortReason {
    struct ParameterError {
        static let general = "Hibás vagy nem létező paraméter"
        static let date = "Hibás vagy nem létező dátum paraméter(ek)"
        static let missing = "Hibás paraméter: nincs minden adat megadva"
        static let newAppointment = "Hibás paraméter: nincs minden adat megadva vagy már létezik az időpont"
        static let missingClientPersonalInfos = "Nincs minden szükséges ügyféladat megadva"
        static let id = "A megadott azonosító nem megfelelő"
    }
    struct NotFound {
        static let appointment = "Időpont nem található"
        static let activity = "Tevékenység nem található"
        static let client = "Ügyfél nem található"
        static let employee = "Alkalmazott nem található"
        static let defaultContact = "Alapértelmezett kapcsolattartó nem található"
        static let consultation = "Konzultáció nem található"
        static let organization = "Szervezet nem található"
        static let passwordReset = "Jelszó-visszaállítás nem található"

    }
    struct InconsistentData {
        struct Appointment {
            static let associatedEmployee = "A létrehozó és az időpontban lévő alkalmazott nem egyezik"
            static let timeOrder = "Kezdési időpont nem lehet a befejező időpont után"
            static let modifiable = "Csak jövőbeni időpontok módosíthatók"
            static let earliestTimeForNew = "A legkorábbi időpont holnapra szólhat"
            static let earliestTimeForExisting = "A választott kezdési időpont már elmúlt"
            static let activityAssociatedEmployee = "A megadott tevékenység nincs az időpontot létrehozó alkalmazotthoz rendelve"
        }
        struct Employee {
            static let clientCreationRight = "Az alkalmazott nem rendelkezik ügyfél-regisztrációs joggal"
        }
        struct Consultation {
            static let nonExistingAppointment = "Csak létező időponthoz tartozhat konzultáció"
            static let nonOnlineAppointment = "Csak online időponthoz kérhető konzultáció"
            static let noClient = "Ügyfél nem található a konzultációhoz"
        }
        struct Email {
            static let nonExistingAppointment = "Nem létező időpontról nem küldhető email értesítés"
            static let exists = "A megadott email cím már használatban van"
        }
        struct PasswordReset {
            static let wrongCode = "Nem megfelelő ellenőrző kód"
            static let passwordLength = "A jelszó minimum 6 és maximum 12 karakterből állhat"
        }
        struct Configuration {
            static let error = "Konfigurációs hiba"
        }
    }
}

struct FatalErrorReason {
    static let moreThanOneOrganization = "Több, mint egy szervezet található az adatbázisban!"
    static let inconsistentConfiguration = "A konfiguráció hibás vagy nem létezik!"
    static let jwtKeyMissing = "A JWT kulcs nem található, ellenőrizze a környezeti változókat!"
    static let databaseConfigMissing = "Az adatbázis konfigurációja hibás, ellenőrizze a környezeti változókat!"
    static let smtpConfigMissing = "Az SMTP szerver konfigurációja hibás, ellenőrizze a környezeti változókat!"
}

struct Log {
    struct AppConfig {
        static let test = "TEST - "
        static let starting = "Timetic organization backend - betöltés"
        static let leaf = "Leaf betöltve"
        static let jwt = "JWT konfigurációja kész"
        static let database = "Adatbázis konfigurációja kész"
        static let tls = "TLS konfigurációja kész"
        static let smtp = "SMTP konfigurációja kész"
        static let migration = "Migrációk kész"
        static let loadConfig = "Konfiguráció betöltése"
        static let config = "Konfiguráció helyes"
        static let routes = "Végpontok betöltve"
        static let started = "Timetic organization backend - betöltés kész"
    }
}

struct EmailConstant {
    struct Subject {
        static let passwordReset = "Jelszó-változtatási kérés"
        static let appointmentCreated = "Új időpont"
        static let appointmentModified = "Időpontváltozás"
        static let appointmentCancelled = "Időpont lemondva"
    }
}

enum AppointmentEmailCause: String, Codable {
    case created = "Új időpont"
    case modified = "Időpontváltozás"
    case cancelled = "Időpont lemondásra került"
}

struct ApplicationInfo {
    static let appname = "Timetic"
    static let configFile = "config.json"
    static let resourcesFolder = "Resources"
}
