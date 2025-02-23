PROJECT_DOCUMENT = """
XMC Loan is an operational workflow application utilized by the Global Loans Operations team to source all workflow items,
including client requests and daily processing items in support of BAU activities and special remediation projects.

The ticket as main entity in this application was created by email. Ticket carries business fields to offer Operation users filling out loan transaction information,
Then, ticket will go to workflow and pend for reviewing. After all Approval is done.the ticket lifecycle is ended, Ticket will be closed as archived data.

Ticket generation has two ways in SYSTEM, THe first one is via Create New entrance to creating it,
The operations step is clicking New Message button and open New Message page,
then, filling out mandatory fields including Processing Team, From email address, To email address, Subject, Request Type. 
Finally, after these mandatory fields are are done, click send. XMC will create this ticket for this email.
If you click send without filling in the required fields, the system will prompt which fields are not filled in automatically.

The second way is XMC receiving incoming email(This incoming email is first time to receive in XMC),
then.system will create new ticket for this incoming email.

Generally, for Normal DL in XMC, all business field is configured in Update Ticket action form on ticket,
so these business fields wil be displayed in the right area of ticket detail page,
after user clicks "Update Ticket' action button on ticket.Meanwhile,
these business field also need to be configured under 'Additional Details' section in the left area of ticket detail page for presenting these business field value that user saved or submitted.
after business field are done and action form saved or submitted. 
These business field value will be shown under "Additional Details section in the left area of ticket detail page.
"""