# frozen_string_literal: true

require 'json'
require 'rack'

class App
  def initialize
    @data_store = []
    @id_counter = 1
  end

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    if request.request_method == 'GET' && request.path_info == '/memos'
      handle_index(response)
    elsif request.request_method == 'POST' && request.path_info == '/memos'
      handle_create(request, response)
    elsif request.request_method == 'GET' && request.path_info.match(%r{^/memos/\d+$})
      handle_show(request, response)
    elsif request.request_method == 'PUT' && request.path_info.match(%r{^/memos/\d+$})
      handle_update(request, response)
    elsif request.request_method == 'DELETE' && request.path_info.match(%r{^/memos/\d+$})
      handle_delete(request, response)
    else
      response.status = 404
      response.write('Route not found')
    end

    response.finish
  end

  private

  def handle_index(response)
    response['Content-Type'] = 'application/json'
    response.write(@data_store.to_json)
  end

  def handle_create(request, response)
    body = JSON.parse(request.body.read) rescue {}
    if body['title'] && body['content']
      memo = { id: @id_counter, title: body['title'], content: body['content'] }
      @data_store << memo
      @id_counter += 1

      response.status = 201
      response['Content-Type'] = 'application/json'
      response.write(memo.to_json)
    else
      response.status = 400
      response.write('Invalid parameters')
    end
  end

  def handle_show(request, response)
    id = request.path_info.split('/').last.to_i
    memo = @data_store.find { |m| m[:id] == id }
    if memo
      response['Content-Type'] = 'application/json'
      response.write(memo.to_json)
    else
      response.status = 404
      response.write('Memo not found')
    end
  end

  def handle_update(request, response)
    id = request.path_info.split('/').last.to_i
    memo = @data_store.find { |m| m[:id] == id }
    if memo
      body = JSON.parse(request.body.read) rescue {}
      memo[:title] = body['title'] if body['title']
      memo[:content] = body['content'] if body['content']

      response['Content-Type'] = 'application/json'
      response.write(memo.to_json)
    else
      response.status = 404
      response.write('Memo not found')
    end
  end

  def handle_delete(request, response)
    id = request.path_info.split('/').last.to_i
    if @data_store.reject! { |m| m[:id] == id }
      response.status = 204
    else
      response.status = 404
      response.write('Memo not found')
    end
  end
end

