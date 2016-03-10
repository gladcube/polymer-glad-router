require("LiveScript")
import$(global, require("prelude-ls"))
require("./src/build.ls")

function import$(obj, src){
  for (var key in src) obj[key] = src[key];
  return obj;
}




