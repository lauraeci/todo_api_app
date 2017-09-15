require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Tasks Requests', :type => :request do
  let!(:task) { FactoryGirl.create(:task, title: 'The best thing') }
  let!(:task2) { FactoryGirl.create(:task, title: 'The next best thing') }

  before(:each) { Timecop.freeze(Time.parse("2015-09-09T00:00:00.000Z")) }

  context 'Get index' do
    let(:task_json) {
      "{\"data\":[{\"id\":\"#{task.id}\",\"type\":\"tasks\",\"attributes\":{\"title\":\"The best thing\"},\"relationships\":{\"tags\":{\"data\":[{\"id\":#{task.id},\"title\":\"Urgent\",\"created_at\":\"2015-09-09T00:00:00.000Z\",\"updated_at\":\"2015-09-09T00:00:00.000Z\"},{\"id\":2,\"title\":\"Home\",\"created_at\":\"2015-09-09T00:00:00.000Z\",\"updated_at\":\"2015-09-09T00:00:00.000Z\"}]}}}}"  }

    it 'gets tasks' do
      get '/api/v1/tasks'

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(task_json)
    end

    context 'includes tags' do
      let(:relationship) {
        {
            "data" => tag.to_json
        }
      }

      let(:tasks_json) {
        "{\"data\":[{\"id\":\"1\",\"type\":\"tasks\",\"attributes\":{\"title\":\"The best thing\"},\"relationships\":{\"tags\":{\"data\":[]}}},{\"id\":\"2\",\"type\":\"tasks\",\"attributes\":{\"title\":\"The next best thing\"},\"relationships\":{\"tags\":{\"data\":[]}}}]}"
      }

      it 'returns tasks including tags' do
        get '/api/v1/tasks', headers: {'Content-Type' => 'application/json'}

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(tasks_json)
      end
    end
  end

  context 'POST create' do
    let(:params) {
      {"data":
           {"type": "undefined",
            "id": "undefined",
            "attributes": {
                "title": "Do Homework"
            }
           }
      }
    }

    let(:task_json) {
      {
          "id" => task.id,
          "title" => "Updated Task Title"
      }
    }

    let(:tag_json) {
      {
          "tags" =>
              [
                  {
                      "id" => 1,
                      "title" => "Urgent"}
              ]
      }
    }

    it 'returns tasks including updated tags' do
      post '/api/v1/tasks', params: params

      expect(response).to have_http_status(:created)
      expect(response.body).to eq("{\"data\":{\"id\":\"0\",\"type\":\"tasks\",\"attributes\":{\"title\":\"Do Homework\"},\"relationships\":{\"tags\":{\"data\":[]}}}}")
    end
  end

  context 'GET show' do
    it 'returns tasks including updated tags' do
      get "/api/v1/tasks/#{task.id}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq("{\"data\":{\"id\":\"1\",\"type\":\"tasks\",\"attributes\":{\"title\":\"The best thing\"},\"relationships\":{\"tags\":{\"data\":[]}}}}")
    end
  end

  context 'PATCH update' do

    context 'with tags' do
      let(:params) {
        {"data":
             {"type": "tasks",
              "id": task.id,

              "attributes": {
                  "title": "Updated Task Title",
                  "tags": ["Urgent", "Home"]
              }
             }
        }
      }

      let(:body) {
        {"data": {
            "id": "#{task.id}",
            "type": "tasks",
            "attributes":
                {"title": "Updated Task Title"},
            "relationships":
                {"tags":
                     {"data":
                          [{"id": "2", "type": "tags"}, {"id": "3", "type": "tags"}]}}},
         "included": [
             {"id": "2", "type": "tags", "attributes": {"title": "Urgent"},
              "relationships": {"tasks": {"data": [{"id": "2", "type": "tasks"}]}}},
             {"id": "3", "type": "tags", "attributes": {"title": "Home"},
              "relationships": {"tasks": {"data": [{"id": "2", "type": "tasks"}]}}}
         ]
        }
      }
      it 'Update Task with Tag (Expect Tags)' do
        patch "/api/v1/tasks/#{task2.id}", params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(body.to_json)
      end
    end

    context 'without tags' do
      let(:params) {
        {"data":
             {"type": "tasks",
              "id": task.id.to_s,

              "attributes": {
                  "title": "Updated Task Title"
              }
             }
        }
      }

      let(:body) {
        {
            "data": {
                "id": "#{task.id}",
                "type": "tasks",
                "attributes": {
                    "title": "Updated Task Title"
                },
                "relationships": {
                    "tags": {
                        "data": []
                    }
                }
            }
        }
      }

      it 'Update Task' do
        patch "/api/v1/tasks/#{task.id}", params: params

        expect(response).to have_http_status(:ok)
        resp = JSON.parse(response.body)
        expect(resp.deep_stringify_keys).to eq(body.deep_stringify_keys)
      end
    end
  end


end