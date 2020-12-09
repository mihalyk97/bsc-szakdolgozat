import Foundation

struct AbortReason {
    struct ParameterError {
        static let general = "Hibás vagy nem létező paraméter"
    }
    struct NotFound {
        static let user = "Felhasználó nem található"
        static let organization = "Szervezet nem található"
        static let passwordReset = "Jelszó-visszaállítás nem található"

    }
    struct InconsistentData {
        struct Organization {
            static let exists = "Már létezik szervezet a megadott URL-lel"
        }
        struct PasswordReset {
            static let wrongCode = "Nem megfelelő ellenőrző kód"
            static let passwordLength = "A jelszó minimum 6 és maximum 12 karakterből állhat"
        }
    }
}

struct FatalErrorReason {
    static let inconsistentConfiguration = "A konfiguráció hibás vagy nem létezik!"
    static let jwtKeyMissing = "A JWT kulcs nem található, ellenőrizze a környezeti változókat!"
    static let databaseConfigMissing = "Az adatbázis konfigurációja hibás, ellenőrizze a környezeti változókat!"
    static let smtpConfigMissing = "Az SMTP szerver konfigurációja hibás, ellenőrizze a környezeti változókat!"
}

struct Log {
    struct AppConfig {
        static let starting = "Timetic developer backend - betöltés"
        static let leaf = "Leaf betöltve"
        static let jwt = "JWT konfigurációja kész"
        static let database = "Adatbázis konfigurációja kész"
        static let tls = "TLS konfigurációja kész"
        static let smtp = "SMTP konfigurációja kész"
        static let migration = "Migrációk kész"
        static let loadConfig = "Konfiguráció betöltése"
        static let config = "Konfiguráció helyes"
        static let routes = "Végpontok betöltve"
        static let started = "Timetic developer backend - betöltés kész"
    }
}

struct EmailConstant {
    struct Subject {
        static let passwordReset = "Jelszó-változtatási kérés"
    }
}

struct ApplicationInfo {
    static let appname = "Timetic"
    static let configFile = "config.json"
    static let resourcesFolder = "Resources"
}
