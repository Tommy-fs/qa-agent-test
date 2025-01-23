PROJECT_DOCUMENT = """
The system is an operational workflow application utilized by the Global Loans Operations team to source all workflow items,
including client requests and daily processing items in support of BAU activities and special remediation projects.
The ticket as main entity in this application was created by email. Ticket carries business fields to offer Operation users filling
out loan transaction information. Then, ticket will go to workflow and pend for reviewing. After all Approval is done, the ticket
lifecycle is ended. Ticket will be closed as archived data.
Generally, for Normal DL in XMC, all business field is configured in Update Ticket action form on ticket, so these business
fields will be displayed in the right area of ticket detail page, after user clicks 'Update Ticket' action button on ticket.
Meanwhile, these business field also need to be configured under 'Additional Details' section in the left area of ticket detail
page for presenting these business field value that user saved or submitted, after business fields are done and action form is
saved or submitted. These business field value will be shown under 'Additional Details' section in the left area of ticket detail
page.
"""