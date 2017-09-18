require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Tags Requests', :type => :request do
  let!(:tag) { FactoryGirl.create(:tag, title: 'The best tag') }
  let!(:task) { FactoryGirl.create(:task, title: 'The most important task') }

  context 'GET index' do
    let(:body) {
      {
          data: [{
                     id: "#{tag.id}",
                     type: 'tags',
                     attributes: {
                         title: tag.title
                     },
                     relationships: {
                         tasks: tag.tasks.empty? ? {data: []} : tag.tasks
                     }
                 }]
      }
    }

    it 'returns tags' do
      get '/api/v1/tags'

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(body.to_json)
    end

    context 'includes tasks' do
      let(:relationship) {
        Api::V1::TasksSerializer.new(task).attributes[:tasks]
      }
      before do
        tag.tasks << task
      end
      it 'returns tasks including tasks' do
        get '/api/v1/tags', headers: {'Content-Type' => 'application/json'}

        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'POST create' do
    let(:query_params) {
      {

          data:
              {
                  type: "undefined",
                  id: "undefined",
                  attributes: {
                      title: "Someday"
                  }
              }
      }
    }
    let(:relationship) {
      {"tasks" => {"data" => []}}
    }
    it 'creates a new tag' do
      post '/api/v1/tags', params: query_params

      expect(response).to have_http_status(:created)

      data = JSON.parse(response.body)['data']
      expect(data['type']).to eq('tags')
      expect(data['attributes']).to eq({"title" => "Someday"})
      expect(data['relationships']).to eq(relationship)
    end
  end

  context 'PATCH update' do
    before(:each) do
      task.tasks_tags.create(tag: tag)
    end

    let(:params) {
      {

          data: {
              type: 'tasks',
              id: task.id,
              attributes: {
                  title: 'Updated Tag Title'}
          }

      }
    }

    let(:res) {
      {"data" => {
          "id" => "#{tag.id}",
          "type" => "tags",
          "attributes" => {
              "title" => "Updated Tag Title"},
          "relationships" => {
              "tasks" => {
                  "data" => [
                      {"id" => "#{task.id}", "type" => "tasks"}
                  ]}
          }}}
    }
    it 'updates an existing tag and task title' do
      expect(task.title).to eq("The most important task")

      patch "/api/v1/tags/#{tag.id}", params: params

      tag.reload
      expect(tag.title).to eq("Updated Tag Title")

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(res.to_json)

    end
  end

end
