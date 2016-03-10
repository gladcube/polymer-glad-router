require! <[express compression glad-component-compiler]>

app = express!
  ..listen 80
  ..set \views, "#__dirname/../demo"
  ..set "view engine", \jade
  ..use compression!
  ..use express.static \public
  ..use \/components/:dir/:name, glad-component-compiler.express src: "#__dirname/../components"
  ..get \/, (req, res)-> res.render \index
  ..get \/demos, (req, res)->
    res.json [
      * name: \hoge
      * name: \fuga
    ]

console.log "Get ready."

