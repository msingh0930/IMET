import asyncio
import os.path
import re

import aiosqlite

from playwright.async_api import async_playwright

base_url = "https://mde.maryland.gov/programs/permits/WaterManagementPermits/Pages/index.aspx"
target_permits = [f"3.{str(i).zfill(2)}" for i in range(1, 30)] + ["4.01", "4.02"]

CREATE_PERMIT_TABLE_CMD = """
    CREATE TABLE IF NOT EXISTS permits (
    permitID INTEGER PRIMARY KEY AUTOINCREMENT,
    permitName VARCHAR(100),
    permitDocs TEXT,
    permitLink VARCHAR(100)
    )"""

CREATE_LINKS_TABLE_CMD = """
    CREATE TABLE IF NOT EXISTS permit_links (
    linkID INTEGER PRIMARY KEY AUTOINCREMENT,
    downloadLink VARCHAR(100),
    permitID INTEGER,
    FOREIGN KEY (permitID) REFERENCES permits(permitID)
    )"""

# Sqlite doesn't have an explicit truncate command, so we need to do it manually
DELETE_PERMIT_TABLE_CMD = "DELETE FROM permits"
RESET_AUTOINCREMENT_PERMIT_TABLE_CMD = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='permits'"

DELETE_LINKS_TABLE_CMD = "DELETE FROM permit_links"
RESET_AUTOINCREMENT_PERMIT_LINKS_TABLE_CMD = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='permit_links'"

db_connection = None
db_cursor = None

async def start_db_connection():
    global db_connection
    global db_cursor
    db_connection = await aiosqlite.connect(os.path.join("./regulations.db"), timeout = 20)
    db_cursor = await db_connection.cursor()

async def close_db_connection():
    await db_cursor.close()
    await db_connection.close()

# Used to initialize and create the database tables
async def init_db():
    if db_connection is not None and db_cursor is not None:
        print("Initializing database tables...")

        try:
            await db_cursor.execute(CREATE_PERMIT_TABLE_CMD)
            await db_cursor.execute(CREATE_LINKS_TABLE_CMD)
            await db_connection.commit()
        except Exception as e:
            print(f"Failed to initialize database tables! {str(e)}")

        print("Database tables initialized successfully.")
    else:
        print("Could not initialize tables! No connection to database.")

# SQLite doesn't have a TRUNCATE command which means we need to delete and reset autoincrement manually
async def truncate_db():
    if db_connection is not None and db_cursor is not None:
        print("Truncating database tables...")

        try:
            await db_cursor.execute(DELETE_PERMIT_TABLE_CMD)
            await db_cursor.execute(RESET_AUTOINCREMENT_PERMIT_TABLE_CMD)
            await db_cursor.execute(DELETE_LINKS_TABLE_CMD)
            await db_cursor.execute(RESET_AUTOINCREMENT_PERMIT_LINKS_TABLE_CMD)
            await db_connection.commit()
        except Exception as e:
            print(f"Failed to truncate database tables! {str(e)}")
    else:
        print("Could not truncate tables! No connection to database.")

def clean_text(text):
    # Aggressively strip extra whitespace, line breaks, and control characters
    text = re.sub(r'\s+', ' ', text)
    text = re.sub(r'[^\x20-\x7E]+', '', text)  # Remove non-printable characters
    return text.strip()

async def scrape_water_permits():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False, channel="chrome")
        context = await browser.new_context()
        page = await context.new_page()

        await page.goto(base_url, timeout=20000)
        print("Loaded main permit page...")

        links = await page.locator("a").all()

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
                        content = "No content found."
                        if await new_page.query_selector("main") is not None:
                            page_content = await new_page.locator("main").text_content(timeout=10000)
                            content = clean_text(page_content) if page_content else "Error occurred getting page text content."
                    except Exception as e:
                        content = f"Error scraping content: {str(e)}"

                    # Insert the permit into the permits table
                    await db_cursor.execute("INSERT INTO permits VALUES(NULL, ?, ?, ?)",
                                                               (title, content, href))
                    # Get the foreign key row ID we need to reference the permit for the links table
                    permit_id = db_cursor.lastrowid

                    # Extract all PDF or downloadable links
                    file_elements = await new_page.locator("a").all()
                    for file in file_elements:
                        file_href = await file.get_attribute("href")
                        if file_href and (".pdf" in file_href.lower() or ".doc" in file_href.lower()):
                            if not file_href.startswith("http"):
                                file_href = f"https://mde.maryland.gov{file_href}"
                            # Insert each link we find into the links table
                            await db_cursor.execute("INSERT INTO permit_links VALUES(NULL, ?, ?)",
                                                           (str(file_href.strip()), permit_id))

                    # Commit changes from our transaction since we finished scraping the permit
                    await db_connection.commit()
                    await new_page.close()

        await browser.close()

        print("\nPermits scraped and written to DB")

async def main():
    try:
        await start_db_connection()
        await init_db()
        await truncate_db()
        await scrape_water_permits()
    finally:
        # Once we have finished scraping, close the connection to the DB. If we don't the program will hang.
        await close_db_connection()

asyncio.run(main())