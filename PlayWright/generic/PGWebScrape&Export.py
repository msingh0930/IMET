import asyncio
import csv
import re
from playwright.async_api import async_playwright

async def scrape_with_playwright():
    #gets user input for different websites
    url = input("Enter link here: ")
    state = input("Enter the state this regulation applies to: ")
    county = input("Enter the county this regulation applies to: ")

    async with async_playwright() as p:
        # Launches Chrome in a visible window (non-visible can be changed if set to True)
        browser = await p.chromium.launch(headless=False, channel="chrome")
        page = await browser.new_page()
        
        try:
            #Goes to the URL inputted by the user
            await page.goto(url, timeout=15000)

            # Tries to close the popup if it exists
            try:
                #since there is somtimes a popup that needs to be closed when the link opens
                #we need to make sure that we get rid of the pop up
                await page.locator("#overlay-close").click(timeout=5000)
                print("Popup closed.")
            except:
                print("No popup found or already dismissed.")

            #finds content on page wiht the class name field-name--body and scrapes
            #that content to be printed
            content = await page.locator(".field-name--body").text_content(timeout=10000)
            #prints the content that was scraped
            print("Scraped content:\n", content.strip() if content else "No content found.")

            #uses content only found in the main content of the page
            main_content = page.locator(".field-name--body")
            link_elements = await main_content.locator("a").all()

            #creates a list for all of the hyperlinks
            hyperlink_list = []

            for link in link_elements:
                #extracts the actual hyperlink
                href = await link.get_attribute("href")
                #extracts the text that the hyperlink is titled
                title = await link.text_content()
                #makes sure that the href is a hyperlink and not a link to a different part of the page
                if href and href.startswith("http"):
                    #adds the hyperlink and its title to the list
                    hyperlink_list.append(f"{title.strip()} ({href})")

            print("\nHyperlinks found in main content only:\n")
            for link in hyperlink_list:
                print(link)

            # Save data to CSV
            output_file = "scraped_regulations.csv"
            with open(output_file, mode="a", newline="", encoding="utf-8") as file:
                writer = csv.writer(file)

                #limits hyperlinks to max 10 and fills in empty strings if less than 10
                max_links = 10
                hyperlinks_padded = hyperlink_list[:max_links] + [""] * (max_links - len(hyperlink_list))

                #writes headers to the file
                writer.writerow(["State", "County", "URL", "Content"] + [f"Hyperlink {i+1}" for i in range(max_links)])
                #writes the row of data with each hyperlink in its own column
                writer.writerow([state, county, url, content.strip() if content else "No content found."] + hyperlinks_padded)

            print(f"\n Data saved to {output_file}")

        #exception handler in case any errors occur
        except Exception as e:
            print("Error during scraping:", e)

        #closes the browser that was opened earlier
        finally:
            await browser.close()

# Run the async function
asyncio.run(scrape_with_playwright())
