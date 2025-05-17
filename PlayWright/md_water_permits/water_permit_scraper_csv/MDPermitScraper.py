import asyncio
from playwright.async_api import async_playwright
import csv
import os
import re

def clean_text(text):
    # Aggressively strip extra whitespace, line breaks, and control characters
    text = re.sub(r'\s+', ' ', text)
    text = re.sub(r'[^\x20-\x7E]+', '', text)  # Remove non-printable characters
    return text.strip()

async def scrape_water_permits():
    base_url = "https://mde.maryland.gov/programs/permits/WaterManagementPermits/Pages/index.aspx"
    target_permits = [f"3.{str(i).zfill(2)}" for i in range(1, 30)] + ["4.01", "4.02"]
    output_file = "md_permits_output.csv"

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False, channel="chrome")
        context = await browser.new_context()
        page = await context.new_page()

        await page.goto(base_url, timeout=20000)
        print("Loaded main permit page...")

        links = await page.locator("a").all()
        data_rows = []

        for link in links:
            title = (await link.text_content() or "").strip()
            for permit in target_permits:
                if title.startswith(permit):
                    href = await link.get_attribute("href")
                    if href and not href.startswith("http"):
                        href = f"https://mde.maryland.gov{href}"

                    # Visit individual permit page
                    new_page = await context.new_page()
                    await new_page.goto(href, timeout=20000)
                    print(f"Scraping {permit} at {href}")

                    # Get main text content
                    try:
                        content = await new_page.locator("main, .field-name--body, body").text_content(timeout=10000)
                        content = clean_text(content) if content else "No content found."
                    except Exception as e:
                        content = f"Error scraping content: {str(e)}"

                    # Extract all PDF or downloadable links
                    file_links = []
                    file_elements = await new_page.locator("a").all()
                    for f in file_elements:
                        file_href = await f.get_attribute("href")
                        if file_href and (".pdf" in file_href.lower() or ".doc" in file_href.lower()):
                            if not file_href.startswith("http"):
                                file_href = f"https://mde.maryland.gov{file_href}"
                            file_links.append(file_href.strip())

                    data_rows.append({
                        "Permit Number": permit,
                        "Permit Title": title,
                        "Permit URL": href,
                        "Cleaned Content": content,
                        "PDF/Download Links": ", ".join(file_links)
                    })

                    await new_page.close()

        await browser.close()

        # Save to CSV
        keys = ["Permit Number", "Permit Title", "Permit URL", "Cleaned Content", "PDF/Download Links"]
        with open(output_file, "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=keys)
            writer.writeheader()
            writer.writerows(data_rows)

        print(f"\n All permits scraped and saved to: {output_file}")

asyncio.run(scrape_water_permits())
