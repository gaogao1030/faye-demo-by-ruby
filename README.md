get started
bundle install
thin start -R config/config.ru -c thin.yml

client.publish("/ninja",{text:"hentai",ext:{authToken:"hentai"}})

you will look Object{text:"hentai"} in console by chrome
