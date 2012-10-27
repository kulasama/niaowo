member = Member.find 1
code = Invitation.generate_no_limit member
p code.invite_code
