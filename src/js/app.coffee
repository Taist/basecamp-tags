Q = require 'q'

require('react/lib/DOMProperty').ID_ATTRIBUTE_NAME = 'data-vrbst-reactid'

extend = require 'react/lib/Object.assign'
generateGUID = require './helpers/generateGUID'

appData = {}

appData.tags = [
  {
    id: generateGUID()
    name: 'SEO'
    color: 'white'
  },
  {
    id: generateGUID()
    name: 'CPQ'
    color: 'white'
  }
]

app =
  api: null
  exapi: {}

  observer: null

  # todoContainers: {}

  init: (api) ->
    app.api = api

    app.exapi.setUserData = Q.nbind api.userData.set, api.userData
    app.exapi.getUserData = Q.nbind api.userData.get, api.userData

    app.exapi.setCompanyData = Q.nbind api.companyData.set, api.companyData
    app.exapi.getCompanyData = Q.nbind api.companyData.get, api.companyData

    app.exapi.updateCompanyData = (key, newData) ->
      app.exapi.getCompanyData key
      .then (storedData) ->
        updatedData = {}
        extend updatedData, storedData, newData
        app.exapi.setCompanyData key, updatedData
        .then ->
          updatedData

  actions: null

  helpers:
    getTags: (id) ->
      appData.tags

module.exports = app
