import karax/[karaxdsl, vdom]
from ../../sns/homepageData import links

func homepage: VNode =
  result = buildHtml(html(lang = "en")):
    head:
      meta(charset = "UTF-8")
      meta(name = "viewport", content = "width=device-width, initial-scale=1")
      title:
        text "New Tab"
      link(rel = "stylesheet", `type` = "text/css", href = "homepage.css")
    body:
      tdiv(class = "categories"):
        for (category, items) in links:
          tdiv(class = "category"):
            p(class = "header"):
              text category
            for (l, t) in items:
              tdiv(class = "item"):
                a(href = l):
                  text t

echo "<!DOCTYPE html>", homepage()
