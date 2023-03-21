*** Settings ***
Library  SeleniumLibrary
Suite Setup  Open Browser  http://localhost:5000  chrome
Suite Teardown  Close Browser
  
*** Test Cases ***
Scraping Test
    ${title}=  Get Title
    Log  Page Title: ${title}
    ${product_text}=  Get Text  xpath:/html/body/div[1]/div/div[3]/div/div[1]/a/div/div[1]/span
    Log  Product Text: ${product_text}

