" Vim plugin for send MDX queries to the OLAP server
"
" Config:
"   let mdx_config = '/home/byzov_pa/.vim/mdx.config'
"
" Maintainer: Pavel Byzov <pavel@byzov.com>
" TODO:
"   - Pipe result in new buffer

if exists("g:loaded_mdxquery")
    finish
endif
let g:loaded_mdxquery = 1

" Send MDX query to server and get result
:com! -range -nargs=0 MojivaMDX 
            \ call MDXSend(<line1>,<line2>,"mojiva")
:com! -range -nargs=0 MoceanMDX 
            \ call MDXSend(<line1>,<line2>,"mocean")

function! MDXSend(fl,ll,s)
python << EOF
import vim
import urllib
import urllib2
import time
import ConfigParser
import os

# Get function args
start = int(vim.eval('a:fl'))-1
end = int(vim.eval('a:ll'))
scheme = vim.eval('a:s')

# Get selected lines
lines = vim.current.buffer[start:end]
mdx = ' '.join(lines)

# Print MDX query
print '>>>', ' '.join(mdx.split())
print ">>>\n"

# Set params
params = {'f':'txt', 
          's':scheme, 
          'q':mdx}
data = urllib.urlencode(params) 

# Get config
config = ConfigParser.ConfigParser()
config.readfp(open(vim.eval('g:mdx_config')))
url = config.get("server", "url")
username = config.get("server", "username")
password = config.get("server", "password")

# Creates a password manager
passman = urllib2.HTTPPasswordMgrWithDefaultRealm()
passman.add_password(None, url, username, password)

# Create the AuthHandler
authhandler = urllib2.HTTPBasicAuthHandler(passman)

# Set up authentication handler
opener = urllib2.build_opener(authhandler)
urllib2.install_opener(opener)
request = urllib2.Request(url, data)

# Send request by POST method and calculate time
stime = time.time()
pagehandle = urllib2.urlopen(request)
query_time = time.time() - stime

# TODO Remove carriage return from the lines
print pagehandle.read(), \
      "%.1f sec" % query_time
EOF
endfunction

