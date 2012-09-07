# source : cfg_user.jl (./extras/tm4julia/config/)
# purpose: user specific internal configuration settings
#
# author : Jeffrey A. Sarnoff
# created: 2012-Sep-04 in New York, USA


# facility files with user specific data
#
#    Use of these files is optional.


# To expand the list of timezones to be preloaded
#   beyond those listed in "InitialTimezones.txt",
#   add IANA standard timezone names, one per line,
#   to the "UserTzones.txt" file.
#
const
filenameUserTzones  = jtm_tzifile("UserTzones")  # one name per line

# Only use "RemoteTzone.txt" if your local timezone
#   differs from that of the computing system you use.
#
const
filenameRemoteTzone = jtm_tzifile("RemoteTzone") # one name


# eof #
