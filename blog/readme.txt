# TO-DO
- Figure out how to get proper tab formatting for table of contents
- Change article subtitles to be more serious (remove?)
- Fix issues with theme for table formatting (see MAP post)


# INSTALL
Create a clean / simple environment for pelican to do its work in. In the Anaconda terminal:
	conda create --name blog_pelican python=3.5
	conda activate blog_pelican
	conda install pelican

Set up a simple directory structure for the blog. Still in the anaconda terminal and activated environment:
	mkdir new_blog_folder
	cd new_blog_folder
	pelican-quickstart
Quickstart will take you through several questions for setting up the blog and at the end it will create a few new python files and some folders inside new_blog_folder. The default location for the source files for your posts will be a folder called "content" while the default for the finalized HTML output files will be a folder called "output". The pelicanconf.py and publishconf.py are configuration files that you can edit to modify various things about pelican's operation and the post creation process, respectively.
	
Now we will install the plugin "pelican-ipynb" by danielfrg which will allow pelican to convert jupyter notebook and markdown files into HTML posts. You can install this is as a git submodule but I like the process of just downloading the repo from github (see the readme for the plugin for both approaches). In the root directory of the blog ("new_blog_folder") create a folder called plugins and inside that a subfolder called ipynb. Paste all the downloaded files from the github repo in this subfolder. Now we need to install the python dependencies for this plug. Still in our activated environment do:
	conda install markdown
	conda install jupyter
See the readme of the plugin for the specific list of requirements. Note that by installing jupyter we will also install ipython and nbconvert as dependencies.

In order to alert pelican to the new plugin, add the following at the end of the pelicanconf.py file that was created in the quickstart process:
	MARKUP = ('md', 'ipynb')
	PLUGIN_PATH = './plugins'
	PLUGINS = ['ipynb.markup']

For atom feed settings, add the following to your publishconf.py file:
	FEED_ALL_ATOM = 'feeds/all.atom.xml'
	CATEGORY_FEED_ATOM = 'feeds/{slug}.atom.xml'
We may now need to fix a backward-compatibility issue for RSS and atom feeds that occurs with many pelican themes when we use the newer "{slug}" syntax. When you build, you might encounter the error "CRITICAL: TypeError: not all arguments converted during string formatting". In the base.html file which is typically found in the templates folder of any pelican theme, we need to replace "|format(category.slug)" with "|format(slug=category.slug)" and likewise for lines with tag.slug. A replace-all for "|format(" to "|format(slug=" accomplishes this. Refer to this github issue:
https://github.com/getpelican/pelican/issues/2489


# MY OTHER IMPORTANT pelicanconf SETTINGS:
	AUTHOR = u'Sonya Sawtelle'
	SITENAME = u'Evening Session'
	SITESUBTITLE = u'exploring data science and python'
	SITEURL = 'sdsawtelle.github.io'
	PATH = 'content'
	TIMEZONE = 'America/New_York'
	DEFAULT_LANG = u'en'
	DEFAULT_PAGINATION = 100
	LOAD_CONTENT_CACHE = False
	THEME = "pelican-themes/clean-blog"

	
# MY OTHER IMPORTANT publishconf SETTINGS:
	SITEURL = 'sdsawtelle.github.io'
	RELATIVE_URLS = True
	DELETE_OUTPUT_DIRECTORY = True
	COLOR_SCHEME_CSS = "github"
	SHOW_SUMMARIES = False
	

# PROCESS FLOW
Make sure you have activated the environment and navigated to the blog's root directory
	conda activate blog_pelican
	
To build your output using the settings you specified in publishconf.py, from the blog root directory do
	pelican content -s publishconf.py

To preview the output, start the pelican local server with
	pelican --listen
and then navigate your browser to http://localhost:8000/. Note that simply opening the HTML file in your browser may no give you a faithful preview depending on how absolute vs. relative links are used in the publishing process.

Once satisfied, push the new changes to github by opening git bash, navigating to the root directory for the website (blog root lives inside this folder). Do:
	git add --all
	git commit -m "message"
	git push origin master


# CUSTOMIZING THEME
- In the index.html file located in the templates folder of the theme I have changed the code for displaying article summaries on the index to check for a new setting variable called SHOW_SUMMARIES in the publishconf.py. A summary is displayed below each article title only if the summary field exists in the metadata and SHOW_SUMMARIES = True.


# UPDATING THE TECH STACK
To update pelican just activate blog_pelican environment and run conda update pelican. To update the pelican-ipynb plugin just download the latest version of the repo and replace the old files in the ipynb plugin folder, then activate the environment and update any dependencies as need (refer to the readme).


# RANDOM ISSUES
- The pelican-ipynb plugin seems to have issues recognizing latex blocks when there is no empty line between the preceeding markdown text and the beginning of the latex environment. For instance we need formatting like:
	This is markdown text preceeding a latex environment.
	
	\begin{align*}
	a=b
	\end{align*}
- Now that I am using the toc plugin for jupyter notebooks all my posts have a table of contents at the top. Not sure if I want to keep them or not, but they can be ignored by the plugin converter by adding the following line to each .nbdata:
	Subcells: [1, None]

	
# RESOURCE
https://www.dataquest.io/blog/how-to-setup-a-data-science-blog/
http://blog.gabrielrezzonico.com/data-science-portfolio-using-pelican.html
