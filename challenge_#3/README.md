# Get value from nested object using lodash

This funtion uses lodash to retrieve value from nested object. We have used `_get` funtion to achieve this.

- [Lodash Installation](#lodash-installation)
- [_get Function ](#_get-function)
- [Usage](#usage)
- [Test](#test)


## Lodash Installation

```shell
$ npm i -g npm
$ npm i lodash
```


## \_get Function

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


## Test

```js
var object = { 'x': [{ 'y': { 'z': 'a' } }] };

console.log(_.get(object, 'x[0].y.z'));

		
Output:
a
```
