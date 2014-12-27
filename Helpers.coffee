fs = require 'fs'
Handlebars = require 'handlebars'


module.exports = {

  # read a file and render it using the configuration context
  read: (configuration, file) ->
    raw = fs.readFileSync(file, 'utf8')
    compiled = Handlebars.compile(raw)(configuration)
    return JSON.parse(compiled)


  # read each line of user data and prepare for templating
  UserData: (launchConfiguration, path) ->
    file_data = fs.readFileSync(path, 'utf8')
    lines = file_data.match(/[^\r\n]+/g)

    Resources = {}

    Resources[launchConfiguration] =
      Properties:
        UserData: { "Fn::Base64" : { "Fn::Join" : ["\n", lines]} }

    return { Resources: Resources }

}
