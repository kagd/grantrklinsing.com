set :application, 'client_site'
# set :state,       :production

## Servers we are going to deploy to ----------------------
server '159.203.78.230', user: 'deploy'

## Server Settings ----------------------------------------
set :deploy_to, "/var/www/client_site"

## Git Configuration Settings -----------------------------
set :branch, "master"
