Q = require 'q'

require('react/lib/DOMProperty').ID_ATTRIBUTE_NAME = 'data-vrbst-reactid'

extend = require 'react/lib/Object.assign'
generateGUID = require './helpers/generateGUID'

appData = {}

appData.tagsIndex = {}

tagColors = "#fc9,#c9c,#9cf,#cfc,#cf9,#9cc,#c9f,#fcc,#f9c,#cc9,#9fc,#ccf".split(',')

app =
  api: null
  exapi: {}

  todoContainers: {}

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
      console.log 'onSaveTag', tag
      unless tag.id
        tag.id = generateGUID()
        tag.color = tagColors[Date.now()%tagColors.length]

      app.exapi.setPartOfCompanyData 'tagsIndex', tag.id, tag
      .then ->
        appData.tagsIndex[tag.id] = tag
        tag

    onAssignTag: (todoId, tagId) ->
      console.log 'onAssignTag', todoId, tagId
      app.helpers.getTags todoId
      .then (tags) ->
        if tags.indexOf(tagId) < 0
          tags.push tagId
          app.helpers.setTags todoId, tags
          .then ->
            tags
        else
          tags
      .catch (error) ->
        console.log error

    onDeleteTag: (todoId, tagId) ->
      console.log 'onDeleteTag', todoId, tagId
      app.helpers.getTags todoId
      .then (tags) ->
        tags = tags.filter (tag) -> tag isnt tagId
        app.helpers.setTags todoId, tags
        .then ->
          tags
      .catch (error) ->
        console.log error

  helpers:
    getTags: (todoId) ->
      app.exapi.getPartOfCompanyData 'todosTags', todoId
      .then (tags) ->
        tags ? []

    setTags: (todoId, tags) ->
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
