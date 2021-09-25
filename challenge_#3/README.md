# Get value from nested object using lodash

## Installation

```shell
$ npm i -g npm
$ npm i lodash
```


## \_get  

```shell
_.get(object, path, [defaultValue])
```

** Arguments: **

| Name | Description |
|------|-------------|
| `object (Object)` | The object to query. |
| `path (Array|string)` | The path of the property to get. |
| `[defaultValue] (*)` | The value returned for undefined resolved values. |


## Usage

```shell
node get.js

```


## Example

```js
var object = { 'x': [{ 'y': { 'z': 'a' } }] };

console.log(_.get(object, 'x[0].y.z'));

		
Output:
a
```