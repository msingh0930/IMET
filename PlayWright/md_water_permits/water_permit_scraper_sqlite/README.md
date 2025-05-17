# MDPermitScraperSQLite
The following permit scraper writes scrapes water permit data from the Maryland Department of the Environment water
permits page.
- It is a modified version of the other MDPermitScraper, but writes data to a local SQLite database instead of writing
to a CSV file.
- This version fixes an issue present in the other version of MDPermitScraper; it uses PlayWright's locator API with
strict mode, but it finds more than one main element on certain pages leading to issues.
- It scrapes permit information from https://mde.maryland.gov/programs/permits/WaterManagementPermits/Pages/index.aspx

This is useful for testing, but can potentially be partially re-used for future web scrapers that need to write to
a database. Theoretically aiosqlite could be replaced with another library such as aiosql which has drivers for
PostgreSQL.

Tools to view the SQLite files the scraper outputs are available:
- Web browser based viewers
  - https://inloop.github.io/sqlite-viewer/
  - https://sqliteviewer.app/
- Desktop applications
  - https://sqlitebrowser.org/