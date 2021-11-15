# Arbeitsteilung Rails-Projekt: Bibliotheksverwaltung

## Marvin *(Frontend)*
- Views
    - Formulare als Tabellen
    - Auslagerung in Component-Partials
- CSS
    - unter Verwendung des CSS-Frameworks "Bootflat"
    - insb. Navigation, Panels & Form-Validations
- Single-Click für Ausleihe
    - POST-Anfragen über die selbe Session (CSRF) via XHR an das Backend senden
- Einbinden weiterer JS-Frameworks
    - DataTables
    - Bootstrap-Select (für bessere Multi-Select Inputs)
- Erweiterung der Seed-Datei


## Daniel *(Backend)*
- DB-Schema
    - Grundstruktur Seed-Datei (mittels "Faker"-Gem)
- Models
    - Relationen
    - Validations
- CRUD-Cycles
    - Controller
    - zusätzliche Routen für Single-Click Ausleihe
- Usermanagement
    - Authentifizierung mit devise
    - Sessionmanagement
    - Berechtigungen & bedingte Sichtbarkeiten
