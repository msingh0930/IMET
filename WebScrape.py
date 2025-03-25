from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

d = webdriver.Safari()
url = "https://www.princegeorgescountymd.gov/departments-offices/environment/stormwater-management/clean-water-act"
d.get(url)

#need to make sure that the website is able to load, therefore making it wait about 15
#seconds to make sure it loads
waitingTime = WebDriverWait(d, 15)

try:
    try:
        #since there is somtimes a popup that needs to be closed when the link opens
        #we need to make sure that we get rid of the pop up
        buttontoclose = waitingTime.until(EC.element_to_be_clickable((By.ID, "overlay-close")))
        #this actually closes the pop up
        buttontoclose.click()
        print("Popup closed.")
    except:
        print("No popup found or already dismissed.")

    #this is finding the content on the page
    content_div = waitingTime.until(EC.presence_of_element_located((
        By.CLASS_NAME, "field-name--body"
    )))
    #prints the content that was scraped
    print("\n--- Page Content ---\n")
    print(content_div.text)


#exception in case there is an error scraping
except Exception as e:
    print("Error during scraping:", e)

finally:
    d.quit()
