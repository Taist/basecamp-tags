Q = require 'q'

require('react/lib/DOMProperty').ID_ATTRIBUTE_NAME = 'data-vrbst-reactid'

extend = require 'react/lib/Object.assign'
generateGUID = require './helpers/generateGUID'

appData = {}

appData.tagsIndex = {}

appData.todosIndex = {}

appData.tagsLinks = {}

app =
  api: null
  exapi: {}

  options:
    isFilterExpanded: true
    filteredTag: null

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
      unless tag.id
        tag.id = generateGUID()

      app.exapi.setPartOfCompanyData 'tagsIndex', tag.id, tag
      .then ->

        appData.tagsIndex[tag.id] = tag

        app.basecamp.updateControl()
        app.helpers.getTodosByTag(tag.id)?.map (todoId) ->
          app.basecamp.updateTodo todoId

        tag
      .catch (error) ->
        console.log error

    onAssignTag: (todoId, tagId) ->
      console.log 'onAssignTag', todoId, tagId
      app.helpers.loadTags todoId
      .then (tags) ->
        if tags.indexOf(tagId) < 0
          tags.push tagId
          app.helpers.setTags todoId, tags
          .then ->
            app.helpers.buildTagsLinks todoId, tags
        else
          tags
      .catch (error) ->
        console.log error

    onDeleteTag: (todoId, tagId) ->
      console.log 'onDeleteTag', todoId, tagId
      app.helpers.loadTags todoId
      .then (tags) ->
        tags = tags.filter (tag) -> tag isnt tagId
        app.helpers.setTags todoId, tags
        .then ->
          app.helpers.buildTagsLinks todoId, tags
      .catch (error) ->
        console.log error

    onTagFilter: (tagId) ->
      app.options.filteredTag = tagId
      #app.exapi.setUserData 'options', app.options
      app.helpers.filterTodos()

    onToggleFilter: (isFilterExpanded) ->
      app.options.isFilterExpanded = isFilterExpanded
      app.exapi.setUserData 'options', app.options

  basecamp: {}

  helpers:
    isTargetPage: () ->
      if location.href.match /\/people\/\d+$/ then return true
      if location.href.match /\/projects\/\d+$/ then return true
      if location.href.match /\/projects\/\d+\/todolists\/\d+$/ then return true
      false

    filterTodos: () ->
      tagId = app.options.filteredTag
      selectedTodos = app.helpers.getTodosByTag(tagId) or []

      [].slice.call(document.querySelectorAll('li.todo')).map (elem) ->
        if tagId? and app.helpers.isTargetPage() and selectedTodos.indexOf(elem.id) < 0
          elem.style.display = 'none'
        else
          elem.style.display = ''


    buildTagsLinks: (todoId, tags) ->
      tags = [] unless tags
      tags.forEach (tagId) ->
        unless appData.tagsLinks[tagId]
          appData.tagsLinks[tagId] = []
        if appData.tagsLinks[tagId].indexOf(todoId) < 0
          appData.tagsLinks[tagId].push todoId
      tags

    loadTags: (todoId) ->
      app.exapi.getPartOfCompanyData 'todosTags', todoId
      .then (tags) ->
        app.helpers.buildTagsLinks todoId, tags

    getTags: (todoId) ->
      Q.resolve appData.todosIndex[todoId] ? []

    getTodosByTag: (tagId) ->
      appData.tagsLinks[tagId]

    setTags: (todoId, tags) ->
      app.exapi.setPartOfCompanyData 'todosTags', todoId, tags
      .then () ->
        appData.todosIndex[todoId] = tags

    loadTodosIndex: ->
      app.exapi.getCompanyData 'todosTags'
      .then (index) ->

        app.basecamp.updateControl()
        for todoId, tags of index
          if appData.todosIndex[todoId]?.join() isnt tags.join()
            appData.todosIndex[todoId] = tags
            app.basecamp.updateTodo todoId

        appData.todosIndex = {}
        extend appData.todosIndex, index

        for todoId, tags of appData.todosIndex
          app.helpers.buildTagsLinks todoId, tags

        appData.todosIndex

    loadAllTags: ->
      app.exapi.getCompanyData 'tagsIndex'
      .then (index) ->
        extend appData.tagsIndex, index

    getAllTags: ->
      tagsList = []
      for id, tag of appData.tagsIndex
        tagsList.push id

      f = (a) -> appData.tagsIndex[a].name.toLowerCase()
      tagsList.sort (a, b) -> if f(a) > f(b) then 1 else -1

      { tagsList, tagsIndex: appData.tagsIndex }

module.exports = app
