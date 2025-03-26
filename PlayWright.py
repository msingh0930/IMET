#imports asyncio and playwright for scraping
import asyncio
from playwright.async_api import async_playwright

async def scrape_with_playwright():
    #gets user input for different websites
    url = input("Enter link here: ")

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

        #exception handler in case any errors occur
        except Exception as e:
            print("Error during scraping:", e)

        #closes the browser that was opened earlier
        finally:
            await browser.close()

# Run the async function
asyncio.run(scrape_with_playwright())