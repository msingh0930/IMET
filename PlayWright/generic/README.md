# Generic Webscrapers
Both of the following web scrapers take a user provided URL and attempt to scrape information from the provided URL.
Both web scrapers are less automated and require manual user input unlike the scrapers in the `md_water_permits`
folder.

- `PGWebScrape&Export.py` is similar to `PlayWright.py` but it has a few key differences.
  - It asks the user for additional input such as the county and state a regulation applies to.
  - It writes scraped data to `md_permits_output.csv`, a file containing comma separated values.