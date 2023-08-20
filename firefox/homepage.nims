import karax/[karaxdsl, vdom]
from homepageData import links

type
  Link = tuple[url, label: string]
  Category = tuple[name: string, items: seq[Link]]

func homepage(categories: openArray[Category]): VNode =
  result = buildHtml(html(lang = "en")):
    head:
      meta(charset = "UTF-8")
      meta(name = "viewport", content = "width=device-width, initial-scale=1")
      title:
        text "New Tab"
      link(rel = "stylesheet", `type` = "text/css", href = "destyle.css")
      link(rel = "stylesheet", `type` = "text/css", href = "homepage.css")
    body:
      main:
        for (name, items) in categories:
          section:
            header:
              text name
            for (url, label) in items:
              tdiv(class = "item"):
                a(href = url):
                  text label

echo "<!DOCTYPE html>\n", homepage(links)
