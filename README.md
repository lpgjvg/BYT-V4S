# Volunteer For Salesforce - LWR Site (Experienced Cloud)

Introducing the New Redesigned Personal Site for Volunteers for Salesforce! 🌟

 I'm equally excited and thrilled to share my side project  - a brand-new Personal Site for Salesforce Volunteers, built on Lightning Web Components (LWC) and hosted as a Lightning Web Runtime (LWR) site!   🎉 🎉
 

🔗 Demo of the site:

https://lnkd.in/g5yZPgBZ



🔥 What's New:

✨ **Modern Design:** The revamped site looks sleek with modern design, offering a visually appealing interface to engage visitors effortlessly. <br>
✨ **Lightning Performance:** Say goodbye to loading delays! Thanks to LWR, the new site now loads fast, ensuring a smooth browsing experience for every user. <br>
✨ **Interactive Features:** I've added interactive components using LWC that allow volunteers to easily access their dashboards, sign up for events, and access shift calendars with just a few clicks. <br>
✨ **Mobile-Optimized:** The new site is fully responsive, ensuring a consistent and enjoyable experience whether you're on a desktop, tablet, or smartphone. <br>
✨ **Recurring Shift Management:** Now volunteers will have the ability to bulk sign up or cancel shifts. They will be able to pick and choose from the list of future shifts. <br>
✨ **Report hours:** Now volunteers will be able to report hours with ease and can pick even the shifts that were completed in the past 30 days (configurable). <br>
✨ **Shift Calendar:** Ability to sign up for any future or past shift (configurable) and the shift colours can be easily managed at the record level. <br><br>

## Deploy V4S Site in Developer or Sandbox Edition

### **Prerequisites:**

      * Enable DevHub in your developer/sandbox environment.
      * Install Salesforce CLI.
      * Install Visual Studio Code.
      * Install Salesforce Visual Studio Code Extensions.
      * Ensure NPSP and Volunteer for Salesforce in installed in the org.
      * Enable Digital Experience in your developer/sandbox environment.
      * Enable Experience Bundle (From Setup, Under Experience Management Settings, enable Enable ExperienceBundle Metadata API.)

  Refer to [Set up VS Code Trailhead Unit](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/set-up-visual-studio-code).
<br><br>

1. Authorize your hub org and provide it with an alias. (**myv4sorg** in the command line below)
   
```
sf org login web -d -a myv4sorg

```

2. Clone the repository by runnig the command in VScode terminal: (**"c:\Users\Documents\VSCode\"** change this path to your preferred location in your local machine)

```
git clone  c:\Users\Documents\VSCode\

```

3. Open the cloned repository in VSCode.

   ![image](https://github.com/lpgjvg/V4S/assets/126043548/bf91dc25-4bf9-45e9-ac0f-7db9c6966cae)

   ```
   Select the V4S folder inside the cloned desination path from previous step. (c:\Users\Documents\VSCode\)
   
   ```


5. Configure the Experience Cloud site metadata file with the following steps:
        
         Item 1:
      
          * Edit the force-app/main/default/sites/V4S.site-meta.xml file.
          * Replace the value between the <siteAdmin> tags with your Org's preferred username.
          * Replace the value between the <siteGuestRecordDefaultOwner> tags with your Org's preferred  username.
          * Save the file.
      
         Item  2:
   
          * Edit the force-app/main/default/networks/V4S.network-meta.xml file.
          * Replace the value between the <emailSenderAddress> tags with your Org's default email address.
          * Save the file.

       
    
  
6. Deploy code to the Org

   * Run the below code in the terminal to deploy the site. This step will take about 5 to 10 mins. (Replace *user@testorg.com* with your org's username)

      ```
         sfdx force:source:deploy -p force-app/main/default/ -u user@testorg.com
      
      ```
   * Run the below command to deploy guest user profile changes. (Replace *user@testorg.com* with your org's username)
  
     ```

      Step  1:
   
          * Edit the prof-app\main\default\cspTrustedSites\V4S_LWC.cspTrustedSite-meta.xml file.
          * Replace the value between the <endpointUrl> tags with your V4S Experience Cloud Site URL.
          * Save the file.
     
      Step 2:
     
          sfdx force:source:deploy -p prof-app/main/default/ -u user@testorg.com

     ```

7. Assign V4S permission set to Org browsers

   ```
   Assign "V4S Custom Permission" permission set to Org's users as required.

   Setup > PermissionSet > Manage Assignment
   
   ```

8. Update the trusted site information in the Experience Builder

   ```
   Navigate to Setup > All Sites > Builder (Open the builder for the v4s site) > Settings

   Change the Site value with your V4S Experience Cloud Site URL.

   ```

   <img width="497" alt="image" src="https://github.com/lpgjvg/V4S/assets/126043548/269de8b2-335a-4fcd-b1fa-38277dd6d6b7">


## Issues with deployment

I will keep logging common pre and post deployment issues and workarounds in this section.

1. Site keeps loading the Volunteer Lookup Page though proper contact id is supplied in the URL.

   ```
   The repository comes with Account sharing rule for the site guest user. If Contact object sharing setting is not controlled by parent Account
   then the guest user wont be able to access the contacts.

   The workaround here is to create a sharing rule specific to contact object.

   Please refer to a sample sharing rule below. Define the rule according to your organisation needs.

   ```
   ![image](https://github.com/lpgjvg/V4S/assets/126043548/be75811f-cfc5-4a40-8ad7-e529b6095e65)



## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
