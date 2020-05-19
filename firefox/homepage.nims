import karax/[karaxdsl, vdom]
import homepageData

func homepage: VNode =
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
        for (category, items) in links:
          section:
            header:
              text category
            for (l, t) in items:
              tdiv(class = "item"):
                a(href = l):
                  text t

echo "<!DOCTYPE html>\n", homepage()
