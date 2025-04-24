PROJECT_DOCUMENT = """
XMC Loan is an operational workflow application utilized by the Global Loans Operations team to source all workflow items,
including client requests and daily processing items in support of BAU activities and special remediation projects.

The ticket as main entity in this application was created by email. Ticket carries business fields to offer Operation users filling out loan transaction information,
Then, ticket will go to workflow and pend for reviewing. After all Approval is done.the ticket lifecycle is ended, Ticket will be closed as archived data.

Ticket generation has two ways in XMC. THe first one is via Create New entrance to create it. 
The operations step is clicking New Message button and open New Message page, 
then, filing out mandatory fields including Processing Team, From, To, Subject, Request Type. Finally, 
after these mandatory fields are are done, click send. XMO will create his tick for this email. 

The second was XMC receiving incoming email(This incoming email is first time to receive in XMC), 
then, system will create new ticket for this incoming email.
Except new ticket from New Message creation, New tickets generation or updating existing tickets via incoming emai is depends on System Email Rule. 
Hence, before a new onboarding processing, team starts to run on XMC Loans, This processing team Admin user need to go System Email Rule page to check whether this processingteam system email rule is active or inactive 
if the status of it is active, that's expected. Admin user has no need to do anything. System could normally receive incoming email of this processing team to create new tickets or updating existing ticke

However, If the status is inactive, Admin user needs to click "Active Email Rule(s)' button to activate target rule then, System could normally receive incoming email of this processing team to create new tickets or updating existigtickets. 
If processing team user does not want to create new tickets update existing tickets via incoming email, 
this processing team Admin user could click "Inactive Email Rule(s), after that this processing team system email rule will notake efect and XMC Loans will not create or updatetickets anymore. 
Moreover, infuser want to export these rules. Admin user clicks 'Export' button could implement that.

Generally, for Normal DL inXMC, all business field is configured in Update Ticket action form on ticket, so these business fields will be displayed in h right area ofticket detail page, 
after user clicks'"Update ActionPack button on ticket. Meanwhile, these business field seasoned to be configured under 'Aditional Details' section in the left area ofticket detail page for presenting these
business field value that user saved or submitted, after business fields are done and action form is saved or submited. These busines field alue will be shown under "Aditional Details' section .the left area of ticket detail
"""
