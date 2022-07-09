# send-mail-demo
Example how to generate and send a mail using Steampunk ([SAP BTP ABAP Environment](https://community.sap.com/topics/btp-abap-environment))

# Implementation
A small (abstract) utility class `ZCL_MAIL_GEN` is used to generated mails based on a simple textual replacement of predefined placeholders. In order to send mails, the released API is call as explained in the official [documentation](https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/a3d3f38de12b430bb670e418e7e66bad.html?locale=en-US).
The generation of html mails follows the layout recommendation to use html tables and inline css to support a broader variety of different mail clients.

A concrete mail template class `ZCL_MAIL_GEN_MATERIAL` inherits from `ZCL_MAIL_GEN` and supports the generation of mails based on two textual placeholders (recipient and material).

ADT class runner class `ZCL_MAIL_GEN_TEST` is used to generate an example mail based on `ZCL_MAIL_GEN_MATERIAL`. The mail content is a formatted version of 

**Material Notification**

Dear Mr. Mayer,

Material **Screw 3x4** has been created.

Best regards

# How to setup SMPT mail connectivity based on an existing SMPT server
Prerequisites:
-	SMPT server
-	Configured Cloud Connector (SCC) for that SMPT server
-	SCC is assigned to the respective BTP subaccount

## Setup the Communication Arrangement

Create a new Communication Arrangement based on scenario `SAP_COM_0548`. Within the Communication Arrangement create a new Communication System:

and maintain the user for Outbound Communication (for SMPT access).
Resulting Communication Arrangement looks as follows:

Please do not create a Destination in BTP Cockpit for mail (deprecated approach in Steampunk – approach via Communication Arrangement is much easier).
