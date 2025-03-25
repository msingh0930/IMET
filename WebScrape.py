#imports for using selenium
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

#opens the browsor to look up the url
d = webdriver.Safari()
#url that will be scraped
url = "https://www.princegeorgescountymd.gov/departments-offices/environment/stormwater-management/clean-water-act"
#this navigates to the given url
d.get(url)

#need to make sure that the website is able to load, therefore making it wait 15
#seconds to make sure it loads
waitingTime = WebDriverWait(d, 15)

#we use try here to catch any errors that we need to address
try:
    try:
        #since there is somtimes a popup that needs to be closed when the link opens
        #we need to make sure that we get rid of the pop up
        #waits 15 sec for the popup as well
        buttontoclose = waitingTime.until(EC.element_to_be_clickable((By.ID, "overlay-close")))
        #this actually closes the pop up
        buttontoclose.click()
        print("Popup closed.")
    except:
        print("No popup found or already dismissed.")

    #this is finding the content on the page and uses the
    #field-name-body as the class name to know what to 
    #scrape
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
    #this closes the browser so resources are not used
    d.quit()
