fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'G.A.S.T. Development'

version "1.0.0"

description  'The script tracks players on duty by their job and updates data on player connect, job change, or disconnect.'

server_script 'server.lua'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}