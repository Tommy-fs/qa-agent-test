PROJECT_DOCUMENT = """
Ticketing Logic
In order  to auto create ticket within APAC Loan email management application following 2 steps are required:
1.Loan Ops Processing queue/DL should be on-boarded  has an ACTIVE Rule created.
2.Loan Ops has added Prod DL (or UAT DL)as a sub-DL within Loan Ops Prod DL.
Once above 2 steps are completed, an incoming email on Loan Op Prod DL with auto-create a ticket and will be
shown under Processing Queue in the left rail within Open Tickets sub-folder

C1-Create new ticket ID:
New tickets logic DL + Subject + first email body
detect new ticket logic is :Receiver Email Address + subject (exclude "RE"/"FW") + first email body, example, you send email 1 to CA UAT, will create ticket 001;
if you reply or forward(don't change subject or email 1 body) won't create new ticket will update in one ticket;
if you change subject or email 1 body will create new ticket;
if you send email 1 with subject 1 to CA UAT will create ticket ,
if you send email 2 with same body and subject to CA UAT, will create new ticket, because you don't reply or FW email, you totally new one email
1. Send email 1 to Email Address1 with Subject 1, will create new ticket XL001 in Test APP
2. Reply or forward email 1 with change Subject to Subject 2, will create ticket XL002 in Test APP
3. After ticket closed in Test APP, reply and forward email will create new ticket in Test APP

C2-Follow previous ticket ID:
4.Reply email 1 with subject 1 will follow in same ticket XL001
5.Forward email and email to/email CC contain DL1 will be captured in same ticket XL001

C3-BCC Logic:
6.Ticket logic of BCC will in solution study progress, cover in future version
"""
