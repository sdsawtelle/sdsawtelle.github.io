# sdsawtelle.github.io

This is the repo for my personal website where I collect posts I've written, projects I've done, and general info about myself.

The posts (blog) component is built using Pelican and the clean-blog template. The landing page, projects page and about page I built myself from scratch.

## Ongoing Redesign List
- change header layout to be more similar to [weasyprint](http://weasyprint.org/)
  - picture fades down to white and nav links live in a black horizontal band at the top
  - nav links left-justified and in capital letters: HOME, POSTS, PROJECTS, ABOUT
  - nav links right-justified and in lower case: email, github, linkedin, resume
- make a link to the research page from "About", but don't feature it anywhere else
- update research page descriptions and pictures
- redesign skills page (no code project profiles, just github repo links?)
- resdesign about page (do something better with the "random links" stuff)

## Posts (Blog) Workflow
All posts with corresponding images and attached files are created and maintained in /Projects/web-data-science-blog whereas this git repo is housed at /Code_GitVC/Web/sdsawtelle.github.io. 

I have created python functions for the following functionality:
- `add_blog_post()` copies a new post into the git dir and creates and opens a meta-data file for it. Also copies any folder named /images/<post name> if it exists in the same dir as the post. 
- `update_blog()` copy/overwrites all post files to the git dir along with corresponding image folder. Then runs pelican on the /content folder of the git dir to produce the output HTML

General workflow: 
- create and edit the post as a jupyter notebook in /Projects/web-data-science-blog/post-name (or other location if necessary)
- open terminal and change directory to the location of the jupyter notebook (usually /Projects/web-data-science-blog/post-name), then run "ipython" to enter a python shell
- import my "snips" module (where the blog functions are defined)
- execute `snips.add_blog_post(ipynb_post_filename_without_extension)`
- edit the new .nbdata file appropriately (it should open automatically in notepad++ when `add_blog_post` is run).
- execute `snips.update_blog()`. NOTE: as of 7/19/19 pelican needs to be called from within the conda venv "blog_pelican" in order to work correctly. I think I have corrected snips.update_blog() so that this occurs, but if not then you will encounter "CRITICAL: TypeError: not all arguments converted during string formatting". Refer to the README within the blog root for more info.
- check the newly created blogpost HTML file for conversion errors (note the LaTex is sometimes slow to render or requires a refresh). Note the pelican server should start and the webpage should open automaticallywhen `update_blog` is called.
- open git bash and change directory to \Documents\Code_GitVC\Web\sdsawtelle.github.io
- execute a git add, commit and push to update the blog files on the github server

## Ongoing Workflow Improvement List
- script to push the blog to github
