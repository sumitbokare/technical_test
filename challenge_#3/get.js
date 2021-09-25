const _ = require("lodash");

var object = { 'x': [{ 'y': { 'z': 'a' } }] };

console.log(_.get(object, 'x[0].y.z'));
