# abap-i18n-checker
Tool to check UI5 repositories in an ABAP system for missing/incomplete i18n translations

## Check procedure
Normally each UI5 app has at least 2 `i18n` files at a given path. The default file that is called `i18n.properties` and the language file of your default language, let' say _english_ `i18n_en.properties`. If the app is translated into several other languages you will get an additional file for each language.  
Via the tools in this repository you can compare the status of a certain language file to your base `i18n` file to see if a key is missing in the target language or if the value for a key is equal to the one in the base file - which in most cases means that it is not translated.

## Package overview
- **/src**  
  Main API for determining the translation status of i18n in UI5 repositories
  Important Objects in package  
  Object Name               | Purpose
  --------------------------|------------------------------------
  ZCL_I18NCHK_CHECKER       | Class which performs the actual translation checks
- **/src/srv**  
  Handler classes for REST endpoints which are needed for the UI
- **/src/ui**  
  UI5 app for retrieving and displaying the translation status of UI5 repositories. The source code of the app can be found at [i18n-checker](https://github.com/stockbal/i18n-checker). The app can be run in standalone mode (url: `<server-url>/sap/bc/ui5_ui5/sap/z18nchkapp/index.html`) or via integrating it into Fiori Launchpad

## System Requirements
The minimum NW version is not yet determined, probable v750

## Installation
Install with [abapGit](https://github.com/abapGit/abapGit)

### App index for UI5 app
If you want to integrate the app into Fiori Launchpad you first have to update the UI5 App Index for the repository. You can do this via the ABAP program `/UI5/APP_INDEX_CALCULATE` 
![image](https://user-images.githubusercontent.com/35834861/119222988-532bcd00-baf7-11eb-8d6a-e698f3fbe068.png)


### Troubleshooting
As there is currently [no prioritization](https://github.com/abapGit/abapGit/issues/4783) during MIME object deserialization you will probably end up with the following picture after the pull is done
![image](https://user-images.githubusercontent.com/35834861/119222515-13fc7c80-baf5-11eb-8897-5ec211b182a7.png)
Just do not try to delete the locally added mime folder via **Reset Local (Force Pull)**
