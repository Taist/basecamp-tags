Q = require 'q'

require('react/lib/DOMProperty').ID_ATTRIBUTE_NAME = 'data-vrbst-reactid'

extend = require 'react/lib/Object.assign'
generateGUID = require './helpers/generateGUID'

appData = {}

appData.tagsIndex = {}

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

    app.exapi.setPartOfCompanyData = Q.nbind api.companyData.setPart, api.companyData
    app.exapi.getPartOfCompanyData = Q.nbind api.companyData.getPart, api.companyData

    app.exapi.updateCompanyData = (key, newData) ->
      app.exapi.getCompanyData key
      .then (storedData) ->
        updatedData = {}
        extend updatedData, storedData, newData
        app.exapi.setCompanyData key, updatedData
        .then ->
          updatedData

  actions:
    onSaveTag: (tag) ->
      unless tag.id
        tag.id = generateGUID()

      app.exapi.setPartOfCompanyData 'tagsIndex', tag.id, tag
      .then ->
        appData.tagsIndex[tag.id] = tag
        tag

    onAssignTag: (todoId, tagId) ->
      console.log 'onAssignTag', todoId, tagId
      app.helpers.getTags todoId
      .then (tags) ->
        console.log tags
        if tags.indexOf(tagId) < 0
          tags.push tagId
          app.helpers.setTags todoId, tags
          .then ->
            tags
        else
          tags
      .catch (error) ->
        console.log error

  helpers:
    getTags: (todoId) ->
      app.exapi.getPartOfCompanyData 'todosTags', todoId
      .then (tags) ->
        tags ? []

    setTags: (todoId, tags) ->
      console.log 'setTags', todoId, tags
      app.exapi.setPartOfCompanyData 'todosTags', todoId, tags

    loadAllTags: ->
      app.exapi.getCompanyData 'tagsIndex'
      .then (index) ->
        extend appData.tagsIndex, index

    getAllTags: ->
      tagsList = []
      for id, tag of appData.tagsIndex
        tagsList.push id
      { tagsList, tagsIndex: appData.tagsIndex }

module.exports = app
