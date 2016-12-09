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

I have created python scripts for the following functionality:
- `add_blog_post()` copies a new post into the git dir and creates and opens a meta-data file for it. Also copies any folder named /images/<post name> if it exists in the same dir as the post. 
- `update_blog()` copy/overwrites all post files to the git dir along with corresponding image folder. Then runs pelican on the /content folder of the git dir to produce the output HTML


## Ongoing Workflow Improvement List
- script to push the blog to github
