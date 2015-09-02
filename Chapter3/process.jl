using WeavePynb

fnames = ["bisection"
          ]

for f in fnames
    println("Processing $f")
    (!isfile(f*".html") || (mtime(f*".md") >  mtime(f*".html")))   && markdownToHTML(f*".md")
    (!isfile(f*".ipynb") || (mtime(f*".md") >  mtime(f*".ipynb"))) && markdownToPynb(f*".md")
end
