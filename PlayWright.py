import asyncio
from playwright.async_api import async_playwright

async def scrape_with_playwright():
    url = input("Enter link here: ")

    async with async_playwright() as p:
        # Launches Chrome in a visible window (non-visible can be changed if set to True)
        browser = await p.chromium.launch(headless=False, channel="chrome")
        page = await browser.new_page()
        
        try:
            # Goes to the target URL inputted by the user
            await page.goto(url, timeout=15000)

            # Tries to close the popup if it exists
            try:
                # Wait for the popup close button by ID
                await page.locator("#overlay-close").click(timeout=5000)
                print("Popup closed.")
            except:
                print("No popup found or already dismissed.")

            # Wait for and extract content from the target class
            content = await page.locator(".field-name--body").text_content(timeout=10000)
            print("Scraped content:\n", content.strip() if content else "No content found.")

        except Exception as e:
            print("Error during scraping:", e)

        finally:
            await browser.close()

# Run the async function
asyncio.run(scrape_with_playwright())