require! <[glad-component-compiler]>

<- glad-component-compiler.compile do
  src: "#__dirname/../components"
  dest: "#__dirname/../"
  flatten: on

console.log \Built
