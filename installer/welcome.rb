WELCOME =<<EOF
##############################
##                          ##
## Ruby on Rails Datepicker ##
##                          ##
##############################
## Installer v.1.0          ##
##############################
##                          ##
## David Lee 2006           ##
##                          ##
## MIT License              ##
##                          ##
##############################


ABOUT THE PLUGIN:
-----------------

This is an installer for the Rails Datepicker, a calendar widget which makes
choosing dates pretty and fun. It's quite configurable -- see the javascript
source code for details.

ABOUT THE INSTALLER:
--------------------

The installer will recursively copy everything in:
  #{PluginInstaller::SOURCE_DIR} 
to your Ruby on Rails application directory in:
  #{PluginInstaller::RAILS_DIR}

- You will be able to review the actions to be taken before anything is done.
- No directories will be overwritten.  
- If any files already exist in the destination directory, you will be prompted
  before they are overwritten.  This should only happen if you are upgrading,
  anyway.

Let's begin.
EOF
