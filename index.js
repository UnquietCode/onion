require('coffee-script/register');

global.Require = function(name) {
	return require(process.cwd()+"/"+name)
};
Require.root = process.cwd();

module.exports = require("./src/WriteTemplate.coffee");