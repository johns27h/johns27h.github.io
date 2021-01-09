local({
  # fall back on '/' if baseurl is not specified
  baseurl = blogdown:::get_config2('baseurl', '/')
  knitr::opts_knit$set(base.url = baseurl)
  # fall back on 'kramdown' if markdown engine is not specified
  markdown = blogdown:::get_config2('markdown', 'kramdown')
  # see if we need to use the Jekyll renderer in knitr
  if (markdown == 'kramdown') knitr::render_jekyll() else knitr::render_markdown()
  
  # input/output filenames are passed as two additional arguments to Rscript
  a = commandArgs(TRUE)
  # d = gsub('^_|[.][a-zA-Z]+$', '', a[1])
  d = gsub('^([._/]+)|[.][a-zA-Z]+$', '', a[1])
  knitr::opts_chunk$set(
    # fig.path   = sprintf('assets/figures/%s/', d),
    fig.path = sprintf('%s/', gsub('^.+/', '', d)),
    cache.path = sprintf('cache/%s/', d)
  )
  if (getOption('blogdown.base.dir', '') != '') {
    knitr::opts_knit$set(base.dir = getOption('blogdown.base.dir', ''))
  }
  if (getOption('blogdown.base.url', '') != '') {
    knitr::opts_knit$set(base.url = getOption('blogdown.base.url', ''))
  }
  options(digits = 4)
  knitr::opts_knit$set(width = 70)
  knitr::knit(a[1], a[2], quiet = TRUE, encoding = 'UTF-8', envir = .GlobalEnv)
})
