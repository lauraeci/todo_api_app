require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Tasks Requests', :type => :request do
  let!(:task) { FactoryGirl.create(:task, title: 'The best thing') }
  let!(:task2) { FactoryGirl.create(:task, title: 'The next best thing') }

  context 'Get index' do
    it 'gets tasks' do
      get '/api/v1/tasks'

      expect(response).to have_http_status(:ok)
      task1_json = Api::V1::TasksSerializer.new(task).to_json
      task2_json = Api::V1::TasksSerializer.new(task2).to_json
      expect(response.body).to eq([task1_json, task2_json])
    end

    context 'includes tags' do
      let(:relationship) {
        {
            "data" => tag.to_json
        }
      }

      it 'returns tasks including tags' do
        get '/api/v1/tasks', headers: {'Content-Type' => 'application/json'}

        expect(response).to have_http_status(:ok)
        resp = JSON.parse(response.body)
        expect(resp).to eq({})
        expect(relationships).to eq(relationship)
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

    it 'returns tasks including updated tags' do
      post 'api/v1/tasks', params: params, headers: {'Content-Type' => 'application/json'}

      expect(response).to have_http_status(:ok)
      resp = JSON.parse(response.body)[0]['data']
      expect(resp).to eq({})
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
         "included": [{"id": "2", "type": "tags", "attributes": {"title": "Urgent"},
                       "relationships": {"tasks": {"data": [{"id": "2", "type": "tasks"}]}}},
                      {"id": "3", "type": "tags", "attributes": {"title": "Home"},
                       "relationships": {"tasks": {"data": [{"id": "2", "type": "tasks"}]}}}]
        }
      }
      it 'Update Task with Tag (Expect Tags)' do
        patch "/api/v1/tasks/#{task2.id}", params: params

        expect(response).to have_http_status(:ok)
        resp = JSON.parse(response.body)
        expect(resp).to eq({})
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
                "id": task.id,
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